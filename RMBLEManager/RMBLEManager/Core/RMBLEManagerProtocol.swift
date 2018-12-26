//
//  RMBLEManagerProtocol.swift
//  CC2650
//
//  Created by Rodrigo Morbach on 01/03/17.
//  Copyright © 2017 Morbach Inc. All rights reserved.
//

import Foundation
import CoreBluetooth

public enum RMBLEError {
    case unsupported, unauthorized, resetting, poweredOff, unknown
}

public protocol RMBLEManagerProtocol: NSObjectProtocol {

    /// Called when the device has connected to a peripheral successfully
    ///
    /// - Parameters:
    ///   - bleManager: central manager
    ///   - peripheral: recently connected peripheral
    func bleManager(bleManager: RMBLEManager?, didConnect peripheral: CBPeripheral?)
    
    /// Called when all characteristics from a service has been read
    ///
    /// - Parameters:
    ///   - bleManager: the manager
    ///   - peripheral: peripheral
    /// - Returns:
    func bleManager(bleManager: RMBLEManager?, didDeviceReady peripheral: CBPeripheral?)
    
    
    /// Called when a characteristic has updated its data
    ///
    /// - Parameters:
    ///   - bleManager: central manager
    ///   - characteristic: characteristic which generates the notification
    func bleManager(bleManager: RMBLEManager?, didGetNotification characteristic: CBCharacteristic?)
    
    /// Called after the write method of a peripheral has been called
    ///
    /// - Parameters:
    ///   - bleManager: central manager
    ///   - characteristic: characteristic written
    func bleManager(bleManager: RMBLEManager?, didWrite characteristic: CBCharacteristic?)
    
    /// Called when a peripheral has been found
    ///
    /// - Parameters:
    ///   - bleManager: central manager
    ///   - peripheral: peripheral found
    func bleManager(bleManager: RMBLEManager?, didDiscover peripheral: CBPeripheral?)
    

    /// Called when something goes wrong
    ///
    /// - Parameters:
    ///   - bleManager: central manager
    ///   - error: error occurred
    func bleManager(bleManager: RMBLEManager?, didFail error: RMBLEError)
    
    
    /// Called when the device disconnects from the current peripheral
    ///
    /// - Parameters:
    ///   - bleManager: central manager
    ///   - peripheral: peripheral disconnected
    func bleManager(bleManager: RMBLEManager?, didDisconnect peripheral: CBPeripheral)
    
    
    /// Called when RSSI values have been read
    ///
    /// - Parameters:
    ///   - bleManager: central manager
    ///   - rssi: received signal strength indicator
    ///   - peripheral: peripheral connected
    func bleManager(bleManager: RMBLEManager?, didReadRSSI rssi: NSNumber, fromPeripheral peripheral: CBPeripheral)
}
