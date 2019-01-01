#! lua

function log_notice(...)
	return ngx.log(ngx.NOTICE, ... )
end


function log_err(...)
	return ngx.log(ngx.ERROR, ... )
end


function log_dbg(...)
	return ngx.log(ngx.DEBUG, ... )
end

ngx.var.target='127.0.0.1:8001'

local parser = require "redis.parser"


local worker_share = ngx.shared.worker_shared_data



function redis_get(key)
	local res = ngx.location.capture(
			"/redis_get", 
			{args = {key = key}}
			)

	if res.status ~=200 then 
		log_err( "redis_get(", key, "), server returned bad status: ", res.status)
		return nil
	end

	if not res.body then 
		log_err("redis_get(", key, "), returned empty body")
		return nil
	end

	local ret, typ = parser.parse_reply(res.body)

	if typ ~= parser.BULK_REPLY or not ret then 
		log_err("redis_get(", key, "), bad redis response: ", res.body)
		return nil
	end

	return ret 
end

function redis_hgetall(key)
	local res = ngx.location.capture (
			"/redis_hgetall",
			{args = {key = key}}
			)

	if res.status ~=200 then 
		log_err( "redis_hgetall(", key, "), server returned bad status: ", res.status)
		return nil
	end

	if not res.body then 
		log_err("redis_hgetall(", key, "), returned empty body")
		return nil
	end

	local ret_hash, typ = parser.parse_reply(res.body)
	if typ ~= parser.MULTI_BULK_REPLY or not ret_hash then 
		log_err("redis_hgetall(", key, "), bad redis response: ", res.body)
		return nil
	end


	local ret_table = {}
	for k=1, #ret_hash, 2 do
		ret_table[ret_hash[k]] = ret_hash[k+1]
	end

	return ret_table
end



function redis_rpoplpush(key)
	local res = ngx.location.capture (
			"/redis_rpoplpush",
			{args = {key = key}}
			)

	if res.status ~=200 then 
		log_err("redis_rpoplpush (", key, "), server returned bad status: ", res.status)
		return nil
	end

	if not res.body then 
		log_err("redis_rpoplpush (", key, "),  returned empty body")
		return nil
	end

	local ret, typ = parser.parse_reply(res.body)
	if typ ~= parser.BULK_REPLY or not ret then 
		log_err("redis_rpoplpush (", key, "), bad redis response: ", res.body)
		return nil
	end

	return ret 
end


function get_app_name(hostname)
	-- firstly get app_name with hostname from request
	return redis_get(hostname)
end

function get_app_info(app_name)
	-- then get app_info_table table with app_name from request
	if not app_name then
		log_err("no app_name for get_app_info: ")
		return nil
	end

	return redis_hgetall(app_name)
end


function get_app_route(app_name)
	-- get one instance frome app route list with round robin
	if not app_name then
		log_err("no app_name for get_app_route: ")
		return nil
	end

	local key = app_name.."_instance_list"
	return redis_rpoplpush(key)
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

	local key = app_name.."_auth"

	return redis_hgetall(key)
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
	return redis_get(instance)
end

function digest_to_instance(digest)
	return redis_get(digest)
end

function check_persist()
	local cookie = ngx.var.http_cookie
	if not cookie then
		return nil
	end
--[[
	local i, j = string.find(cookie, "CMRI_LB=")
	local digest_length = 5
	if not i or not j then
		log_err("cannot find lb magic string!")
		return nil
	end

	return string.sub(cookie, j+1, j+1+digest_length-1)
]]
	return string.match(cookie, "CMR_LB=(.*)%s*;")
end



function attach_app_headers(app_name)

	local app_id, app_ver, app_sub_ver= string.match(app_name, "(%w+)_(%d+)_(%d+)")
	
	local apphash = require "apphash"
	ngx.req.set_header("X-AppID", app_id)
	ngx.req.set_header("X-AppVersion", app_ver)
	ngx.req.set_header("X-AppHash", apphash.apphash_crc16(app_id))

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
local app_info_table = nil
local app_instance = nil

if not app_name then
	log_err("app_name not found.")
	ngx.exit(502)
end
print (app_name)

-- then find app_info_table with app_name
app_info_table = get_app_info(app_name)
if not app_info_table then
	log_err("app_info_table empty.")
	ngx.exit(502)
end

-- check whether the app needs to be authenticated
if check_auth(app_info_table) then 
	local auth_table = get_auth_info(app_name)
	if not auth_table then
		ngx.exit(502)
	end

	if not http_basic_auth(auth_table['username'], auth_table['password']) then
		ngx.exit(502)
	end
	
end
print ("check auth passed")

-- check whether current connection exceed max connection limits
if check_conn_limit(app_info_table['max_connections']) then
	ngx.exit(502)
end

print ("check conn")

-- check whether the app quota is available
if check_quota(app_info_table['quota']) then 
	ngx.exit(502)
end

print ("check_quota")

-- check session persistance
if ngx.var.enable_persist == '1' then

	local digest = check_persist()

	if digest then
		app_instance = digest_to_instance(digest.."_"..app_name)
	end
end

-- attach headers for php engine
attach_app_headers(app_name)


-- if no persistance cookie then follow the load balancing scheme
if not app_instance then
	app_instance = get_app_route(app_name)
	log_notice("get_app_route : app_instance = ", app_instance)
end

if not app_instance then
	ngx.exit(502)
end
-- store instance digest to nginx variable named 'instance_digest'
ngx.var.instance_digest = instance_to_digest(app_instance)

-- set proxy target
ngx.var.target = app_instance

