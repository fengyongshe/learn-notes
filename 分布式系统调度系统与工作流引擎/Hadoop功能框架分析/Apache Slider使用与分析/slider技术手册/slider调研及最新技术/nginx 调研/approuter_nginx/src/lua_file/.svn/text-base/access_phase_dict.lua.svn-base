#! lua

-- select valid data set
local worker_shared = ngx.shared.worker_shared
local valid_dataset = worker_shared:get("valid_dataset")
local wd = nil

if valid_dataset == "1" then
    wd = ngx.shared.worker_data1
elseif valid_dataset == "2" then
    wd = ngx.shared.worker_data2
else
    ngx.exit(502)
end




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


function get_app_name(hostname)
	-- firstly get app_name with hostname from request
	return wd:get(hostname)
end

function get_app_info(app_name)
	-- then get app_info_table table with app_name from request
	if not app_name then
		log_err("no app_name for get_app_info: ")
		return nil
	end

	local app_info_table = {}
	app_info_table['max_connections'] = wd:get(app_name..'_max_connections')
	app_info_table['auth'] = wd:get(app_name..'_auth')
	app_info_table['quota'] = wd:get(app_name..'_quota')

	log_notice ("\r\n\tapp_info_table[max_connections] = ", app_info_table['max_connections'], 
				"\r\n\tapp_info_table[auth] = ", app_info_table['auth'],
				"\r\n\tapp_info_table[quota] = ", app_info_table['quota'])

	return app_info_table
end


function get_app_route(app_name)
	-- get one instance frome app route list with round robin
	if not app_name then
		log_err("no app_name for get_app_route: ")
		return nil
	end

	local route_count = wd:get(app_name.."_route_count")
    if not route_count then
        log_dbg("app_name=", app_name, ", route_count is nil")
        return nil
    end
	local route_pos_key = app_name.."_route_pos"
	local route_pos = wd:get(route_pos_key)
	local route_next_pos = (route_pos + 1) % route_count 
	local instance = wd:get(app_name.."_route_"..route_pos)

	log_dbg("\r\n\troute instance = ", instance)
	log_dbg("\r\n\troute count=", route_count, " ,route pos=", route_pos, ",route next pos=" ,route_next_pos)
	wd:set(route_pos_key, route_next_pos)
	
	return instance
end


function check_auth(app_info_table)
	if app_info_table["auth"] == "0" then
		return false
	else
		log_err("need auth")
		return true 
	end
end


function http_basic_auth(username, password)
	if not username or not password then
		return false
	end

	if ngx.var.remote_user == username 
		and ngx.var.remote_passwd == password then
		return true
	else
		ngx.header.www_authenticate = [[Basic realm="Restricted"]]
		ngx.exit(401)
	end

end

function get_auth_info(app_name)
	-- get username and password for app_name
	if not app_name then
		log_err("no app_name for get_auth_info: ")
		return nil
	end

	local auth_table
	auth_table['method'] = wd:get(app_name..'_auth_method')
	auth_table['username'] = wd:get(app_name..'_auth_username')
	auth_table['password'] = wd:get(app_name..'_auth_password')

	return auth_table
end

function get_curr_conn_num (app_name)
	
end


function check_conn_limit(max_conn)
	return false	
end


function check_quota(quota)
	if quota == "0" then
		return false
	else 
		return true 
	end
end


function instance_to_digest(instance)
	return wd:get(instance)
end

function digest_to_instance(digest_app)
	return wd:get(digest_app)	
end

function check_persist()
	local cookie = ngx.var.http_cookie
	if not cookie then
        log_dbg("no cookie in the request")
		return nil
	end

--[[	local i, j = string.find(cookie, "CMRI_LB=")
	local digest_length = 5
	if not i or not j then
		log_err("cannot find lb magic string!")
		return nil
	end

	return string.sub(cookie, j+1, j+1+digest_length-1)
--]]
    log_dbg("cookie found in request : ", cookie,"###")
    local d_start=nil
    local d_end=nil 
    local digest=nil
    d_start = string.find(cookie, "CMRI_LB=")
    if d_start then
        d_start = d_start + 8
        digest = string.sub(cookie, d_start, -1)
        log_dbg("d_start = ", d_start, " , digest = ", digest)
    end
    if digest then
        d_end = string.find(digest, ';')
        log_dbg("d_end = ", d_end)
    end
    if d_end then 
        digest = string.sub(digest, 1, d_end)
        log_dbg("digest=", digest)
    end

    if digest then
        return digest
    else
        return nil
    end
end


function attach_app_headers(app_name)
    local app_id, app_ver, app_sub_ver= string.match(app_name, "(%w+).(%d+).(%w+)")
--    local apphash = require "apphash"
    log_dbg("app_name=", app_name, ", app_id=", app_id, ", app_ver=", app_ver, ", app_sub_ver=", app_sub_ver)
    if app_id and app_ver and app_sub_ver then
        ngx.req.set_header("X-AppID", app_id)
        ngx.req.set_header("X-AppVersion", app_ver)
        local apphash_val = wd:get(app_name.."_apphash")
--        if not apphash_val then
--            apphash_val = apphash.apphash_crc16(app_id)
--        end
       if apphash_val then
           ngx.req.set_header("X-AppHash", apphash_val)
       end
    end

    local forwarded_for = ngx.req.get_headers()["X-Forwarded-For"]
    if not forwarded_for then
        forwarded_for = ngx.var.remote_addr
    else
        forwarded_for = forwarded_for..", "..ngx.var.remote_addr
    end
        ngx.req.set_header("X-Forwarded-For", forwarded_for)
end




-- first find app_name with hostname from http request
local hostname = ngx.var.host
local app_name = get_app_name(hostname)

if not app_name then
	log_err("app_name not found.")
	ngx.exit(502)
end


-- then find app_info_table with app_name
local app_info_table = nil
app_info_table = get_app_info(app_name)
if not app_info_table then
	log_err("app_info_table empty.")
	ngx.exit(502)
end


-- check whether the app needs to be authenticated
if check_auth(app_info_table) then 
	local auth_table = get_auth_info(app_name)
	if not auth_table then
        log_dbg("auth table empty")
		ngx.exit(502)
	end

	if not http_basic_auth(auth_table['username'], auth_table['password']) then
        log_dbg("check auth failed")
		ngx.exit(502)
	end
	
end
--[[
-- check whether current connection exceed max connection limits
if not check_conn_limit(app_info_table['max_connections']) then
	ngx.exit(502)
end
]]

-- check whether the app quota is available
log_dbg("checking quota")
if app_info_table['quota'] and check_quota(app_info_table['quota']) then 
    log_dbg("check quota failed")
	ngx.exit(502)
end

local app_instance

-- check session persistance
if ngx.var.enable_persist == '1' then
    local digest = check_persist()
    if digest then
    	app_instance = digest_to_instance(app_name.."_"..digest)
        if not app_instance then
            log_dbg("intance digest not found.")
        else
            log_dbg("persist instance = ", app_instance)
        end
    else
        log_dbg("digest not found when checking persistance")
    end
end


-- attach headers for php engine
attach_app_headers(app_name)


-- if no persistance cookie then follow the load balancing scheme
if not app_instance then
	app_instance = get_app_route(app_name)
    log_dbg("get_app_route : app_instance = ", app_instance)
end

if not app_instance then
	ngx.exit(502)
end

-- store instance digest to nginx variable named 'instance_digest'
ngx.var.instance_digest = instance_to_digest(app_instance)
log_dbg("instance digest=", ngx.var.instance_digest)

-- set proxy target
ngx.var.target = app_instance

