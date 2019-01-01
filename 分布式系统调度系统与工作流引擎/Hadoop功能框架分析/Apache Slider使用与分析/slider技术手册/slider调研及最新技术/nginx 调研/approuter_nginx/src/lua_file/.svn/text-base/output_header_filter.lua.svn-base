#! lua

local instance_digest = ngx.var.instance_digest

function log_notice(...)
    return ngx.log(ngx.NOTICE, ... )
end


function log_err(...)
    return ngx.log(ngx.ERROR, ... )
end

function log_dbg(...)
    return ngx.log(ngx.DEBUG, ... )
end


function add_persist_cookie(digest)
	local cookie = ngx.header['Set-Cookie']
    local cookie_table = {}
    if cookie then
        if type(cookie) == "table" then
            cookie[#cookie + 1] = "CMRI_LB="..digest
            cookie_table = cookie
            log_dbg("cookie_table #cookie=", #cookie)
        else
            cookie_table[1] = cookie
	        cookie_table[2] = "CMRI_LB="..digest
            log_dbg("cookie_scalor")
        end
	    ngx.header['Set-Cookie'] = cookie_table
        log_dbg("insert cookie=", digest)
    end
end



log_dbg("instance_digest=", instance_digest)
if instance_digest and ngx.header['Set-Cookie'] then
	add_persist_cookie(instance_digest)
    --log_dbg("digest cookie=", ngx.header['Set-Cookie'])
else
	log_dbg("empty cookie")
end

