# LW004 iOS Software Development Kit Guide

* This SDK only support devices based on LW004.

# Design instructions

* We divide the communications between SDK and devices into two stages: Scanning stage, Connection stage.For ease of understanding, let’s take a look at the related classes and the relationships between them.

`MKLTCentralManager`：global manager, check system’s bluetooth status, listen status changes, the most important is scan and connect to devices;

`MKLTInterface`: When the device is successfully connected, the device data can be read through the interface in`MKLTInterface`;

`MKLTInterface+MKLTConfig`: When the device is successfully connected, you can configure the device data through the interface in`MKLTInterface+MKLTConfig.h`;


## Scanning Stage

in this stage, `MKLTCentralManager ` will scan and analyze the advertisement data of LW004 devices.


## Connection Stage

Developer needs to enter the connection password and call `connectPeripheral:password:sucBlock:failedBlock`to connect.


# Get Started

### Development environment:

* Xcode9+， due to the DFU and Zip Framework based on Swift4.0, so please use Xcode9 or high version to develop;
* iOS12, we limit the minimum iOS system version to 12.0；

### Import to Project

CocoaPods

SDK-LT is available through CocoaPods.To install it, simply add the following line to your Podfile, and then import <MKLoRaTracker/MKLTSDK.h>:

**pod 'MKLoRaTracker/SDK-LT'**


* <font color=#FF0000 face="黑体">!!!on iOS 10 and above, Apple add authority control of bluetooth, you need add the string to “info.plist” file of your project: Privacy - Bluetooth Peripheral Usage Description - “your description”. as the screenshot below.</font>

* <font color=#FF0000 face="黑体">!!! In iOS13 and above, Apple added permission restrictions on Bluetooth APi. You need to add a string to the project’s info.plist file: Privacy-Bluetooth Always Usage Description-“Your usage description”.</font>


## Start Developing

### Get sharedInstance of Manager

First of all, the developer should get the sharedInstance of Manager:

```
MKLTCentralManager *manager = [MKLTCentralManager shared];
```

#### 1.Start scanning task to find devices around you,please follow the steps below:

* 1.Set the scan delegate and complete the related delegate methods:

```
manager.delegate = self;
```

* 2.you can start the scanning task in this way:

```
[manager startScan];
```

* 3.at the sometime, you can stop the scanning task in this way:

```
[manager stopScan];
```

#### 2.Connect to device

The `MKLTCentralManager ` contains the method of connecting the device.

```
/// Connect device function
/// @param trackerModel Model
/// @param password Device connection password,8 characters long ascii code
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
- (void)connectPeripheral:(nonnull CBPeripheral *)peripheral
                 password:(nonnull NSString *)password
                 sucBlock:(void (^)(CBPeripheral *peripheral))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock;
```

#### 3.Get State

Through the manager, you can get the current Bluetooth status of the mobile phone, and the connection status of the device. If you want to monitor the changes of these two states, you can register the following notifications to achieve:

* When the Bluetooth status of the mobile phone changes，<font color=#FF0000 face="黑体">`mk_lt_centralManagerStateChangedNotification`</font> will be posted.You can get status in this way:

`[[MKLTCentralManager shared] centralStatus];`

* When the device connection status changes， <font color=#FF0000 face="黑体"> `mk_lt_peripheralConnectStateChangedNotification` </font> will be posted.You can get the status in this way:

`[MKLTCentralManager shared].connectState;`


#### 4.Monitor three-axis data.

When the device is connected, the developer can monitor the three-axis data of the device through the following steps:

*  1.Open data monitoring by the following method:

```
[[MKLTCentralManager shared] notifyGPSDataData:YES];
```


*  2.Register for <font color=#FF0000 face="黑体"> `mk_lt_receive3AxisSensorDataNotification` </font> notifications to monitor device three-axis data changes


```

[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveAxisSensorData:)
                                                 name:mk_lt_receive3AxisSensorDataNotification
                                               object:nil];
                                               
```


```
#pragma mark - note
- (void)receiveAxisSensorData:(NSNotification *)note {
    NSDictionary *dic = note.userInfo;
    /*
        axisData: {
            "x-axis":"xx",
            "y-axis":"xx",
            "z-axis":"xx",
        }
    */
  }

```


#### 5.Monitoring device disconnect reason.

Register for <font color=#FF0000 face="黑体"> `mk_lt_deviceDisconnectTypeNotification` </font> notifications to monitor data.


```
[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(disconnectTypeNotification:)
                                                 name:@"mk_lt_deviceDisconnectTypeNotification"
                                               object:nil];

```

```
- (void)disconnectTypeNotification:(NSNotification *)note {
    NSString *type = note.userInfo[@"type"];
    /*
    After connecting the device, if no password is entered within one minute, it returns 0x01. After successful password change, it returns 0x02, after restoring the factory settings, it returns 0x03, the device has no data communication for two consecutive minutes, it returns 0x04, and the shutdown protocol is sent to make the device shut down and return 0x05.
    */
}
```


# Change log

* 20210316 first version;
