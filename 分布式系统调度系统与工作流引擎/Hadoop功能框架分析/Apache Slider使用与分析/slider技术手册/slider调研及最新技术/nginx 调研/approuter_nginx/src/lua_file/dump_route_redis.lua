local parser = require "redis.parser"
local worker_data = ngx.shared.worker_data
if not worker_data then
	ngx.log(ngx.ERR, "worker_data is nil\r\n")
end


function redis_get(key)
	local res = ngx.location.capture(
			"/redis_get", 
			{args = {key = key}}
			)

	if res.status ~=200 then 
		ngx.log(ngx.ERR, "redis_get(", key, "), server returned bad status: ", res.status)
		return nil
	end

	if not res.body then 
		ngx.log(ngx.ERR, "redis_get(", key, "), returned empty body")
		return nil
	end

	local ret, typ = parser.parse_reply(res.body)

	if typ ~= parser.BULK_REPLY or not ret then 
		ngx.log(ngx.ERR, "redis_get(", key, "), bad redis response: ", res.body)
		return nil
	end

	return ret 
end


function redis_llen(key)
	local res = ngx.location.capture(
			"/redis_llen", 
			{args = {key = key}}
			)

	if res.status ~=200 then 
		ngx.log(ngx.ERR, "redis_llen(", key, "), server returned bad status: ", res.status)
		return nil
	end

	if not res.body then 
		ngx.log(ngx.ERR, "redis_llen(", key, "), returned empty body")
		return nil
	end

	local ret, typ = parser.parse_reply(res.body)

	if typ ~= parser.INTEGER_REPLY or not ret then 
		ngx.log(ngx.ERR, "redis_llen(", key, "), bad redis response: ", res.body)
		return nil
	end

	return ret 
end


function redis_lpush(key, value)
	local res = ngx.location.capture(
			"/redis_lpush", 
			{args = {key = key, value=value}}
			)

	if res.status ~=200 then 
		ngx.log(ngx.ERR, "redis_lpush(", key, "), server returned bad status: ", res.status)
		return nil
	end

	if not res.body then 
		ngx.log(ngx.ERR, "redis_lpush(", key, "), returned empty body")
		return nil
	end

	local ret, typ = parser.parse_reply(res.body)

	if typ ~= parser.INTEGER_REPLY or not ret then 
		ngx.log(ngx.ERR, "redis_lpush(", key, "), bad redis response: ", res.body)
		return nil
	end

	return ret 
end


function redis_rpop(key)
	local res = ngx.location.capture(
			"/redis_rpop", 
			{args = {key = key}}
			)

	if res.status ~=200 then 
		ngx.log(ngx.ERR, "redis_rpop(", key, "), server returned bad status: ", res.status)
		return nil
	end

	if not res.body then 
		ngx.log(ngx.ERR, "redis_rpop(", key, "), returned empty body")
		return nil
	end

	local ret, typ = parser.parse_reply(res.body)

	if typ ~= parser.BULK_REPLY or not ret then 
		ngx.log(ngx.ERR, "redis_rpop(", key, "), bad redis response: ", res.body)
		ngx.log(ngx.ERR, "redis_rpop(", key, "), ret ", ret, " typ ", typ )
		return nil
	end

	return ret 
end



function redis_lrange(key, i, j)
	local res = ngx.location.capture (
			"/redis_lrange",
			{args = {key = key, i=i, j=j}}
			)

	if res.status ~=200 then 
		ngx.log(ngx.ERR, "redis_lrange(", key, "), server returned bad status: ", res.status)
		return nil
	end

	if not res.body then 
		ngx.log(ngx.ERR, "redis_lrange(", key, "), returned empty body")
		return nil
	end

	local ret_array, typ = parser.parse_reply(res.body)
	if typ ~= parser.MULTI_BULK_REPLY or not ret_array then 
		ngx.log(ngx.ERR, "redis_lrange(", key, "), bad redis response: ", res.body)
		return nil
	end

	return ret_array
end



function redis_hgetall(key)
	local res = ngx.location.capture (
			"/redis_hgetall",
			{args = {key = key}}
			)

	if res.status ~=200 then 
		ngx.log(ngx.ERR, "redis_hgetall(", key, "), server returned bad status: ", res.status)
		return nil
	end

	if not res.body then 
		ngx.log(ngx.ERR, "redis_hgetall(", key, "), returned empty body")
		return nil
	end

	local ret_hash, typ = parser.parse_reply(res.body)
	if typ ~= parser.MULTI_BULK_REPLY or not ret_hash then 
		ngx.log(ngx.ERR, "redis_hgetall(", key, "), bad redis response: ", res.body)
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
		ngx.log(ngx.ERR, "redis_rpoplpush (", key, "), server returned bad status: ", res.status)
		return nil
	end

	if not res.body then 
		ngx.log(ngx.ERR, "redis_rpoplpush (", key, "),  returned empty body")
		return nil
	end

	local ret, typ = parser.parse_reply(res.body)
	if typ ~= parser.BULK_REPLY or not ret then 
		ngx.log(ngx.ERR, "redis_rpoplpush (", key, "), bad redis response: ", res.body)
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
		ngx.log(ngx.ERR, "no app_name for get_app_info: ")
		return nil
	end

	return redis_hgetall(app_name)
end


function get_app_route(app_name)
	-- get one instance frome app route list with round robin
	if not app_name then
		ngx.log(ngx.ERR, "no app_name for get_app_route: ")
		return nil
	end

	local key = app_name.."_instance_list"
	return redis_rpoplpush(key)
end

function get_auth_info(app_name)
	-- get username and password for app_name
	if not app_name then
		ngx.log(ngx.ERR, "no app_name for get_auth_info: ")
		return nil
	end
	
	local key = app_name.."_auth"
	return redis_hgetall(key)
end

host_num = redis_llen("app_domain_list")

host_array = redis_lrange("app_domain_list", 0, host_num - 1)

for i=1, host_num do 
	local hostname = host_array[i]
	redis_lpush("temp_host_list", hostname)
	local app_name = get_app_name(hostname)

	local succ, err, forcible

	-- host to app table
	succ, err, forcible = worker_data:set(hostname, app_name)
	ngx.say(hostname, " => ", app_name)

	-- app info 
	local app_info_table = get_app_info(app_name)
	worker_data:set(app_name..'_max_connections', app_info_table['max_connections'])
	worker_data:set(app_name..'_auth', app_info_table['auth'])
	worker_data:set(app_name..'_quota', app_info_table['quota'])

	ngx.say(app_name..'_max_connections = ', worker_data:get(app_name..'_max_connections'), "\r\n")
	ngx.say(app_name..'_auth = ', worker_data:get(app_name..'_auth'), "\r\n")
	ngx.say(app_name..'_quota = ', worker_data:get(app_name..'_quota'), "\r\n")


	-- auth info
	local auth_info_table = get_auth_info(app_name)
	if (auth_info_table) then
		worker_data:set(app_name..'_auth_method', auth_info_table['method'])
		worker_data:set(app_name..'_auth_username', auth_info_table['username'])
		worker_data:set(app_name..'_auth_password', auth_info_table['password'])

		ngx.say(app_name..'_auth_method = ', worker_data:get(app_name..'_auth_method'), "\r\n")
		ngx.say(app_name..'_auth_username = ', worker_data:get(app_name..'_auth_username'), "\r\n")
		ngx.say(app_name..'_auth_password = ', worker_data:get(app_name..'_auth_password'), "\r\n")
	end



	local route_list = app_name..'_list'
	local route_array = redis_lrange(route_list, 0, -1)
	local route_count = redis_llen(route_list)


	for i=1, route_count do
		-- instance digest
		local digest = redis_get(route_array[i])
		worker_data:set(route_array[i], digest)
		worker_data:set(digest.."_"..app_name, route_array[i])
		ngx.say(app_name.."\t: INSTANCE_TO_DIGEST "..route_array[i], " => ", worker_data:get(route_array[i]))
		ngx.say(app_name.."\t: DIGEST_TO_INSTANCE "..digest.."_"..app_name, " => ", worker_data:get(digest..'_'..app_name))

		-- route table
		worker_data:set(app_name.."_route_"..i, route_array[i])
		ngx.say(app_name.."\t: ROUTE :"..app_name.."_route_"..i, " -> ", worker_data:get(app_name.."_route_"..i))

	end
	worker_data:set(app_name..'_route_count', route_count)
	worker_data:set(app_name..'_route_pos', 1)
	ngx.say(app_name.."_route_count = ", worker_data:get(app_name.."_route_count"))


end







