//
//  CCBLEManager.swift
//  bleManager
//
//  Created by Rodrigo Morbach on 01/03/17.
//  Copyright © 2017 Morbach Inc. All rights reserved.
//

import UIKit
import CoreBluetooth

public class RMBLEManager: NSObject {
    
    public static let sharedBLEManager = RMBLEManager()
    
    open var devices = [CBPeripheral]()
    
    weak open var delegate: RMBLEManagerProtocol?
    
    //A peripheral the central is currently connected to
    open var peripheral: CBPeripheral?
    
    open var central: CBCentralManager?
    
    //Initilize the scanning process
    public func startScan() {
        if self.central!.isScanning {
            self.central!.stopScan()
        }
        if self.central!.state == .poweredOn {
            self.central?.scanForPeripherals(withServices: nil, options: nil)
        } else {
            self.callErrorDelegate(for: self.central!.state)
        }
    }
    
    //Stops the scanning process
    open func stopScan() {
        self.central!.stopScan()
    }
    
    //Set the device to connect to when scanning devices
    open func connect(to device: UUID) {
        self.identifierToConnect = device;
    }
    
    // "Subscribe" for receiving updates from the given characteristic
    open func setNotifyState(for characteristic: CBCharacteristic?, enabled: Bool) {
        if characteristic != nil {
            if self.peripheral != nil {
                self.peripheral!.setNotifyValue(enabled, for: characteristic!)
            }
        }
    }
    
    //MARK: - private methods and properties
    var identifierToConnect: UUID?
    
    private override init() {
        super.init()
        central = CBCentralManager(delegate: self, queue: nil)        
    }
    
}

// MARK: - CBCentralManagerDelegate Methods
extension RMBLEManager: CBCentralManagerDelegate {
    //MARK: CBCentralManagerDelegate methods
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            self.central?.scanForPeripherals(withServices: nil, options: nil)
        default:
            self.callErrorDelegate(for: central.state)
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        self.peripheral = peripheral;
        self.peripheral!.delegate = self
        self.peripheral!.discoverServices(nil)
        if self.delegate != nil {
            self.delegate?.bleManager(bleManager: self, didConnect: peripheral)
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !self.devices.contains(peripheral) {
            self.devices.append(peripheral)
        }
        if self.identifierToConnect != nil {
            if peripheral.identifier.uuidString == self.identifierToConnect!.uuidString {
                self.central!.connect(peripheral, options: nil)
            }
        }
        if self.delegate != nil {
            self.delegate?.bleManager(bleManager: self, didDiscover: peripheral)
        }
        
    }
    
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if self.delegate != nil {
            self.delegate?.bleManager(bleManager: self, didDisconnect: peripheral)
        }

    }
    
}

//MARK: CBPeripheralDelegate Methods
extension RMBLEManager: CBPeripheralDelegate
{
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            self.peripheral!.discoverCharacteristics(nil, for: service)
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let s = self.peripheral!.services!.last else {
            return
        }
        
        if service.uuid.uuidString == s.uuid.uuidString {
            if self.delegate != nil {
                self.delegate?.bleManager(bleManager: self, didDeviceReady: peripheral)
            }
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil { return }
        if self.delegate != nil {
            self.delegate!.bleManager(bleManager: self, didGetNotification: characteristic)
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {        
        if self.delegate != nil {
            self.delegate!.bleManager(bleManager: self, didWrite: characteristic)
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        if self.delegate != nil {
          self.delegate?.bleManager(bleManager: self, didReadRSSI: RSSI, fromPeripheral: peripheral)
        }
    }
}

//MARK: Error delegate method
extension RMBLEManager
{
    func callErrorDelegate(for centralState: CBManagerState) {
        if self.delegate != nil {
            var state = RMBLEError.unknown
            switch centralState {
            case .poweredOff:
                state = .poweredOff
                break;
            case .resetting:
                state = .resetting;
                break;
            case .unauthorized:
                state = .unauthorized;
                break;
            case .unsupported:
                state = .unsupported
            default:
                state = .unknown;
                break
            }
            self.delegate!.bleManager(bleManager: self, didFail: state)
        }
    }
}




