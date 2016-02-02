//
//  ViewController.m
//  ZYXBluetooth
//
//  Created by 7road on 15/11/30.
//  Copyright © 2015年 zhuo. All rights reserved.
//

#import "ViewController.h"

@import CoreBluetooth;

@interface ViewController () <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) NSMutableArray *perpherals;
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (nonatomic, weak) IBOutlet UILabel *temperatureLabel;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.temperatureLabel.text = @"";
    self.perpherals = [NSMutableArray array];
    
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
    
    //检测ios设备是否支持和开启蓝牙
    if (self.centralManager.state == CBCentralManagerStatePoweredOff)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Bluetooth Turned Off", @"") message:NSLocalizedString(@"Turn on bluetooth and try again", @"") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Dismiss", @"") style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if (self.centralManager.state == CBCentralManagerStateUnsupported)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Bluetooth LE not availabel on this device", @"") message:NSLocalizedString(@"This is not a iPhone 4S+ device", @"") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Dismiss", @"") style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if (self.centralManager.state == CBCentralManagerStatePoweredOn)
    {
        [self.centralManager scanForPeripheralsWithServices:nil options:nil];
    }
    
}

//如果设备没开启蓝牙，会在CBCentralManagerDelegate的该回调中通知，该方法也要扫描外围设备
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state == CBCentralManagerStatePoweredOn)
    {
        [self.centralManager scanForPeripheralsWithServices:nil options:nil];
    }
    else if (self.centralManager.state == CBCentralManagerStatePoweredOff)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Bluetooth Turned Off", @"") message:NSLocalizedString(@"Turn on bluetooth and try again", @"") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Dismiss", @"") style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

/**
 *  发现外围设备,CBCentralManagerDelegate的回调通知
 *
 *  @param central           中心设备（客户端）
 *  @param peripheral        外围设备（服务器端）
 *  @param advertisementData 字典变量，包括所有公告和返回信息
 *  @param RSSI              信号强度
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    //停止扫描是可选的方法
    //[self.centralManager stopScan];
    if (![self.perpherals containsObject:peripheral])
    {
        self.statusLabel.text = NSLocalizedString(@"Connecting to Peripheral", @"");
        peripheral.delegate = self;
        [self.perpherals addObject:peripheral];
        [self.centralManager connectPeripheral:peripheral options:nil];
    }
}

/**
 *  发现外围设备提供的服务
 *
 *  @param central    中心设备
 *  @param peripheral 连接的外围设备
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    self.statusLabel.text = NSLocalizedString(@"Discovering services...", @"");
    [peripheral discoverServices:nil];
}
/**
 *  发现外围设备的服务
 *
 *  @param peripheral 外围设备
 *  @param error      <#error description#>
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSLog(@"name = %@", peripheral.name);
    for (CBService *service in peripheral.services)
    {
        NSLog(@"service = %@, UUID = %@", service, service.UUID);
    }
    [peripheral.services enumerateObjectsUsingBlock:^(CBService * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CBService *service = obj;
        if ([service.UUID isEqual:[CBUUID UUIDWithString:@"0x180A"]])
        {
            [peripheral discoverCharacteristics:nil forService:service];
            
        }
    }];
    
//    self.statusLabel.text = NSLocalizedString(@"Discover characteristics...", @"");
//    
//    __block BOOL found = NO;
//    [peripheral.services enumerateObjectsUsingBlock:^(CBService * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        CBService *service = obj;
//        //发现了德州仪器SensorTag提供的外界温度服务
//        if ([service.UUID isEqual:[CBUUID UUIDWithString:@"F000AA00-0451-4000-B000-000000000000"]])
//        {
//            [peripheral discoverCharacteristics:nil forService:service];
//            found = YES;
//        }
//    }];
//    
//    if (!found)
//    {
//        self.statusLabel.text = NSLocalizedString(@"This is not a Sensor Tag", @"");
//    }
}

/**
 *  发现服务中的特性，如开启关闭服务，读取服务当前值
 *
 *  @param peripheral 外围设备
 *  @param service    服务
 *  @param error      错误描述
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    self.statusLabel.text = NSLocalizedString(@"Reading tmperature...", @"");
    for (CBCharacteristic *ch in service.characteristics)
    {
        NSLog(@"service Characteristics = %@", ch);
    }
    
    
    [service.characteristics enumerateObjectsUsingBlock:^(CBCharacteristic * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CBCharacteristic *ch = obj;
        //该uuid是开启关闭服务，设置data为0x01表示打开服务
        if ([ch.UUID isEqual:[CBUUID UUIDWithString:@"F000AA02-0451-4000-B000-000000000000"]])
        {
            uint8_t data = 0x01;
            [peripheral writeValue:[NSData dataWithBytes:&data length:1] forCharacteristic:ch type:CBCharacteristicWriteWithResponse];
        }
        //该uuid是读取温度值的服务，这里设置了温度值的变化监听
        if ([ch.UUID isEqual:[CBUUID UUIDWithString:@"F000AA01-0451-4000-B000-000000000000"]])
        {
            [peripheral setNotifyValue:YES forCharacteristic:ch];
        }
        
    }];
}


- (float)temperatureFromeData:(NSData *)data
{
    char scratchVal[data.length];
    int16_t ambTemp;
    [data getBytes:&scratchVal length:data.length];
    ambTemp = ((scratchVal[2] & 0xff)| ((scratchVal[3] << 8) & 0xff00));
    
    return (float)((float)ambTemp / (float)128);
}

//当温度值变化时，会回调此方法
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    float temp = [self temperatureFromeData:characteristic.value];
    self.statusLabel.text = NSLocalizedString(@"Room temperature", @"");
    self.temperatureLabel.text = [NSString stringWithFormat:@"%.1f°C", temp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
