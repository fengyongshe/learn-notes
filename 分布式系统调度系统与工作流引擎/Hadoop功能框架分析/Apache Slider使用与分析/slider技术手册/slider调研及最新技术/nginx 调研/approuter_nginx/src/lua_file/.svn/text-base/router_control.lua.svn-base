#! lua

function log_notice(...)
    if ngx.var.enable_debug == "0" then
        return 0
    end
    return ngx.log(ngx.NOTICE, ... )
end

function log_err(...)
    if ngx.var.enable_debug == "0" then
        return 0
    end
    return ngx.log(ngx.ERROR, ... )
end

function log_dbg(...)
    if ngx.var.enable_debug == "0" then
        return 0
    end
    return ngx.log(ngx.DEBUG, ... )
end


local cjson = require "cjson"
local wd_shared = ngx.shared.worker_shared
local valid_dataset = wd_shared:get("valid_dataset")
local wd_cur, wd_next

if valid_dataset == "1" then
    wd_cur = ngx.shared.worker_data1
    wd_next = ngx.shared.worker_data2
elseif valid_dataset == "2" then
    wd_cur = ngx.shared.worker_data2
    wd_next = ngx.shared.worker_data1
else
    valid_dataset = "1" 
    wd_shared:set("valid_dataset", "1")
    wd_cur = ngx.shared.worker_data1
    wd_next = ngx.shared.worker_data2
end


function decode_set_str(set_str)
    local start_index = 1
    local split_index = 1
    local split_array = {}
    local separator = ";"
    while true do
        local last_index = string.find(set_str, separator, start_index)
        if not last_index then
            local str = string.sub(set_str, start_index, string.len(set_str))
            if string.len(str) > 0 then
                split_array[split_index] = str
            end
            break
        end
        if last_index - start_index then
            split_array[split_index] = string.sub(set_str, start_index, last_index - 1)
            split_index = split_index + 1
        end
        start_index = last_index + string.len(separator)
    end
    
    return split_array
end


function encode_set_str(set_array)
    local set_str = ""
    if not set_array then
        return set_str
    end

    for i, v in ipairs(set_array) do 
        set_str = v..";"..set_str
    end

    log_dbg("encode_set_str = ", set_str)
    return set_str
end

function add_instance(wd, app_name, instance_array)
    local route_count = wd:get(app_name.."_route_count")
    if not route_count then
        route_count = 0
        wd:set(app_name.."_route_count", route_count)
        wd:set(app_name.."_route_pos", 0)
    end

    log_dbg("add_instance: current route count=", route_count)

    local pos
    for i, v in ipairs (instance_array) do 
        wd:set(app_name.."_route_"..route_count, v)
        log_dbg("add_instance: added instance = ", v, ", route_count=", wd:get(app_name.."_route_count"))
        log_dbg("add_instance: instance key = ", app_name.."_route_"..route_count, ", value = ", wd:get(app_name.."_route_"..route_count))
        route_count = route_count + 1
        wd:set(app_name.."_route_count", route_count)
    end
    return 0
end

function find_instance(wd, app_name, instance)
    local route_count = wd:get(app_name.."_route_count")
    if not route_count then
        log_dbg("intance not found 1")
        return -1
    end

    for i=0, route_count-1 do
        if wd:get(app_name.."_route_"..i) == instance then
            log_dbg("instance ", instance, " found at ", i, "\r\n")
            return i
        end
    end

    log_dbg("intance not found 2")
    return -1
end


function del_instance(wd, app_name, instance_array)
    local del_pos=nil
    local last_instance=nil
    local route_count, route_pos
    for i, v in  ipairs(instance_array) do 
        route_count = wd:get(app_name.."_route_count")
        if not route_count or route_count <= 0 then
            return 0
        end

        del_pos = find_instance(wd, app_name, v)
        if del_pos>=0 and del_pos<route_count then
            del_instance_digest(wd, app_name, v)
            --if there's only one instance here, delete the key
            if route_count == 1 then
                wd:delete(app_name.."_route_"..del_pos)
                wd:set(app_name.."_route_count", 0)
                return 0
            end
            -- or, move the last element in
            last_instance = wd:get(app_name.."_route_"..(route_count-1))
            if last_instance then
                wd:set(app_name.."_route_"..del_pos, last_instance)
                -- when any instance is removed, reset round roubin position
                wd:set(app_name.."_route_pos", 0)
                wd:set(app_name.."_route_count", route_count - 1)
                wd:delete(app_name.."_route_"..(route_count-1))
                log_dbg("deleted instance = ", v)
            end
        else
            log_dbg("del_instance: instance not found")
        end
    end
    return 0
end

function add_domain(wd, app_name, domain_array)
    local working_domain_set_str = wd:get(app_name.."_domain_set")
    local index = nil

    for i, v in ipairs(domain_array) do
        wd:set(v, app_name)
        if not working_domain_set_str then
            working_domain_set_str = v
        else
            index = string.find(working_domain_set_str, v)
            if not index then
                working_domain_set_str = working_domain_set_str..";"..v
            end
        end
        log_dbg("added domain name = ", v)
    end
    wd:set(app_name.."_domain_set", working_domain_set_str)
    log_dbg("working_domain_set_str = ", working_domain_set_str)
    return 0
end


function del_domain(wd, app_name, domain_array)
    local working_domain_set_str = wd:get(app_name.."_domain_set")
    for i, v in ipairs(domain_array) do 
        wd:delete(v)
        log_dbg("deleted domain name = ", v)
        working_domain_set_str = string.gsub(working_domain_set_str, v, "")
    end
    wd:set(app_name.."_domain_set", working_domain_set_str)
    return 0
end


function set_app_info(wd, app_name, app_info_table)
    if app_info_table['max_connections'] then
        wd:set(app_name.."_max_connections", app_info_table['max_connections'])
    end

    if app_info_table['quota'] then
        wd:set(app_name.."_qouta", app_info_table['quota'])
    end
    
    if app_info_table['auth'] then
        wd:set(app_name.."_auth", app_info_table['auth'])
    end

    if app_info_table['auth_method'] then
        wd:set(app_name.."_auth_method", app_info_table['auth_method'])
    end

    if app_info_table['auth_user'] then
        wd:set(app_name.."_auth_user", app_info_table['auth_user'])
    end

    if app_info_table['auth_pass'] then
        wd:set(app_name.."_auth_pass", app_info_table['auth_pass'])
    end

    if app_info_table['apphash'] then
        wd:set(app_name.."_apphash", app_info_table['apphash'])
    end

    return 0
end
function del_app_info_set(wd, req_table)
    local app_name_array=req_table['app_name_set']
    if not app_name_array then
        return 1
    end
    for i, v in ipairs(app_name_array) do
        if del_app_info(wd, v, req_table) then
            return 2
        end
    end
    return 0
end

function del_app_info(wd, app_name, req_table)
    log_dbg("del_app_info: app_name = ", app_name)
    local seq_num = req_table['seq_num']
    local route_count = wd:get(app_name.."_route_count")
    if route_count or route_count >0 then
        local instance, digest
        for i=0, route_count-1 do 
            --delete app digest
            instance = wd:get(app_name.."_route_"..i)
            del_instance_digest(wd, app_name, instance)
            --delete app instances
            wd:delete(app_name.."_route_"..i)
        end
    end

    -- delete app info
    wd:delete(app_name.."_route_count")
    wd:delete(app_name.."_route_pos")
    wd:delete(app_name.."_auth")
    wd:delete(app_name.."_auth_method")
    wd:delete(app_name.."_auth_user")
    wd:delete(app_name.."_auth_pass")
    wd:delete(app_name.."_quota")
    wd:delete(app_name.."_max_connections")

    -- delete app domains
    local domain_array = decode_set_str(wd:get(app_name.."_domain_set"))
    del_domain(wd, app_name, domain_array)

    wd:delete(app_name.."_domain_set")

    return 0
end


function refresh_commit()
    if valid_dataset == "1" then
        -- set valid dataset to 2
        wd_shared:set("valid_dataset", "2")
    elseif valid_dataset == "2" then
        -- set valid dataset to 1
        wd_shared:set("valid_dataset", "1")
    end
    wd_cur:flush_all()
    log_dbg("previous dataset = ", valid_dataset, ", new dataset = ", wd_shared:get("valid_dataset"), "\r\n")
    return 0
end


function set_instance_to_digest(wd, map_table)
    wd:set(map_table['instance'], map_table['digest'])
    log_dbg("set_instance_to_digest: instance=", map_table['instance'], " ,digest=", map_table['digest'])
    return 0
end


function set_digest_to_instance(wd, map_table)
    wd:set(map_table['digest'], map_table['instance'])
    log_dbg("set_digest_to_instance: digest=", map_table['digest'], " ,instance=", map_table['instance'])
    return 0
end


function del_instance_digest(wd, app_name, instance)
    local digest = wd:get(instance)
    if not digest then
        return 1
    end

    wd:delete(app_name.."_"..digest)
    wd:delete(instance)
    return 0
end



function status_ok(seq_num)
    local res_table = {}
    res_table['seq_num'] = ""..seq_num
    res_table['code'] = "0"
    res_table['msg'] = "success"
    ngx.status = ngx.HTTP_OK
    ngx.say(cjson.encode(res_table))
    ngx.exit(0)
end


function status_err(seq_num, err_msg, err_code)
    local res_table = {}
    res_table['seq_num'] = seq_num
    res_table['code'] = ""..err_code
    res_table['msg'] = err_msg
--    ngx.status = ngx.HTTP_OK
    ngx.status = ngx.HTTP_NOT_ALLOWED
    ngx.say(cjson.encode(res_table))
    ngx.exit(0)
end


function dump_json(json_str)
    log_dbg("json_str= ", json_str, "\r\n")
    local json_table = {}
    json_table = cjson.decode(json_str)
    if not json_table then
        log_dbg( "dump_json : json table empty")
        return nil
    end
    local k
    for k ,v in ipairs(json_table) do 
        if k=="domain_set" or k=="instance_set" then
            for kk, vv in ipairs(v) do
                log_dbg("dump_json : kk = ", kk, ", vv = ", vv)

            end
        else
            log_dbg( "dump_json : k= ", k, " , value = ", v)
        end 
    end
end



function process_command(cmd_table)
    
    local cmd = cmd_table['command']
    local cmd_type = cmd_table['type']
    local seq_num = cmd_table['seq_num']
    
    log_dbg("process_command: cmd = ", cmd, ", cmd_type = ", cmd_type, ", seq_num = ", seq_num )
    
    -- choose working dataset according command type
    local wd = nil
    if cmd_type == "update" then
        wd = wd_cur
    elseif cmd_type == "refresh" then
        wd = wd_next
    else
        return 1001, seq_num
    end
    
    local app_name = cmd_table['app_name']
    log_dbg("process_command: app_name = ", app_name)

    local res
    -- set_app_info
    if cmd == "set_app_info" then
        res = set_app_info(wd, app_name, cmd_table)
        if res ~= 0 then
            res=1002
        end
    -- del_app_info
    elseif cmd == "del_app_info" then
        res = del_app_info_set(wd, cmd_table)
        if res ~= 0 then
            res=1003
        end
    -- add_instance
    elseif cmd == "add_instance" then
        local instance_array = cmd_table['instance_set']
        res = add_instance(wd, app_name, instance_array)
        if res ~= 0 then
            res=1004
        end
    -- del_instance
    elseif cmd == "del_instance" then
        local instance_array = cmd_table['instance_set']
        res = del_instance(wd, app_name, instance_array)
        if res ~= 0 then
            res=1005
        end
    -- add_domain
    elseif cmd == "add_domain" then
        local domain_array = cmd_table['domain_set']
        res = add_domain(wd, app_name, domain_array)
        if res ~= 0 then
            res=1006
        end
    -- del_domain
    elseif cmd == "del_domain" then
        local domain_array = cmd_table['domain_set']
        res = del_domain(wd, app_name, domain_array)
        if res ~= 0 then
            res=1007
        end
    -- refresh_commit
    --[[
    elseif cmd == "refresh_commit" then
        res = refresh_commit()
        if res ~= 0 then
            res=1008
        end
    ]]
    -- set_instance_to_digest
    elseif cmd == "set_instance_to_digest" then
        res = set_instance_to_digest(wd, cmd_table)
        if res ~= 0 then
            res=1009
        end
    -- set_digest_to_instance
    elseif cmd == "set_digest_to_instance" then
        res = set_digest_to_instance(wd, cmd_table)
        if res ~= 0 then
            res=1010
        end
        
    end
    return res, seq_num
end


function check_http_100_continue()
    local req_headers = ngx.req.get_headers()
    for k, v in pairs(req_headers) do
        log_dbg("req header k=", k, " , v=", v)
    end

end


-- main function
-- check http 100 continue in header
--check_http_100_continue()

ngx.req.read_body()
local req_data = ngx.req.get_body_data()
if not req_data then
    status_err(0, "request body empty", 1011)
end

--dump_json(req_data)
log_dbg("req_data = ", req_data)

local req_table=cjson.decode(req_data)
if not req_table then
    status_err(0, "error parsing request data", 1000)
end

local seq_num

if req_table['batched_commands'] then
    -- refresh
    local t = req_table['batched_commands'] 
    local res, refresh_cmd
    for i, v in ipairs(t) do
        --log_dbg("t size = ", #t, ", cmd num = ", i, ", type = ", type(v))
        if type(v) == "table" then
            res, seq_num = process_command(v)
        end
        if v['type'] == "refresh" then
            refresh_cmd = 1
        else
            refresh_cmd = 0
        end

        if res ~=0 then
            status_err(seq_num, "error while processing command "..v['command'], res)
        end
    end
    if refresh_cmd == 1 then
        log_dbg("refresh command")
        refresh_commit()
    else
        log_dbg("update command")
    end
else
    -- update
    res, seq_num = process_command(req_table)
    if res ~=0 then
        status_err(seq_num, "error while processing command", res)
    end
    log_dbg("update command")
end

log_dbg("valid_dataset=", wd_shared:get("valid_dataset"))
status_ok(seq_num)

log_dbg("-------------------------------------------")
