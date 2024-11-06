PROJECT = "FairyCloud"
VERSION = "1.0.0"

_G.sys = require("sys")
_G.sysplus = require("sysplus")
require"projectConfig"


-----------必选 以下三选一---------------

--精灵云：加载MQTT功能模块 
require "s_mqtt_fariycloud"

--阿里云：加载MQTT功能模块
-- require "s_mqtt_aliyuncs"
 
--自建服务器：加载HTTP功能模块
--require "s_http_privatecloud"


-- FOTA升级
-- require "fota"


-- 自动化任务
require "autoCombineTask"
-- 加载I²C功能温湿度模块--选择其中一个打开既可
require "SHT30"
-- require "SHT40"



sys.taskInit(function()

    while 1 do
        sys.wait(500)
    end
end)


sys.run()
