
typedef NS_ENUM(NSInteger, mk_lt_taskOperationID) {
    mk_lt_defaultTaskOperationID,
    
#pragma mark - Read
    mk_lt_taskReadBatteryPowerOperation,       //电池电量
    mk_lt_taskReadDeviceModelOperation,        //读取产品型号
    mk_lt_taskReadFirmwareOperation,           //读取固件版本
    mk_lt_taskReadHardwareOperation,           //读取硬件类型
    mk_lt_taskReadSoftwareOperation,           //读取软件版本
    mk_lt_taskReadManufacturerOperation,       //读取厂商信息
    mk_lt_taskReadDeviceTypeOperation,         //读取产品类型
    
#pragma mark - 密码特征
    mk_lt_connectPasswordOperation,             //连接设备时候发送密码
    
#pragma mark - 设备系统应用信息读取
    mk_lt_taskReadTimeSyncIntervalOperation,        //读取时间同步间隔
    mk_lt_taskReadBeaconUUIDOperation,              //读取iBeacon的UUID
    mk_lt_taskReadBeaconMajorOperation,             //读取iBeacon的Major
    mk_lt_taskReadBeaconMinorOperation,             //读取iBeacon的Minor
    mk_lt_taskReadMeasuredPowerOperation,           //读取Measured Power (RSSI@1m)
    mk_lt_taskReadTxPowerOperation,                 //读取Tx Power
    mk_lt_taskReadBroadcastIntervalOperation,       //读取广播间隔
    mk_lt_taskReadDeviceNameOperation,              //读取蓝牙广播名称
    mk_lt_taskReadScanParamsOperation,              //读取蓝牙扫描参数
    mk_lt_taskReadConnectableStatusOperation,       //读取设备可连接状态
    
#pragma mark - 设备LoRa参数读取
    mk_lt_taskReadLorawanModemOperation,        //读取LoRaWAN入网类型
    mk_lt_taskReadLorawanRegionOperation,       //读取LoRaWAN频段
    mk_lt_taskReadLorawanDEVEUIOperation,           //读取LoRaWAN DEVEUI
    mk_lt_taskReadLorawanAPPEUIOperation,           //读取LoRaWAN APPEUI
    mk_lt_taskReadLorawanAPPKEYOperation,           //读取LoRaWAN APPKEY
    mk_lt_taskReadLorawanDEVADDROperation,          //读取LoRaWAN DEVADDR
    mk_lt_taskReadLorawanAPPSKEYOperation,          //读取LoRaWAN APPSKEY
    mk_lt_taskReadLorawanNWKSKEYOperation,          //读取LoRaWAN NWKSKEY
    mk_lt_taskReadLorawanCHOperation,               //读取LoRaWAN CH
    mk_lt_taskReadLorawanDROperation,               //读取LoRaWAN DR
    mk_lt_taskReadLorawanADROperation,              //读取LoRaWAN ADR
    mk_lt_taskReadLorawanMessageTypeOperation,      //读取上行数据类型
    mk_lt_taskReadLorawanNetworkStatusOperation,    //读取LoRaWAN网络状态
    mk_lt_taskReadNetworkCheckIntervalOperation,    //读取网络检测间隔
    mk_lt_taskReadAlarmTriggerRSSIOperation,        //读取报警RSSI值
    mk_lt_taskReadAlarmNotificationTypeOperation,   //读取报警提醒类型
    mk_lt_taskReadVibrationIntensityOperation,      //读取马达震动强度
    mk_lt_taskReadDurationOfVibrationOperation,     //读取马达震动时长
    mk_lt_taskReadVibrationCycleOfMotorOperation,   //读取马达震动周期
    mk_lt_taskReadMacAddressOperation,              //读取设备MAC地址
    mk_lt_taskReadLowPowerPromptOperation,          //读取低电报警电量百分比
    mk_lt_taskReadScanDatasReportIntervalOperation, //读取扫描数据定时上报时间
    mk_lt_taskReadValidBLEDataFilterIntervalOperation,  //读取扫描有效数据筛选间隔
    mk_lt_taskReadDeviceInfoReportIntervalOperation,    //读取设备信息同步间隔
    mk_lt_taskReadGatheringWarningRssiOperation,        //读取人员聚集报警RSSI
    mk_lt_taskReadAlarmOptionalPayloadContentOperation, //读取警报和定时上报数据包内容可选项
    mk_lt_taskReadReportNumberOfBeaconsOperation,       //读取上报的iBeacon设备数量
    mk_lt_taskReadAxisSensorSampleRateOperation,        //读取三轴采样率
    mk_lt_taskReadAxisSensorGravitationalaccelerationOperation, //读取三轴重力加速度参考值
    mk_lt_taskReadAxisSensorTriggerSensitivityOperation,        //读取三轴触发灵敏度
    mk_lt_taskReadAxisSensorSwitchStatusOperation,              //读取三轴状态开关
    mk_lt_taskReadAxisSensorDataReportIntervalOperation,        //读取三轴数据上报间隔
    mk_lt_taskReadAxisSensorDataStatusOperation,                //app是否打开了三轴数据监听
    mk_lt_taskReadAxisSensorReportDataContentTypeOperation,     //读取三轴上报数据包内容可选项
    mk_lt_taskReadSOSSwitchStatusOperation,             //读取SOS报警使能状态
    mk_lt_taskReadSOSDataReportIntervalOperation,       //读取SOS报警信息上报间隔
    mk_lt_taskReadSOSReportDataContentTypeOperation,    //读取SOS上报数据包内容可选项
    mk_lt_taskReadGPSHardwareStatusOperation,           //读取设备是否包含GPS功能
    mk_lt_taskReadGPSSwitchStatusOperation,             //读取设备GPS开关状态
    mk_lt_taskReadGPSSatellitesSearchTimeOperation,     //读取GPS单次搜星时间
    mk_lt_taskReadGPSDataReportIntervalOperation,       //读取GPS上报间隔
    mk_lt_taskReadGPSReportDataContentTypeOperation,    //读取GPS上报数据包内容可选项
    
    mk_lt_taskReadUpLinkeDellTimeOperation,         //读取up link dell time
    mk_lt_taskReadDutyCycleStatusOperation,         //读取duty cycle
    mk_lt_taskReadBeaconReportSwitchStatusOperation,    //读取iBeacon数据上报开关状态
    
#pragma mark - 蓝牙过滤规则读取
    mk_lt_taskReadTrackingAFilterRssiOperation,                 //读取Tracking过滤规则A - RSSI
    mk_lt_taskReadTrackingAFilterDeviceNameOperation,           //读取Tracking过滤规则A - 设备名称
    mk_lt_taskReadTrackingAFilterMacOperation,                  //读取Tracking过滤规则A - mac地址
    mk_lt_taskReadTrackingAFilterMajorOperation,                //读取Tracking过滤规则A - Major范围
    mk_lt_taskReadTrackingAFilterMinorOperation,                //读取Tracking过滤规则A - Minor范围
    mk_lt_taskReadTrackingAFilterUUIDOperation,                 //读取Tracking过滤规则A - UUID
    mk_lt_taskReadTrackingAFilterRawDataOperation,              //读取Tracking过滤规则A - RAW数据
    mk_lt_taskReadTrackingAFilterStatusOperation,               //读取Tracking过滤规则A - 过滤开关状态
    
    mk_lt_taskReadTrackingBFilterRssiOperation,                 //读取Tracking过滤规则B - RSSI
    mk_lt_taskReadTrackingBFilterDeviceNameOperation,           //读取Tracking过滤规则B - 设备名称
    mk_lt_taskReadTrackingBFilterMacOperation,                  //读取Tracking过滤规则B - mac地址
    mk_lt_taskReadTrackingBFilterMajorOperation,                //读取Tracking过滤规则B - Major范围
    mk_lt_taskReadTrackingBFilterMinorOperation,                //读取Tracking过滤规则B - Minor范围
    mk_lt_taskReadTrackingBFilterUUIDOperation,                 //读取Tracking过滤规则B - UUID
    mk_lt_taskReadTrackingBFilterRawDataOperation,              //读取Tracking过滤规则B - RAW数据
    mk_lt_taskReadTrackingBFilterStatusOperation,               //读取Tracking过滤规则B - 过滤开关状态
    
    
    mk_lt_taskReadTrackingLogicalRelationshipOperation,         //读取Tracking过滤规则A、B之间的逻辑关系
    mk_lt_taskReadTrackingFilterRepeatingDataTypeOperation,     //读取Tracking重复数据判定规则
    
    mk_lt_taskReadLocationAFilterRssiOperation,                 //读取Location过滤规则A - RSSI
    mk_lt_taskReadLocationAFilterDeviceNameOperation,           //读取Location过滤规则A - 设备名称
    mk_lt_taskReadLocationAFilterMacOperation,                  //读取Location过滤规则A - mac地址
    mk_lt_taskReadLocationAFilterMajorOperation,                //读取Location过滤规则A - Major范围
    mk_lt_taskReadLocationAFilterMinorOperation,                //读取Location过滤规则A - Major范围
    mk_lt_taskReadLocationAFilterUUIDOperation,                 //读取Location过滤规则A - UUID
    mk_lt_taskReadLocationAFilterRawDataOperation,              //读取Location过滤规则A - RAW数据
    mk_lt_taskReadLocationAFilterStatusOperation,               //读取Location过滤规则A - 过滤开关状态
    
    mk_lt_taskReadLocationBFilterRssiOperation,                 //读取Location过滤规则B - RSSI
    mk_lt_taskReadLocationBFilterDeviceNameOperation,           //读取Location过滤规则B - 设备名称
    mk_lt_taskReadLocationBFilterMacOperation,                  //读取Location过滤规则B - mac地址
    mk_lt_taskReadLocationBFilterMajorOperation,                //读取Location过滤规则B - Major范围
    mk_lt_taskReadLocationBFilterMinorOperation,                //读取Location过滤规则B - Major范围
    mk_lt_taskReadLocationBFilterUUIDOperation,                 //读取Location过滤规则B - UUID
    mk_lt_taskReadLocationBFilterRawDataOperation,              //读取Location过滤规则B - RAW数据
    mk_lt_taskReadLocationBFilterStatusOperation,               //读取Location过滤规则B - 过滤开关状态
    
    
    mk_lt_taskReadLocationLogicalRelationshipOperation,         //读取Location过滤规则A、B之间的逻辑关系
    mk_lt_taskReadLocationFilterRepeatingDataTypeOperation,     //读取Location重复数据判定规则
    
    
    
#pragma mark - 设备系统应用信息配置
    mk_lt_taskConfigTimeSyncIntervalOperation,          //配置设备时间同步间隔
    mk_lt_taskConfigBeaconProximityUUIDOperation,       //配置iBeacon的UUID
    mk_lt_taskConfigBeaconMajorOperation,               //配置iBeacon的Major
    mk_lt_taskConfigBeaconMinorOperation,               //配置iBeacon的Minor
    mk_lt_taskConfigMeasuredPowerOperation,             //配置设备的RSSI@1M
    mk_lt_taskConfigTxPowerOperation,                   //配置设备的Tx Power
    mk_lt_taskConfigBroadcastIntervalOperation,         //配置设备的广播间隔
    mk_lt_taskConfigDeviceNameOperation,                //配置设备广播名称
    mk_lt_taskConfigPasswordOperation,                  //设置密码
    mk_lt_taskConfigDeviceTimeOperation,                //同步设备时间
    mk_lt_taskConfigScanWindowOperation,                //配置设备扫描开关与扫描窗口
    mk_lt_taskConfigConnectableStatusOperation,         //配置蓝牙可连接状态
    
    
#pragma mark - 设备LoRa参数配置
    mk_lt_taskConfigModemOperation,                     //配置LoRaWAN的入网类型
    mk_lt_taskConfigRegionOperation,                    //配置LoRaWAN的region
    mk_lt_taskConfigDEVEUIOperation,                    //配置LoRaWAN的devEUI
    mk_lt_taskConfigAPPEUIOperation,                    //配置LoRaWAN的appEUI
    mk_lt_taskConfigAPPKEYOperation,                    //配置LoRaWAN的appKey
    mk_lt_taskConfigDEVADDROperation,                   //配置LoRaWAN的DevAddr
    mk_lt_taskConfigAPPSKEYOperation,                   //配置LoRaWAN的APPSKEY
    mk_lt_taskConfigNWKSKEYOperation,                   //配置LoRaWAN的NwkSKey
    mk_lt_taskConfigCHValueOperation,                   //配置LoRaWAN的CH值
    mk_lt_taskConfigDRValueOperation,                   //配置LoRaWAN的DR值
    mk_lt_taskConfigADRStatusOperation,                 //配置LoRaWAN的ADR状态
    mk_lt_taskConfigMessageTypeOperation,               //配置LoRaWAN的message type
    mk_lt_taskConfigNetworkCheckIntervalOperation,      //配置网络检测间隔
    mk_lt_taskConfigAlarmTriggerRSSIOperation,          //配置报警RSSI值
    mk_lt_taskConfigAlarmNotificationTypeOperation,     //配置报警类型
    mk_lt_taskConfigVibrationIntensityOperation,        //配置马达震动强度
    mk_lt_taskConfigDurationOfVibrationOperation,       //配置马达震动时长
    mk_lt_taskConfigVibrationCycleOfMotorOperation,     //配置马达震动周期
    mk_lt_taskConfigLowPowerPromptOperation,            //配置低电量报警电量百分比
    mk_lt_taskConfigScanDatasReportIntervalOperation,   //配置扫描数据定时上报间隔
    mk_lt_taskConfigValidBLEDataFilterIntervalOperation,    //配置扫描有效数据筛选间隔
    mk_lt_taskConfigDeviceInfoReportIntervalOperation,  //配置设备信息同步间隔
    mk_lt_taskConfigGatheringWarningRssiOperation,      //配置人员聚集报警RSSI
    mk_lt_taskConfigConnectNetworkOperation,            //入网请求
    mk_lt_taskConfigDevicePowerOffOperation,            //设备关机
    mk_lt_taskConfigDeviceFactoryResetOperation,        //恢复出厂设置
    mk_lt_taskConfigAlarmOptionalPayloadContentOperation,   //配置警报和定时上报数据包内容可选项
    mk_lt_taskConfigReportNumberOfBeaconsOperation,     //配置上报iBeacon设备数量
    mk_lt_taskConfigAxisSensorSampleRateOperation,      //配置三轴采样率
    mk_lt_taskConfigAxisSensorGravitationalaccelerationOperation,       //配置三轴重力加速度参考值
    mk_lt_taskConfigAxisSensorTriggerSensitivityOperation,              //配置三轴触发灵敏度
    mk_lt_taskConfigAxisSensorSwitchStatusOperation,                    //配置三轴功能开关
    mk_lt_taskConfigAxisSensorDataReportIntervalOperation,              //配置三轴数据上报间隔
    mk_lt_taskConfigAxisSensorDataStatusOperation,                      //配置三轴监听开关
    mk_lt_taskConfigAxisSensorReportDataContentTypeOperation,           //配置三轴上报数据包内容可选项
    mk_lt_taskConfigSOSSwitchStatusOperation,           //配置SOS报警开关状态
    mk_lt_taskConfigSOSDataReportIntervalOperation,     //配置SOS报警信息上报间隔
    mk_lt_taskConfigSOSReportDataContentTypeOperation,  //配置SOS上报数据包内容可选项
    mk_lt_taskConfigGPSSwitchStatusOperation,           //配置GPS开关状态
    mk_lt_taskConfigGPSSatellitesSearchTimeOperation,   //配置GPS单次搜星时间
    mk_lt_taskConfigGPSDataReportIntervalOperation,     //配置GPS上报间隔
    mk_lt_taskConfigGPSReportDataContentTypeOperation,  //配置GPS上报数据包内容可选项
    
#pragma mark -
    mk_lt_taskConfigUpLinkeDellTimeOperation,           //配置LoRaWAN的UpLinkeDellTime
    mk_lt_taskConfigDutyCycleStatusOperation,           //配置LoRaWAN的duty cycle
    mk_lt_taskConfigBeaconReportSwitchStatusOperation,  //配置iBeacon数据上报开关状态
    
    
#pragma mark - 蓝牙过滤规则配置
    mk_lt_taskConfigTrackingAFilterRssiOperation,                 //配置Tracking过滤规则A - RSSI
    mk_lt_taskConfigTrackingAFilterDeviceNameOperation,           //配置Tracking过滤规则A - 设备名称
    mk_lt_taskConfigTrackingAFilterMacOperation,                  //配置Tracking过滤规则A - mac地址
    mk_lt_taskConfigTrackingAFilterMajorOperation,                //配置Tracking过滤规则A - Major范围
    mk_lt_taskConfigTrackingAFilterMinorOperation,                //配置Tracking过滤规则A - Minor范围
    mk_lt_taskConfigTrackingAFilterUUIDOperation,                 //配置Tracking过滤规则A - UUID
    mk_lt_taskConfigTrackingAFilterRawDataOperation,              //配置Tracking过滤规则A - RAW数据
    mk_lt_taskConfigTrackingAFilterStatusOperation,               //配置Tracking过滤规则A - 过滤开关状态
    
    mk_lt_taskConfigTrackingBFilterRssiOperation,                 //配置Tracking过滤规则B - RSSI
    mk_lt_taskConfigTrackingBFilterDeviceNameOperation,           //配置Tracking过滤规则B - 设备名称
    mk_lt_taskConfigTrackingBFilterMacOperation,                  //配置Tracking过滤规则B - mac地址
    mk_lt_taskConfigTrackingBFilterMajorOperation,                //配置Tracking过滤规则B - Major范围
    mk_lt_taskConfigTrackingBFilterMinorOperation,                //配置Tracking过滤规则B - Minor范围
    mk_lt_taskConfigTrackingBFilterUUIDOperation,                 //配置Tracking过滤规则B - UUID
    mk_lt_taskConfigTrackingBFilterRawDataOperation,              //配置Tracking过滤规则B - RAW数据
    mk_lt_taskConfigTrackingBFilterStatusOperation,               //配置Tracking过滤规则B - 过滤开关状态
    
    
    mk_lt_taskConfigTrackingLogicalRelationshipOperation,         //配置Tracking过滤规则A、B之间的逻辑关系
    mk_lt_taskConfigTrackingFilterRepeatingDataTypeOperation,     //配置Tracking重复数据判定规则
    
    mk_lt_taskConfigLocationAFilterRssiOperation,                 //配置Location过滤规则A - RSSI
    mk_lt_taskConfigLocationAFilterDeviceNameOperation,           //配置Location过滤规则A - 设备名称
    mk_lt_taskConfigLocationAFilterMacOperation,                  //配置Location过滤规则A - mac地址
    mk_lt_taskConfigLocationAFilterMajorOperation,                //配置Location过滤规则A - Major范围
    mk_lt_taskConfigLocationAFilterMinorOperation,                //配置Location过滤规则A - Major范围
    mk_lt_taskConfigLocationAFilterUUIDOperation,                 //配置Location过滤规则A - UUID
    mk_lt_taskConfigLocationAFilterRawDataOperation,              //配置Location过滤规则A - RAW数据
    mk_lt_taskConfigLocationAFilterStatusOperation,               //配置Location过滤规则A - 过滤开关状态
    
    mk_lt_taskConfigLocationBFilterRssiOperation,                 //配置Location过滤规则B - RSSI
    mk_lt_taskConfigLocationBFilterDeviceNameOperation,           //配置Location过滤规则B - 设备名称
    mk_lt_taskConfigLocationBFilterMacOperation,                  //配置Location过滤规则B - mac地址
    mk_lt_taskConfigLocationBFilterMajorOperation,                //配置Location过滤规则B - Major范围
    mk_lt_taskConfigLocationBFilterMinorOperation,                //配置Location过滤规则B - Major范围
    mk_lt_taskConfigLocationBFilterUUIDOperation,                 //配置Location过滤规则B - UUID
    mk_lt_taskConfigLocationBFilterRawDataOperation,              //配置Location过滤规则B - RAW数据
    mk_lt_taskConfigLocationBFilterStatusOperation,               //配置Location过滤规则B - 过滤开关状态
    
    
    mk_lt_taskConfigLocationLogicalRelationshipOperation,         //配置Location过滤规则A、B之间的逻辑关系
    mk_lt_taskConfigLocationFilterRepeatingDataTypeOperation,     //配置Location重复数据判定规则
};
