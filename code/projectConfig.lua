-------------------------------------- 项目全局配置文件--------------------------------------

-- 以下三选一，然后开始配置    【阿里云、自建服务器 代码需要定制化开发】
-- ①精灵物联网 		fairycloud
-- ②阿里云 		aliyuncs
-- ③自建服务器 	privatecloud

_G.server_select = "fairycloud"
-- _G.server_select = "aliyuncs"
--_G.server_select = "privatecloud"


-- ①精灵物联网(fairycloud)： 3个参数--必配--⭐️⭐️⭐️联系平台管理员获取⭐️⭐️⭐️
_G.server_api = ""
_G.appkey = ""
_G.secretkey = ""


-- ②阿里云(aliyuncs)： 7个参数--必配--自行在阿里云官网处理
_G.aliyuncs_clientId =  "k1q9smpdXQq.AIR780EGRL|securemode=2,signmethod=hmacsha256,timestamp=1725892899910|"
_G.aliyuncs_username =  "AIR780EGRL&k1q9smpdXQq"
_G.aliyuncs_mqttHostUrl =  "iot-06z00hq1bf8kxwr.mqtt.iothub.aliyuncs.com"
_G.aliyuncs_passwd = "954d9e6f642580b1584925fedfb7c469e0a7cf5a46506b51fcdddb0c4f1892e0"
_G.aliyuncs_port =  1883
_G.aliyuncs_pub_topic =  "/k1q9smpdXQq/AIR780EGRL/user/update"
_G.aliyuncs_sub_topic =  "/k1q9smpdXQq/AIR780EGRL/user/get"


-- ③自建服务器(privatecloud)： 1个参数--必配--POST请求的服务器地址，body传json数据
--_G.post_url = "https://petbus.cqchongbao.com/api/location/index"


------------------------------以上必配，到此结束--------------------------------------

-- 4个继电器引脚定义
_G.RC1 = 8
_G.RC2 = 9
_G.RC3 = 10
_G.RC4 = 11

_G.CT_RC1= ""
_G.CT_RC2= ""
_G.CT_RC3= ""
_G.CT_RC4= ""


-- 程序版本号--选配
_G.version = "1.0.0"


------------------------------所有配置，到此结束--------------------------------------

-- 自动化任务
 _G.combinecontrollurl = ""
 _G.combineAutoArr = ""
 _G.demand_count = 0
 _G.autoCombineFlag = false


-- 设备运行模式 ，默认正常： 正常awake  潜休眠rest 深度休眠deeprest
_G.deviceModle = "awake";

-- 日志开启状态，默认关闭
_G.logFlag = false;

-- 数据上报周期--默认的10S上报:10*1000ms
_G.update_time = 10*1000

-- 以下设置程序自动获取
_G.SRCCID = ""							
_G.mqtt_mqttClientId=""					
_G.mqtt_username=""						
_G.mqtt_passwd=""						
_G.mqtt_mqttHostUrl ="" 				
_G.mqtt_port = 0 


-- MQTT的TOPIC
_G.mqtt_sub_topic = ""
_G.mqtt_pub_topic = ""


-- 消息传输模板
_G.REPORT_DATA_TEMPLATE = "{\"cmdtype\":\"cmd_status\",\"reporttime\":\"\",\"version\":\"-\", \"electricity\":\"--\"}"
_G.REPORT_CONTROLLACK_TEMPLATE = "{\"status\":\"success\",\"cmdtype\":\"cmd_controllack\",\"did\":\"\",\"reporttime\":\"\"}"

-- 硬件IMEI
_G.aliyuncs_imei = ""


-- 默认的温湿度
_G.temperature=0
_G.humidity=0
-- 电量
_G.electricity = "--";
_G.vbat = "--";
_G.vbat_max = 4100;
_G.vbat_min = 3100;

_G.mqttc = nil   
_G.uartid = 1

