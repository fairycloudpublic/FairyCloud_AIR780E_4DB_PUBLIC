--- 模块功能：MQTT客户端数据接收处理

_G.sys = require("sys")
_G.sysplus = require("sysplus")

require"projectConfig"


-----------------MQTT OUT---------------
 --数据发送的消息队列
local msgQueue = {} 

local function insertMsg(topic,payload,qos,user)
    sys.taskInit(function()
        if mqttc and mqttc:ready() then
            local pkgid = mqttc:publish(mqtt_pub_topic, payload, 0)
            
            -- 10S定时上报数据
            sys.timerStart(autoDataStatus,_G.update_time)  

        end
        
    end)

end

local function pubQos0TestCb(result)
    log.info("mqttOutMsg.pubQos0TestCbXXXXXXXXXXXXXXXXXXXXXXXXX",result)
    if result then  sys.timerStart(autoDataStatus,1000) end
end

function trim(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

-- Lua equivalent of the random function in C

-- Check if randomSeed was called and use software PRNG if needed
local function random(howbig)
    if howbig == 0 then
        return 0
    end

    if howbig < 0 then
        return random(0, -howbig)
    end

    -- Generate random value using hardware or software PRNG
    local val = (s_useRandomHW) and esp_random() or math.random()
    
    return val % howbig
end

-- Function to generate random number within a range
local function random_range(howsmall, howbig)
    if howsmall >= howbig then
        return howsmall
    end

    local diff = howbig - howsmall
    return random(diff) + howsmall
end


-- 日期时间转时间戳 注意输出格式是xxxx-02-12 09:30:12
-- 参数可以是  “xxxx-02-12 09:30:12” 或者 表{2019,2,12,9,30,12}
function dataToTimeStamp(dataStr)
    local result = -1
    local tempTable = {}

    if dataStr == nil then
        error("传递进来的日期时间参数不合法")
    elseif type(dataStr) == "string" then
        dataStr = trim(dataStr)
        for v in string.gmatch(dataStr, "%d+") do
            tempTable[#tempTable + 1] = v
        end
    elseif type(dataStr) == "table" then
        tempTable = dataStr
    else
        error("传递进来的日期时间参数不合法")
    end
    tempTable[4] = tonumber(tempTable[4]) - 8;
    result = os.time({
        day = tonumber(tempTable[3]),
        mon = tonumber(tempTable[2]),
        year = tonumber(tempTable[1]),
        hour = tonumber(tempTable[4]),
        min = tonumber(tempTable[5]),
        sec = tonumber(tempTable[6])
    })
    return result
end


-- 10s自动上报数据 默认
function autoDataStatus()

    
    local tmm1 = os.date()
    local tmm2 = os.date("%Y-%m-%d %H:%M:%S")
    local tmm3 = os.date("*t")

    local tm = rtc.get()
    local tjsondata,result,errinfo = json.decode(REPORT_DATA_TEMPLATE)
    if result and type(tjsondata)=="table" then
    
        local reporttime=os.date("%Y-%m-%d %H:%M:%S")
        local times=os.date("%Y-%m-%d %H:%M:%S")
        --local times = string.format("%04d-%02d-%02d %02d:%02d:%02d", tm.year, tm.mon, tm.day, tm.hour, tm.min, tm.sec)
        --local reporttime = string.format("%04d-%02d-%02d %02d:%02d:%02d", tm.year, tm.mon, tm.day, tm.hour+8, tm.min, tm.sec)
        -- log.info("------------>reporttime",reporttime)
        tjsondata["reporttime"] = reporttime;

        local did = string.lower(crypto.md5(reporttime.."0"..random(1000)))
        tjsondata["did"] = did;
        tjsondata["cid"] = SRCCID;




        -- 四个继电器获状态
        if (gpio.get(RC1) == 1)  then
            tjsondata["rc1"] = "open"
        else
            tjsondata["rc1"] = "close"
        end

        if (gpio.get(RC2) == 1)  then
            tjsondata["rc2"] = "open"
        else
            tjsondata["rc2"] = "close"
        end

        if (gpio.get(RC3) == 1)  then
            tjsondata["rc3"] = "open"
        else
            tjsondata["rc3"] = "close"
        end

        if (gpio.get(RC4) == 1)  then
            tjsondata["rc4"] = "open"
        else
            tjsondata["rc4"] = "close"
        end

        
        tjsondata["temperature"] = _G.temperature;
        tjsondata["humidity"] = _G.humidity;
        tjsondata["electricity"]=  _G.electricity;
        tjsondata["version"]= _G.version;


        
        if ( _G.autoCombineFlag == true) then
            tjsondata["demand"] = _G.demand_count;
        end
        

    else
        log.info("testJson error",errinfo)
    end
    -----------------------decode测试------------------------

    pubQos0Send(json.encode(tjsondata)) --发送数据

    wdt.init(25000) -- 初始化watchdog设置为9s
    sys.timerLoopStart(wdt.feed, 21000) -- 3s喂一次狗

end

--发送数据 传入数据
function pubQos0Send(sedData)

    log.info("sedData:",sedData)
    
    insertMsg(mqtt_pub_topic,sedData,0,{cb=pubQos0TestCb})
end

--- 初始化“MQTT客户端数据发送”
-- @return 无
-- @usage mqttOutMsg.init()
function init()
    autoDataStatus()
end

--- 去初始化“MQTT客户端数据发送”
-- @return 无
-- @usage mqttOutMsg.unInit()
function unInit()
    sys.timerStop(autoDataStatus)
end


--- MQTT客户端数据发送处理
-- @param mqttClient，MQTT客户端对象
-- @return 处理成功返回true，处理出错返回false
-- @usage mqttOutMsg.proc(mqttClient)
--function sedproc(mqttClient)
--    while #msgQueue>0 do
--        local outMsg = table.remove(msgQueue,1)
--        local result = mqttClient:publish(outMsg.t,outMsg.p,outMsg.q)
--        if outMsg.user and outMsg.user.cb then outMsg.user.cb(result,outMsg.user.para) end
--        if not result then return end
--    end
--    return true
--end


function CLIEND_SEND_DATA()
    sys.taskInit(function()
        
        autoDataStatus()
       
    end)

end
-----------------MQTT IN------------------------------------------

--- MQTT客户端数据接收处理
function SERVER_SEND_DATA(topic, payload)

    if topic == mqtt_sub_topic then

        local tjsondata,result,errinfo = json.decode(payload)
        if result and type(tjsondata)=="table" then

            --开始数据解析
            local cmdType = tjsondata["cmdtype"];
            local cmdcontroll = "cmd_controll";
            local cmdcombinecontroll = "cmd_combinecontroll";
            local cmdcombinemonitor = "cmd_combinemonitor";
            local cmdstatus = "cmd_status";
            local cmdstatusack = "cmd_statusack";
            local did = tjsondata["did"];
            local tm = rtc.get()
        


            if cmdType == cmdcontroll then
            
                local cmddata = tjsondata["cmddata"];
                local sensorname = cmddata["sensorname"];
                local sensorcmd= cmddata["sensorcmd"];
          
                if (sensorname == "rc1") then
                    log.info(sensorcmd);
                    if(sensorcmd == "open") then
                    
                        CT_RC1(1)
                        log.info('rc1 open')
                        log.info("rc1", gpio.get(RC1))

                    elseif(sensorcmd == "close") then
                    
                        CT_RC1(0)
                        log.info('rc1 close')
                        log.info("rc1", gpio.get(RC1))

                    else
                        log.info(sensorcmd);
                    end
                elseif (sensorname == "rc2") then
                    log.info(sensorcmd);
                    if(sensorcmd == "open") then
                    
                        CT_RC2(1)
                        log.info('rc2 open')
                    elseif(sensorcmd == "close") then
                    
                        CT_RC2(0)
                        log.info('rc2 close')
                    else
                        log.info(sensorcmd);
                    end
                elseif (sensorname == "rc3") then
                    log.info(sensorcmd);
                    if(sensorcmd == "open") then
                    
                        CT_RC3(1)
                        log.info('rc3 open')
                    elseif(sensorcmd == "close") then
                    
                        CT_RC3(0)
                        log.info('rc3 close')
                    else
                        log.info(sensorcmd);
                    end
                elseif (sensorname == "rc4") then
                    log.info(sensorcmd);
                    if(sensorcmd == "open") then
                    
                        CT_RC4(1)
                        log.info('rc4 open')
                    elseif(sensorcmd == "close") then
                    
                        CT_RC4(0)
                        log.info('rc4 close')
                    else
                        log.info(sensorcmd);
                    end
                
                elseif (sensorname == "status") then

                    if(sensorcmd == "open") then
                        
                        log.info("status");
                          -- 基础数据查询 底部默认会上报数据，不用在这里单独设置
                        -- autoDataStatus()
                    end
                elseif (sensorname == "combinemonitor") then

                    if(sensorcmd == "open") then
                        
                        log.info("combinemonitor");
                          -- 基础数据查询 底部默认会上报数据，不用在这里单独设置
                          sys.publish("SERVER_SEND_AUTOCOMBINE", cmdcombinemonitor, payload)
                        end
                elseif (sensorname == "restart") then

                    if(sensorcmd == "open") then
                        
                        log.info("restart");

                        rtos.restart()
                    end
                else
                    log.info(sensorname);
                end 
       
                ----进行远控数据返回操作
               local sdsondata,result,errinfo = json.decode(REPORT_CONTROLLACK_TEMPLATE)
                if result and type(sdsondata)=="table" then

                    local tm = rtc.get()

                    local reporttime = string.format("%04d-%02d-%02d %02d:%02d:%02d", tm.year, tm.mon, tm.day, tm.hour+8, tm.min, tm.sec)
                    
                    sdsondata["reporttime"] = reporttime;
                    sdsondata["cid"] = SRCCID;
                    sdsondata["did"] = did;

                    pubQos0Send(json.encode(sdsondata)) --发送数据

                else
                    log.info("testJson.decode error",errinfo)
                end
                
                autoDataStatus()
                
                --结束发送
            elseif cmdType == cmdstatus then
                log.info("cmd_status");
                    -- 基础数据查询
                    autoDataStatus()
            elseif cmdType == cmdcombinecontroll then
                log.info("cmd_combinecontroll");
                sys.publish("SERVER_SEND_AUTOCOMBINE", cmdcombinecontroll, payload)


                ----进行远控数据返回操作
                local sdsondata,result,errinfo = json.decode(REPORT_CONTROLLACK_TEMPLATE)
                if result and type(sdsondata)=="table" then

                    local tm = rtc.get()

                    local reporttime = string.format("%04d-%02d-%02d %02d:%02d:%02d", tm.year, tm.mon, tm.day, tm.hour+8, tm.min, tm.sec)
                    
                    sdsondata["reporttime"] = reporttime;
                    sdsondata["cid"] = SRCCID;
                    sdsondata["did"] = did;

                    pubQos0Send(json.encode(sdsondata)) --发送数据

                else
                    log.info("testJson.decode error",errinfo)
                end
 
                autoDataStatus()


            elseif cmdType == cmdcombinemonitor then
                log.info("cmd_combinecontroll");
                sys.publish("SERVER_SEND_AUTOCOMBINE", cmdcombinemonitor, payload)


                ----进行远控数据返回操作
                local sdsondata,result,errinfo = json.decode(REPORT_CONTROLLACK_TEMPLATE)
                if result and type(sdsondata)=="table" then

                    local tm = rtc.get()

                    local reporttime = string.format("%04d-%02d-%02d %02d:%02d:%02d", tm.year, tm.mon, tm.day, tm.hour+8, tm.min, tm.sec)
                    
                    sdsondata["reporttime"] = reporttime;
                    sdsondata["cid"] = SRCCID;
                    sdsondata["did"] = did;

                    pubQos0Send(json.encode(sdsondata)) --发送数据

                else
                    log.info("testJson.decode error",errinfo)
                end
 
                autoDataStatus()
            elseif cmdType == cmdstatusack then
                log.info("cmd_statusack");
        
            else
                log.info(cmdType);
        
            end
        
            --数据解析结束 返回服务端信息

        else
            log.info("testJson.decode error",errinfo)
        end

    end

end

-- 自动发送数据到服务器
sys.subscribe("CLIEND_SEND_DATA",CLIEND_SEND_DATA)


-- 订阅 
sys.subscribe("SERVER_SEND_DATA",SERVER_SEND_DATA)

--手动返回一个table，包含了上面的函数
return {
    init = init,
    unInit = unInit,
    procaa = procaa,
}
