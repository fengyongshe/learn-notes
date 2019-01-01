local cjson = require "cjson"

local worker_shared = ngx.shared.worker_shared
local valid_dataset = worker_shared:get("valid_dataset")
local worker_data = nil

if valid_dataset == "1" then
    wd = ngx.shared.worker_data1
elseif valid_dataset == "2" then
    wd = ngx.shared.worker_data2
else
    ngx.exit(502)
end

local keys = wd:keys()
ngx.say("valid_dataset=", worker_shared:get("valid_dataset"))
for i=1, #keys do
    ngx.say("shdict key=", keys[i], " ,value=", wd:get(keys[i]))
end
            
