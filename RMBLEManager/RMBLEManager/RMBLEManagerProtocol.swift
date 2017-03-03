//
//  RMBLEManagerProtocol.swift
//  CC2650
//
//  Created by Rodrigo Morbach on 01/03/17.
//  Copyright © 2017 Morbach Inc. All rights reserved.
//

import Foundation
import CoreBluetooth

public enum RMBLEError
{
    case unsupported, unauthorized, resetting, poweredOff, unknown;
}

public protocol RMBLEManagerProtocol: NSObjectProtocol {
    //Called when the device has connected to a peripheral successfully
    func bleManager(bleManager: RMBLEManager?, didConnect peripheral: CBPeripheral?)->Void;
    
    //Called when all characteristics from a service has been read
    func bleManager(bleManager: RMBLEManager?, didDeviceReady peripheral: CBPeripheral?)->Void;
    
    //Called when a characteristic has updated its data
    func bleManager(bleManager: RMBLEManager?, didGetNotification characteristic: CBCharacteristic?)->Void;
    
    //Called after the write method of a peripheral has been called
    func bleManager(bleManager: RMBLEManager?, didWrite characteristic: CBCharacteristic?)->Void;
    
    //Called when a peripheral has been found
    func bleManager(bleManager: RMBLEManager?, didDiscover peripheral: CBPeripheral?)->Void;
    
    //Called when something goes wrong
    func bleManager(bleManager: RMBLEManager?, didFail error: RMBLEError)->Void;
    
    //Called when the device disconnects from the current peripheral
    func bleManager(bleManager: RMBLEManager?, didDisconnect peripheral: CBPeripheral)->Void;
}
