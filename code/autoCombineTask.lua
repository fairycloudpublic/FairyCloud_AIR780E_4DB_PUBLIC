_G.sys = require("sys")

_G.sysplus = require("sysplus")
require"projectConfig"

 


-- 自动化任务
local function combinemonitorFunc()
    local  cmdcombine =  _G.combineAutoArr
    -- log.info("combinemonitorFunc:5s")

    local demand_and= "demand_and";
    local demand_or= "demand_or";
    
    local compare_valuetype_String = "String";
    local compare_valuetype_Number = "Number";
    
    -- 外设的值
    local compare_key_rc1 = "rc1";
    local compare_key_rc2 = "rc2";
    local compare_key_rc3 = "rc3";
    local compare_key_rc4 = "rc4";
    
    -- 字段传感器的采集的值
    local compare_key_temperature = "temperature";
    local compare_key_humidity = "humidity";
    local compare_key_airquality = "airquality";

    -- 运算符
    local compare_type_dy   = ">";
    local compare_type_dydy = ">=";
    local compare_type_hdy  = "=";
    local compare_type_xydy = "<=";
    local compare_type_xy   = "<";
    local compare_type_bdy  = "!=";

    local old_rc1 = gpio.get(RC1)
    local old_rc2 = gpio.get(RC2)
    local old_rc3 = gpio.get(RC3)
    local old_rc4 = gpio.get(RC4)
    
    for i,dict in ipairs(cmdcombine) 
    do
            
        local autotype = dict["autotype"];
            
        local demandArr =  dict["demand"];
        local paramsArr =  dict["params"];
            
            -- 数据运算比较
            if autotype == demand_and then --与计算
            
                -- 是否执行的flag
                local combineFlag = 0;
    
    
                for j,dict1 in ipairs(demandArr) 
                do

                    local compare_key = dict1["compare_key"];
                    local compare_type = dict1["compare_type"];
                    local compare_valuetype = dict1["compare_valuetype"];
                    local compare_value = dict1["compare_value"];
                
                    local compare_value_string = "";
                    local compare_value_number = 0;

                    -- log.info("compare_key:",compare_key)
                    -- log.info("compare_type:",compare_type)
                    -- log.info("compare_valuetype:",compare_valuetype)
                    -- log.info("compare_value:",compare_value)
    
    
                    -- 温度 
                    if compare_key == compare_key_temperature then
                        compare_value_number = _G.temperature;
                    elseif compare_key == compare_key_humidity then
                        compare_value_number = _G.humidity;
                    elseif compare_key == compare_key_airquality then
                        compare_value_number = 2;--DOTO

                    elseif compare_key == compare_key_rc1 then
                        if old_rc1 == 1 then
                           compare_value_string ="open"
                        else
                            compare_value_string ="close"
                        end
                    elseif compare_key == compare_key_rc2 then
                        if old_rc2 == 1 then
                           compare_value_string ="open"
                        else
                            compare_value_string ="close"
                        end
                    elseif compare_key == compare_key_rc3 then
                        if old_rc3 == 1 then
                            compare_value_string ="open"
                         else
                             compare_value_string ="close"
                         end
                    elseif compare_key == compare_key_rc4 then
                        if old_rc4 == 1 then
                            compare_value_string ="open"
                         else
                             compare_value_string ="close"
                         end
                    else
                        log.info("compare_key err:%s" , compare_key);
    
                    end
    
    
                    -- 计算数据比较
                    if compare_type == compare_type_dy then
                    
                        if compare_valuetype == compare_valuetype_String  then
                        
                            if compare_value_number > compare_value   then
                            
                                combineFlag = combineFlag + 1;
                            end
    
                        elseif compare_valuetype == compare_valuetype_Number  then
                        
                            if compare_value_string > compare_value then
                            
                                combineFlag = combineFlag + 1;
                            end
                        else
                            log.info("ERROR 3");
                        end
    
    
                    elseif compare_type ==  compare_type_dydy then
                    
                        if compare_valuetype == compare_valuetype_String  then
                        
                            if  compare_value_string >= compare_value then
                            
      
                                combineFlag = combineFlag + 1;
                            else
    
                            end
    
                        elseif compare_valuetype == compare_valuetype_Number  then
                        
                            if compare_value_number >= compare_value then
                            
                                combineFlag = combineFlag + 1;
                            else
    
    
                            end
                        else
                            log.info("ERROR 3");
                        end
    
                    elseif compare_type ==  compare_type_hdy then
                    
                        if compare_valuetype == compare_valuetype_String  then
                        
                            if compare_value_string == compare_value then
                            
                                combineFlag = combineFlag + 1;
                            end
    
                        elseif compare_valuetype == compare_valuetype_Number  then
                        
                            if  compare_value_number == compare_value then
                            
                                combineFlag = combineFlag + 1;
                            end
                        else
                            log.info("ERROR 3");
                        end
    
                    elseif compare_type ==  compare_type_xydy then
                    
                        if compare_valuetype == compare_valuetype_String  then
                        
                            if compare_value_string <= compare_value then
                            
                                combineFlag = combineFlag + 1;
                            end
    
                        elseif compare_valuetype == compare_valuetype_Number  then
                        
                            if compare_value_number <= compare_value then
                            
                                combineFlag = combineFlag + 1;
                            end
                        else
                            log.info("ERROR 3");
                        end
    
                    elseif compare_type ==  compare_type_xy then
                    
                        if compare_valuetype == compare_valuetype_String  then
                        
                            if compare_value_string < compare_value then
                            
                                combineFlag = combineFlag + 1;
                            end
    
                        elseif compare_valuetype == compare_valuetype_Number  then
                        
                            if compare_value_number < compare_value then
                            
                                combineFlag = combineFlag + 1;
                            end
                        else
                            log.info("ERROR 3");
                        end
    
                    elseif compare_type ==  compare_type_bdy then
                    
                        if compare_valuetype == compare_valuetype_String  then
                        
                            if compare_value_string ~= compare_value then
                            
                                combineFlag = combineFlag + 1;
                            end
    
                        elseif compare_valuetype == compare_valuetype_Number then
                        
                            if compare_value_number ~= compare_value then
                            
                                combineFlag = combineFlag + 1;
                            end
                        else
                            log.info("ERROR 3");
                        end
    
                    else
                        log.info("compare_type55 err:%s" , compare_type);
                    end
    
                end
    
                -- 最后是否执行的判断，是根据与全部满足执行
                if combineFlag == #demandArr then
                    -- 触发执行
                    sys.taskInit(function()
                        log.info('GGGGGGGGGGGGGGGGGGparamsArr',paramsArr)

                        sys.publish("SELF_SEND_CBT",   json.encode(paramsArr))

                        -- combinecontrollFunc(paramsArr); 
                       
                    end)                   
                end
    
            elseif autotype == demand_or then--或计算
            
                -- 是否执行的flag
                local combineFlag = false;
    
                for k,dict1 in ipairs(demandArr) 
                do
                    local compare_key = dict1["compare_key"];
                    local compare_type = dict1["compare_type"];
                    local compare_valuetype = dict1["compare_valuetype"];
                    local compare_value = dict1["compare_value"];
                
    
                    local compare_value_string = "";
                    local compare_value_number = 0;
    
    
                    -- 温度 
                    if compare_key == compare_key_temperature then
                    
                        compare_value_number = _G.temperature;;
    
                    elseif compare_key == compare_key_humidity then
                    
                        compare_value_number = _G.humidity;
    
                    elseif compare_key == compare_key_airquality then
                    
                        compare_value_number = 2;
    
                    elseif compare_key == compare_key_rc1 then
                        if old_rc1 == 1 then
                            compare_value_string =  "open"

                        else
                            compare_value_string =  "close"
                        end
                    
    
    
                    elseif compare_key == compare_key_rc2 then
                    
                        if old_rc2 == 1 then
                            compare_value_string =  "open"

                        else
                            compare_value_string =  "close"
                        end    
                    elseif compare_key == compare_key_rc3 then
                    
                        if old_rc3 == 1 then
                            compare_value_string =  "open"

                        else
                            compare_value_string =  "close"
                        end    
                    elseif compare_key == compare_key_rc4 then
                    
                        if old_rc4 == 1 then
                            compare_value_string =  "open"

                        else
                            compare_value_string =  "close"
                        end    
                    else
                    
                        log.info("ERROR 2");
    
    
                    end
    
    
    
                    -- 计算数据比较
                    if compare_type == compare_type_dy then
                    
                        if compare_valuetype == compare_valuetype_String  then
                        
                            if compare_value_string > compare_value  then
                            
                                combineFlag = true;
                            end
    
                        elseif compare_valuetype == compare_valuetype_Number  then
                        
                            if compare_value_number > compare_value then
                            
                                combineFlag = true;
                            end
                        else
                            log.info("ERROR 3");
                        end
    
    
                    elseif compare_type == compare_type_dydy then
                    
                        if compare_valuetype == compare_valuetype_String  then
                        
                            if compare_value_string >= compare_value then
                            
                                combineFlag = true;
                            end
    
                        elseif compare_valuetype == compare_valuetype_Number  then
                        
                            if compare_value_number >= compare_value then
                            
                                combineFlag = true;
                            end
                        else
                            log.info("ERROR 3");
                        end
    
                    
                    elseif compare_type == compare_type_hdy then
                    
                        if compare_valuetype == compare_valuetype_String  then
                        
                            if compare_value_string == compare_value then
                            
                                combineFlag = true;
                            end
    
                        elseif compare_valuetype == compare_valuetype_Number  then
                        
                            if compare_value_number == compare_value then
                            
                                combineFlag = true;
                            end
                        else
                            log.info("ERROR 3");
                        end
    
                    elseif compare_type == compare_type_xydy then
                    
                        if compare_valuetype == compare_valuetype_String  then
                        
                            if compare_value_string <= compare_value then
                            
                                combineFlag = true;
                            end
    
                        elseif compare_valuetype == compare_valuetype_Number  then
                        
                            if  compare_value_number <= compare_value then
                            
                                combineFlag = true;
                            end
                        else
                            log.info("ERROR 3");
                        end
    
                    elseif compare_type == compare_type_xy then
                    
                        if compare_valuetype == compare_valuetype_String  then
                        
                            if compare_value_string < compare_value then
                            
                                combineFlag = true;
                            end
    
                        elseif compare_valuetype == compare_valuetype_Number  then
                        
                            if compare_value_number < compare_value then
                            
                                combineFlag = true;
                            end
                        else
                            log.info("ERROR 3");
                        end
    
                    elseif compare_type == compare_type_bdy then
                    
                        if compare_valuetype == compare_valuetype_String  then
                        
                            if compare_value_string ~= compare_value then
                            
                                combineFlag = true;
                            end
    
                        elseif compare_valuetype == compare_valuetype_Number  then
                        
                            if compare_value_number ~= compare_value then
                            
                                combineFlag = true;
                            end
                        else
                            log.info("ERROR 3");
                        end
    
                    else
    
                        log.info("ERROR 2");
    
                    end
    
    
                    -- 最后是否执行的一个flag
                    if combineFlag then
                    
                        -- 触发执行
                        sys.taskInit(function()
                            LOG.info("GGGGGGGGGGGGGGGparamsArr:",paramsArr)

                            sys.publish("SELF_SEND_CBT", paramsArr)

                            -- combinecontrollFunc(paramsArr); 
                           
                        end)  
                     -- 跳出当前这一个执行，进行下一个判断
                        break;
                    end
                end
    
            else
                log.info("autotype err:%s" , autotype);
                log.info("-");
    
            end
    
    end
    











end




-- 一键执行
local function combinecontrollFunc(cmdcombine)

    local exe_controll= "exe_controll";
    local exe_delay= "exe_delay";

    for i,item in ipairs(cmdcombine) 
    do
        local cmdtype =  item["cmdtype"];

        if cmdtype == exe_controll  then
            local  cmddata = item["cmddata"];
            local sensorname = cmddata["sensorname"];
            local sensorcmd= cmddata["sensorcmd"];

            if sensorname == "rc1"  then
                if sensorcmd == "open"  then
                    CT_RC1(1)
                elseif sensorcmd == "close"  then
                    CT_RC1(0)
                else
                end
              
            elseif sensorname == "rc2"  then
                if sensorcmd == "open"  then
                    CT_RC2(1)
                elseif sensorcmd == "close"  then
                    CT_RC2(0)
                else

                end
              
            elseif sensorname == "rc3"  then
                if sensorcmd == "open"  then
                    CT_RC3(1)
                elseif sensorcmd == "close"  then
                    CT_RC3(0)
                else

                end
              
            elseif sensorname == "rc4"  then
                if sensorcmd == "open"  then
                    CT_RC4(1)
                elseif sensorcmd == "close"  then
                    CT_RC4(0)
                else

                end
              

            end

        elseif cmdtype == exe_delay  then
            local  cmddata = item["cmddata"];
            local timevalue = cmddata["timevalue"];
            sys.wait(timevalue);

         end


        
    end

    

    sys.publish("CLIEND_SEND_DATA")




end


local function getCombineAutoByCidHardware()
      -- body
      local did = "4ee1562359b5bb25d1095c21819d388a"
      local nonce="c0b0a3906c19dde0995abbd061168c0a"
      local tm = rtc.get()
      local reporttime = string.format("%04d-%02d-%02d %02d:%02d:%02d", tm.year, tm.mon, tm.day, tm.hour, tm.min, tm.sec)
      -- log.info("reporttime:",reporttime)
  
      local signt= dataToTimeStamp(reporttime) .. "000"
      local str5 = "api/getCombineAutoByCidHardware_appkey=" .. appkey.."_cid=".. SRCCID.."_did=".. did .."_nonce="..nonce.."_signt="..signt.."_".. secretkey;
      local str6 = string.urlEncode(str5)
      local sign =  string.lower (crypto.md5(str6,#str6))
      local str = string.format('%s?appkey=%s&did=%s&cid=%s&nonce=%s&signt=%s&sign=%s',combinecontrollurl,appkey,did,SRCCID,nonce,signt,sign)
      log.info("str:",str)
  
      local code, headers, body = http.request("GET",str,nil,nil,nil,nil,getCombineAutoByCidHardware).wait()
      log.info("http.get", code, headers, body)
    --   getCombineAutoByCidHardware(body)
    if  body then
        local data = body

        local tjsondata,result,errinfo = json.decode(body)
        if result and type(tjsondata)=="table" then

            --开始数据解析
            local status = tjsondata["status"]
            local errorCode = tjsondata["errorCode"];
            local msg = tjsondata["msg"];

            if status then
                local  datalist = tjsondata["data"]["list"]
                _G.combineAutoArr = datalist;
                _G.demand_count = #datalist;
                _G.autoCombineFlag = true

                log.info('datalist:',datalist )
                log.info('demand_count:',demand_count )

            else
                -- body
                log.info('msg:',msg )
    
            end

        end    

    end
end



if type(rtos.openSoftDog)=="function" then
    rtos.openSoftDog(600000)
end

function urlEncode(s)
    s = string.gsub(s, "([^%w%.%- ])", function(c)
     return string.format("%%%02X", string.byte(c)) end)
    return string.gsub(s, " ", "+")
end 


function trim(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
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

    result = os.time({
        day = tonumber(tempTable[3]),
        month = tonumber(tempTable[2]),
        year = tonumber(tempTable[1]),
        hour = tonumber(tempTable[4]),
        min = tonumber(tempTable[5]),
        sec = tonumber(tempTable[6])
    })
    return result
end


--启动
sys.taskInit(function()

    sys.wait(3000)
	
    local retryConnectCnt = 0
    while true do
       
       -- 等待CID拉取到
        while SRCCID =="" do
            sys.wait(3000)
        end   

        log.info('SRCCID',SRCCID)

        -- 等等自动化任务执行
        while _G.autoCombineFlag == false do

            -- 获取自动化数据
            getCombineAutoByCidHardware();
            sys.wait(3000)

        end                 


        -- 数据监控开始
        while true do
            log.info("combinemonitorFunc:",demand_count)
            
            -- 5S监控一次数据
            sys.taskInit(function()
                combinemonitorFunc();
            end)

            sys.wait(1000)
        end



    end

end)


-- 收到的订阅消息处理
local function SERVER_SEND_AUTOCOMBINE(cmdtype,payload)

    -- 收到消息
    log.info('cmdtype',cmdtype)
    if cmdtype == "cmd_combinemonitor" then

        sys.taskInit(function()
            getCombineAutoByCidHardware();
        end)

    elseif cmdtype == "cmd_combinecontroll" then
        
        sys.taskInit(function()
            local tjsondata,result,errinfo = json.decode(payload)
            if result and type(tjsondata)=="table" then

                --开始数据解析
                local cmdcombine = tjsondata["cmdcombine"]["params"];
                log.info('传递进来的数据OK',#cmdcombine)

                combinecontrollFunc(cmdcombine);
            end
           
        end)
    else
        log.info('传递进来的参数不合法',cmdtype)

    end



end


-- 收到的订阅消息处理 自己发送自己接受的
local function SELF_SEND_CBT(payload)

    -- 收到消息
    log.info('self payload',payload)
    sys.taskInit(function()
        local tjsondata,result,errinfo = json.decode(payload)
        if result and type(tjsondata)=="table" then

            --开始数据解析
            local cmdcombine = tjsondata;
            log.info('传递进来的数据OK',#cmdcombine)

            combinecontrollFunc(cmdcombine);
        end
       
    end)


end


-- 订阅 
sys.subscribe("SELF_SEND_CBT",SELF_SEND_CBT)
sys.subscribe("SERVER_SEND_AUTOCOMBINE",SERVER_SEND_AUTOCOMBINE)



--ntp.timeSync()