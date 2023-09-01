//
//  DevicePermissionsTool.swift
//  WidgetApp
//
//  Created by HS-jianxin on 2023/8/4.
//

import Foundation
import UIKit
import CoreBluetooth
import EventKit
import CoreLocation
import AVFoundation
import Photos
import HealthKit


enum TenAuthorizationStatus: NSInteger {
    case TenAuthorizationStatusNotDetermined = 0    //未确定
    case TenAuthorizationStatusRestricted           //限制
    case TenAuthorizationStatusDenied               //拒绝
    case TenAuthorizationStatusAuthorized           //同意授权
}

// MARK: - ❤️相机
class CameraAuthManger: NSObject {
    /// 拍视频权限获取
    static func cameraStatus() -> TenAuthorizationStatus {
        var status: TenAuthorizationStatus
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            status = .TenAuthorizationStatusAuthorized
        case .notDetermined:
            status = .TenAuthorizationStatusNotDetermined
        case .denied:
            status = .TenAuthorizationStatusDenied
        case .restricted:
            status = .TenAuthorizationStatusRestricted
        default:
            status = .TenAuthorizationStatusDenied
        }
        return status
    }
    
    /// 权限请求
    func requestAuthorization(_ handler : @escaping ((Bool)->())) {
        AVCaptureDevice.requestAccess(for: .video) { isSuccess in
            handler(isSuccess)
        }
    }
}











// MARK: - ❤️相册
class PhotoAuthManager: NSObject {
    /// 获取相册读写权限
    static func photoLibraryStatus() -> TenAuthorizationStatus {
        var status: TenAuthorizationStatus
        switch PHPhotoLibrary.authorizationStatus(for: .readWrite) {
        case .authorized:
            status = .TenAuthorizationStatusAuthorized //全部
        case .limited:
            status = .TenAuthorizationStatusAuthorized //部分
        case .notDetermined:
            status = .TenAuthorizationStatusNotDetermined //
        case .restricted:
            status = .TenAuthorizationStatusRestricted
        default:
            status = .TenAuthorizationStatusDenied
        }
        return status
    }
    
    /// 权限请求
    static func requestAuthorization(_ handler : @escaping ((TenAuthorizationStatus)->())) {
        
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { pHAuthorizationStatus in
            switch pHAuthorizationStatus {
            case .notDetermined:
                handler(.TenAuthorizationStatusNotDetermined)
            case .restricted:
                handler(.TenAuthorizationStatusRestricted)
            case .denied:
                handler(.TenAuthorizationStatusDenied)
            case .authorized:
                handler(.TenAuthorizationStatusAuthorized)
            case .limited:
                handler(.TenAuthorizationStatusAuthorized)
            @unknown default:
                handler(.TenAuthorizationStatusNotDetermined)
            }
        }
    }
}











// MARK: - ❤️日历
class CalendarAuthManager: NSObject {
    /// 获取事件权限状态
    static func calendarStatus() -> TenAuthorizationStatus {
        var status: TenAuthorizationStatus
        switch EKEventStore.authorizationStatus(for: .event) {
            case .authorized:
                status = .TenAuthorizationStatusAuthorized
            case .notDetermined:
                status = .TenAuthorizationStatusNotDetermined
            case .restricted:
                status = .TenAuthorizationStatusRestricted
            default:
                status = .TenAuthorizationStatusDenied
        }
        return status
    }
    
    
    /// 权限请求 event
    static func requestAuthorization(_ handler : @escaping ((TenAuthorizationStatus)->())) {
        
        EKEventStore().requestAccess(to: .event) { isSuccess, error in
            if error != nil || isSuccess == false {
                handler(.TenAuthorizationStatusDenied)
            }else {
                handler(.TenAuthorizationStatusAuthorized)
            }
        }
    }
}













// MARK: - ❤️提醒事项
class ReminderAuthManager: NSObject {
    /// 获取事件权限状态
    static func reminderStatus() -> TenAuthorizationStatus {
        var status: TenAuthorizationStatus
        switch EKEventStore.authorizationStatus(for: .reminder) {
            case .authorized:
                status = .TenAuthorizationStatusAuthorized
            case .notDetermined:
                status = .TenAuthorizationStatusNotDetermined
            case .restricted:
                status = .TenAuthorizationStatusRestricted
            default:
                status = .TenAuthorizationStatusDenied
        }
        return status
    }
    
    
    /// 权限请求 Reminder
    static func requestAuthorization(_ handler : @escaping ((TenAuthorizationStatus)->())) {
        
        EKEventStore().requestAccess(to: .reminder) { isSuccess, error in
            if error != nil || isSuccess == false {
                handler(.TenAuthorizationStatusDenied)
            }else {
                handler(.TenAuthorizationStatusAuthorized)
            }
        }
    }
}


extension ReminderAuthManager {
    // MARK: 2.1、查询出所有提醒事件
   static func selectReminder(remindersClosure: @escaping (([EKReminder]?) -> Void)) {
       // 在取得提醒之前，需要先获取授权
       let eventStore = EKEventStore()
       eventStore.requestAccess(to: .reminder) {
           (granted: Bool, error: Error?) in
           if (granted) && (error == nil) {
               // 获取授权后，我们可以得到所有的提醒事项
               let predicate = eventStore.predicateForReminders(in: nil)
               eventStore.fetchReminders(matching: predicate, completion: {
                   (reminders: [EKReminder]?) -> Void in
                   DispatchQueue.main.async {
                       remindersClosure(reminders)
                   }
               })
           } else {
               DispatchQueue.main.async {
                   remindersClosure([EKReminder]())
               }
           }
       }
   }
    
    static func allReminders() -> [EKReminder] {
        var allReminders = [EKReminder]()
        // 在取得提醒之前，需要先获取授权
        let eventStore = EKEventStore()
        
        let signal = DispatchSemaphore(value: 0);//当前signal车库中剩余0个位置
        
        eventStore.requestAccess(to: .reminder) {
            (granted: Bool, error: Error?) in
            if (granted) && (error == nil) {
                // 获取授权后，我们可以得到所有的提醒事项
                let predicate = eventStore.predicateForReminders(in: nil)
                eventStore.fetchReminders(matching: predicate, completion: {
                    (reminders: [EKReminder]?) -> Void in
                    allReminders = reminders ?? [EKReminder]()
                    signal.signal()
                })
            } else {
                signal.signal()
            }
        }
        signal.wait(timeout: .distantFuture)//一直等到signal库中有空位了，才会往下继续执行
        return allReminders
    }
}













// MARK: - ❤️定位
class LocationAuthManager: NSObject, CLLocationManagerDelegate {
    
    var handle: ((TenAuthorizationStatus, CLLocation)->())?
    
    /// 地理位置 状态获取
    static func locationStatus() -> TenAuthorizationStatus {
        if CLLocationManager.locationServicesEnabled() == false {
            return .TenAuthorizationStatusRestricted
        }
        
        var status: TenAuthorizationStatus
        switch CLLocationManager().authorizationStatus {
            case .authorized:
                status = .TenAuthorizationStatusAuthorized
            case .notDetermined:
                status = .TenAuthorizationStatusNotDetermined
            case .restricted:
                status = .TenAuthorizationStatusRestricted
            default:
                status = .TenAuthorizationStatusDenied
        }
        return status
    }
    
    /// 权限请求 event
    func requestAuthorization(_ handler : @escaping ((TenAuthorizationStatus, CLLocation)->())) {
        if CLLocationManager.locationServicesEnabled() == false {
            handler(.TenAuthorizationStatusDenied, CLLocation())
            return
        }
        let locationManager = CLLocationManager()
        self.handle = handler
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let loation = locations.last
        self.handle!(.TenAuthorizationStatusAuthorized, manager.location!)
        manager.stopUpdatingLocation()
    }
}











// MARK: - ❤️蓝牙
/**无参常规回调**/
typealias BluetoothNormalAction = (() -> Void);

@objcMembers class BluetoothAuthManager: NSObject {
    /**对象单例**/
    private static let shareInstance = BluetoothAuthManager.init();
    /**回调数组**/
    private var onceAuthStateUpdateActions: [BluetoothNormalAction] = [BluetoothNormalAction]();
    /**获取权限用的暂存蓝牙管理类**/
    private lazy var centralManager: CBCentralManager = {
        return CBCentralManager.init(delegate: BluetoothAuthManager.shareInstance, queue: nil, options: [
            CBCentralManagerOptionShowPowerAlertKey : false,//不弹出链接新设备的系统弹窗
        ]);
    }();
    /**数据处理的队列**/
    private let barrierQueue = DispatchQueue.init(label: "com.widget.bluetoothAuthBarrierQueue", qos: .default, attributes: .concurrent);
    
}

///MARK: Public class method
extension BluetoothAuthManager {
    /**
     请求蓝牙权限状态
     - Parameter restrictedAction: APP无权使用，并且用户无法更改（需要在【屏幕使用时间 -> 隐私访问限制中】修改设置）.
     - Parameter deniedAction: 对APP拒绝授权（要跳转设置中对该APP打开蓝牙权限）.
     - Parameter unsupportedAction: APP已授权蓝牙，但蓝牙在设备上不可用（手机的蓝牙坏了，一般不会出现）.
     - Parameter offAction: APP已授权蓝牙，但蓝牙被关闭了（系统设置关闭或者控制中心关闭）.
     - Parameter onAction: APP已授权蓝牙，并且蓝牙可用（可以进行扫描和链接的操作）.
     - Returns: Void.
     */
    static func requestAuthStateAction(restrictedAction:BluetoothNormalAction? = nil,
                                       deniedAction:BluetoothNormalAction? = nil,
                                       unsupportedAction:BluetoothNormalAction? = nil,
                                       offAction:BluetoothNormalAction? = nil,
                                       onAction:BluetoothNormalAction? = nil) {
        //iOS13以上才有针对APP的蓝牙权限，13中是对象方法
        let authState: CBManagerAuthorization = CBCentralManager.authorization
        //针对蓝牙对APP的权限做对应处理
        switch authState {
        case .notDetermined:
            //用户未作出选择（需要第一次请求授权）
            //请求一次蓝牙状态变更的回调，在回调中重新处理蓝牙权限判断逻辑
            self.askOnceAuthStateUpdateAction {
                self.requestAuthStateAction(restrictedAction: restrictedAction, deniedAction: deniedAction, unsupportedAction: unsupportedAction, offAction: offAction, onAction: onAction);
            };
            break;
        case .restricted:
            //APP无权使用，并且用户无法更改（需要在【屏幕使用时间 -> 隐私访问限制中】修改设置）
            self.performAction(inMainQueue: restrictedAction);
            break;
        case .denied:
            //APP无权使用（未对APP授权），此时state == unauthorized，需跳转给APP授权蓝牙
            self.performAction(inMainQueue: deniedAction);
            break;
        case .allowedAlways:
            //开启并有权使用
            //判断当前的设置中的蓝牙的状态
            self.dealAllowedAction(unsupportedAction: unsupportedAction, unauthorizedAction: deniedAction, offAction: offAction, onAction: onAction);
            break;
        @unknown default:
            self.performAction(inMainQueue: deniedAction);
            break
        }
    }
    
    
    static func requestBluetoothStateAction() -> (CBManagerAuthorization, Bool) {
        //iOS13以上才有针对APP的蓝牙权限，13中是对象方法
        let authState: CBManagerAuthorization = CBCentralManager.authorization
        //针对蓝牙对APP的权限做对应处理
        switch authState {
        case .notDetermined:
            //用户未作出选择（需要第一次请求授权）
            //请求一次蓝牙状态变更的回调，在回调中重新处理蓝牙权限判断逻辑
            let state = self.shareInstance.centralManager.state
            return (.notDetermined, state == CBManagerState.poweredOn)
        case .restricted:
            //APP无权使用，并且用户无法更改（需要在【屏幕使用时间 -> 隐私访问限制中】修改设置）
            return (.restricted, false)
        case .denied:
            //APP无权使用（未对APP授权），此时state == unauthorized，需跳转给APP授权蓝牙
            return (.denied, false)
        case .allowedAlways:
            //开启并有权使用
            //判断当前的设置中的蓝牙的状态
            let state = self.shareInstance.centralManager.state
            return (.allowedAlways, state == CBManagerState.poweredOn)
        @unknown default:
            let state = self.shareInstance.centralManager.state
            return (.notDetermined, state == CBManagerState.poweredOn)
        }
    }
}

// Private class method
extension BluetoothAuthManager {
    /**
     处理蓝牙状态判断逻辑
     - Parameter unsupportedAction: 该平台不支持蓝牙（蓝牙坏了，一般不会用到）.
     - Parameter unauthorizedAction: 该应用未授权（用户禁止APP使用蓝牙权限）.
     - Parameter offAction: 蓝牙关闭（设置中或者控制中心中关闭）.
     - Parameter onAction: 蓝牙打开并可以连接.
     - Returns: Void.
     */
    private static func dealAllowedAction(unsupportedAction:BluetoothNormalAction?,
                                          unauthorizedAction:BluetoothNormalAction?,
                                          offAction:BluetoothNormalAction?,
                                          onAction:BluetoothNormalAction?) {
        let state = self.shareInstance.centralManager.state;
        switch state {
        case .unknown, .resetting:
            //未知状态 || 与系统服务丢失状态（立即更新）
            //因为会立即更新，因此请求一次状态更新回调，对更新后的状态再判断处理
            self.askOnceAuthStateUpdateAction {
                self.dealAllowedAction(unsupportedAction: unsupportedAction, unauthorizedAction: unauthorizedAction, offAction: offAction, onAction: onAction);
            };
            break;
        case .unsupported:
            //该平台不支持蓝牙（蓝牙坏了，一般不会用到）
            self.performAction(inMainQueue: unsupportedAction);
            break;
        case .unauthorized:
            //该应用未授权（用户禁止了蓝牙权限）
            self.performAction(inMainQueue: unauthorizedAction);
            break;
        case .poweredOff:
            //蓝牙关闭（设置中或者控制中心中关闭）
            self.performAction(inMainQueue: offAction);
            break;
        case .poweredOn:
            //蓝牙打开并可以连接
            self.performAction(inMainQueue: onAction);
            break;
        @unknown default:
            self.performAction(inMainQueue: offAction)
        }
    }
    
    /**
     请求一次权限授权状态变更（单次，首次会弹出系统弹窗）
     - Parameter action: 权限变化的回调（在这里通过requestAuthStateAction处理后续逻辑）.
     - Returns: Void.
     */
    private static func askOnceAuthStateUpdateAction(action:BluetoothNormalAction?) {
        self.shareInstance.askOnceAuthStateUpdateAction(action: action);
    }
    
    /**主线程中回调**/
    private static func performAction(inMainQueue action: BluetoothNormalAction?) {
        DispatchQueue.main.async {
            action?();
        }
    }
}

/// Private object method
extension BluetoothAuthManager {
    /**
     请求一次权限授权状态变更（单次，首次会弹出系统弹窗）
     - Parameter action: 权限变化的回调（在这里通过requestAuthStateAction处理后续逻辑）.
     - Returns: Void.
     */
    private func askOnceAuthStateUpdateAction(action: BluetoothNormalAction?) {
        if let action = action {
            //需要回调，保存回调
            self.barrierQueue.sync { [weak self] in
                guard let `self` = self else { return }
                self.onceAuthStateUpdateActions.append(action);
            }
        }
    }
    
    /**蓝牙设备状态更新处理**/
    private func dealCentralManagerDidUpdateState(_ central: CBCentralManager) {
        for action in self.onceAuthStateUpdateActions {
            Self.performAction(inMainQueue: action);
        }
        self.barrierQueue.sync { [weak self] in
            guard let `self` = self else { return }
            self.onceAuthStateUpdateActions = .init();
        }
    }
}

// CBCentralManagerDelegate
extension BluetoothAuthManager: CBCentralManagerDelegate {
    /**蓝牙设备状态更新**/
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        self.dealCentralManagerDidUpdateState(central);
    }
}












// MARK: - ❤️健康Health
class HealthAuthManager: NSObject {
    
    /// 获取某种健康类型的权限状态
    static func healthStatus(objectType: HKObjectType) -> TenAuthorizationStatus {
        var status: TenAuthorizationStatus
        
        switch HKHealthStore().authorizationStatus(for: objectType) {
            case .sharingAuthorized:
                status = .TenAuthorizationStatusAuthorized
            case .notDetermined:
                status = .TenAuthorizationStatusNotDetermined
            case .sharingDenied:
                status = .TenAuthorizationStatusDenied
            default:
                status = .TenAuthorizationStatusDenied
        }
        return status
    }
    
    
    /// 权限请求 health
    static func requestAuthorization(_ handler : @escaping ((TenAuthorizationStatus)->())) {
        
        //1. 检查 HealthKit 是否在设备上有效
        guard HKHealthStore.isHealthDataAvailable() else {
            handler(.TenAuthorizationStatusRestricted)
            return
        }
        
        //2. Prepare the data types that will interact with HealthKit
        guard
            let stepCount = HKObjectType.quantityType(forIdentifier: .stepCount), //步数
            let distanceWalkingRunning = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning), //步行跑步距离
            let basalEnergyBurned = HKObjectType.quantityType(forIdentifier: .basalEnergyBurned), //基础能量燃烧
            let activeEnergyBurned = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) //活性能量燃烧
        else {
            handler(.TenAuthorizationStatusRestricted)
            return
        }
        
        
        //3. Prepare a list of types you want HealthKit to read and write
        let healthKitTypesToWrite: Set<HKSampleType> = []

        let healthKitTypesToRead: Set<HKObjectType> = [
            stepCount,
            distanceWalkingRunning,
            basalEnergyBurned,
            activeEnergyBurned
        ]
        
        //4. Request Authorization
        HKHealthStore().requestAuthorization(toShare: healthKitTypesToWrite, read: healthKitTypesToRead) { (success, error) in
            if success == true && error == nil {
                handler(.TenAuthorizationStatusAuthorized)
            }else
            {
                handler(.TenAuthorizationStatusDenied)
            }
        }
    }
}


extension HealthAuthManager {
    
    /// 获取步数
    class func getStepCount() -> Int {
        let healthKitStore = HKHealthStore()
        var stepCount = 0.0
        let signal = DispatchSemaphore(value: 0);//当前signal车库中剩余0个位置
        
        let date = Date()
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: date, options: .strictStartDate)
        let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount)
        let sortDescriptor = Foundation.NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        let query = HealthKit.HKSampleQuery(sampleType: stepCountType!, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { query, results, error in
            if error == nil || results != nil {
                for samples in results! {
                    stepCount = stepCount + (samples as! HKCumulativeQuantitySample).sumQuantity.doubleValue(for: HKUnit.count())
                }
                signal.signal()
            }else {
                signal.signal()
            }
        }
        healthKitStore.execute(query)
        
        let _ = signal.wait(timeout: .distantFuture)//一直等到signal库中有空位了，才会往下继续执行
        return Int(stepCount)
    }
    /// 获取步数
    class func getStepCount(handler: @escaping ((Int)->())) {
        let healthKitStore = HKHealthStore()
        var stepCount = 0.0
        
        let date = Date()
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: date, options: .strictStartDate)
        let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount)
        let sortDescriptor = Foundation.NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        let query = HealthKit.HKSampleQuery(sampleType: stepCountType!, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { query, results, error in
            if error == nil || results != nil {
                for samples in results! {
                    stepCount = stepCount + (samples as! HKCumulativeQuantitySample).sumQuantity.doubleValue(for: HKUnit.count())
                }
                handler(Int(stepCount))
            }else {
                handler(Int(stepCount))
            }
        }
        healthKitStore.execute(query)
    }
    
    
    /// 获取距离
    class func getDistance() -> Double {
        let healthKitStore = HKHealthStore()
        var distance = 0.0
        let signal = DispatchSemaphore(value: 0);//当前signal车库中剩余0个位置
        
        let date = Date()
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: date, options: .strictStartDate)
        let distanceWalkingRunningType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)
        let sortDescriptor = Foundation.NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        let query = HealthKit.HKSampleQuery(sampleType: distanceWalkingRunningType!, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { query, results, error in
            if error == nil || results != nil {
                for samples in results! {
                    distance = distance + (samples as! HKCumulativeQuantitySample).sumQuantity.doubleValue(for: HKUnit.meterUnit(with: .kilo))
                }
                signal.signal()
            }else {
                signal.signal()
            }
        }
        healthKitStore.execute(query)
        
        let _ = signal.wait(timeout: .distantFuture)//一直等到signal库中有空位了，才会往下继续执行
        return distance
    }
    /// 获取距离
    class func getDistance(handler: @escaping ((Double)->())) {
        let healthKitStore = HKHealthStore()
        var distance = 0.0
        
        let date = Date()
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: date, options: .strictStartDate)
        let distanceWalkingRunningType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)
        let sortDescriptor = Foundation.NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        let query = HealthKit.HKSampleQuery(sampleType: distanceWalkingRunningType!, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { query, results, error in
            if error == nil || results != nil {
                for samples in results! {
                    distance = distance + (samples as! HKCumulativeQuantitySample).sumQuantity.doubleValue(for: HKUnit.meterUnit(with: .kilo))
                }
                handler(distance)
            }else {
                handler(distance)
            }
        }
        healthKitStore.execute(query)
    }
    
    
    
    
    /// 获取 静息能量+活动能量
    class func getEnergyBurned() -> Double {
        let healthKitStore = HKHealthStore()
        var energyBurned = 0.0
        let signal = DispatchSemaphore(value: 0);//当前signal车库中剩余0个位置
        
        let date = Date()
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: date, options: .strictStartDate)
        let basalEnergyBurned = HKObjectType.quantityType(forIdentifier: .basalEnergyBurned)! //基础能量燃烧
        let activeEnergyBurned = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)! //活性能量燃烧
        if #available(iOS 15.0, *) {
            let queryDescriptors: [HKQueryDescriptor] = [
                HKQueryDescriptor(sampleType: basalEnergyBurned, predicate: predicate),
                HKQueryDescriptor(sampleType: activeEnergyBurned, predicate: predicate)
            ]
            let query = HealthKit.HKSampleQuery(queryDescriptors: queryDescriptors, limit: HKObjectQueryNoLimit) { query, results, error in
                if error == nil || results != nil {
                    for samples in results! {
                        energyBurned = energyBurned + (samples as! HKCumulativeQuantitySample).sumQuantity.doubleValue(for: HKUnit.kilocalorie())
                    }
                    signal.signal()
                }else {
                    signal.signal()
                }
            }
            healthKitStore.execute(query)
            
            let _ = signal.wait(timeout: .distantFuture)//一直等到signal库中有空位了，才会往下继续执行
            return energyBurned
            
        } else {
            let sortDescriptor = Foundation.NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
            let query = HealthKit.HKSampleQuery(sampleType: basalEnergyBurned, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { query, results, error in
                if error == nil || results != nil {
                    for samples in results! {
                        energyBurned = energyBurned + (samples as! HKCumulativeQuantitySample).sumQuantity.doubleValue(for: HKUnit.kilocalorie())
                    }
                    signal.signal()
                }else {
                    signal.signal()
                }
            }
            healthKitStore.execute(query)
            signal.wait()
            let query2 = HealthKit.HKSampleQuery(sampleType: activeEnergyBurned, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { query, results, error in
                if error == nil || results != nil {
                    for samples in results! {
                        energyBurned = energyBurned + (samples as! HKCumulativeQuantitySample).sumQuantity.doubleValue(for: HKUnit.kilocalorie())
                    }
                    signal.signal()
                }else {
                    signal.signal()
                }
            }
            healthKitStore.execute(query2)
            
            let _ = signal.wait(timeout: .distantFuture)//一直等到signal库中有空位了，才会往下继续执行
            return energyBurned
        }
        
       
    }
    /// 获取 静息能量+活动能量
    class func getEnergyBurned(handler: @escaping ((Double)->())) {
        let healthKitStore = HKHealthStore()
        var energyBurned = 0.0
        
        let date = Date()
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: date, options: .strictStartDate)
        let basalEnergyBurned = HKObjectType.quantityType(forIdentifier: .basalEnergyBurned)! //基础能量燃烧
        let activeEnergyBurned = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)! //活性能量燃烧
        if #available(iOS 15.0, *) {
            let queryDescriptors: [HKQueryDescriptor] = [
                HKQueryDescriptor(sampleType: basalEnergyBurned, predicate: predicate),
                HKQueryDescriptor(sampleType: activeEnergyBurned, predicate: predicate)
            ]
            let query = HealthKit.HKSampleQuery(queryDescriptors: queryDescriptors, limit: HKObjectQueryNoLimit) { query, results, error in
                if error == nil || results != nil {
                    for samples in results! {
                        energyBurned = energyBurned + (samples as! HKCumulativeQuantitySample).sumQuantity.doubleValue(for: HKUnit.kilocalorie())
                    }
                    handler(energyBurned)
                }else {
                    handler(energyBurned)
                }
            }
            healthKitStore.execute(query)
            
        } else {
            let sortDescriptor = Foundation.NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
            let query = HealthKit.HKSampleQuery(sampleType: basalEnergyBurned, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { query, results, error in
                if error == nil || results != nil {
                    for samples in results! {
                        energyBurned = energyBurned + (samples as! HKCumulativeQuantitySample).sumQuantity.doubleValue(for: HKUnit.kilocalorie())
                    }
                    // 获取动态能量消耗
                    let query2 = HealthKit.HKSampleQuery(sampleType: activeEnergyBurned, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { query, results, error in
                        if error == nil || results != nil {
                            for samples in results! {
                                energyBurned = energyBurned + (samples as! HKCumulativeQuantitySample).sumQuantity.doubleValue(for: HKUnit.kilocalorie())
                            }
                            handler(energyBurned)
                        }else {
                            handler(energyBurned)
                        }
                    }
                    healthKitStore.execute(query2)
                }else {
                    handler(energyBurned)
                }
            }
            healthKitStore.execute(query)
        }
        
       
    }
    
}
