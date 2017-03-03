//
//  RMBLEBatteryService.swift
//  RMBLEManager
//
//  Created by Rodrigo Morbach on 01/03/17.
//  Copyright © 2017 Morbach Inc. All rights reserved.
//

import UIKit
//Battery Service defined in https://www.bluetooth.com/specifications/gatt/viewer?attributeXmlFile=org.bluetooth.service.battery_service.xml
let serviceIdentifier = "180F"

//Battery level defined in https://www.bluetooth.com/specifications/gatt/viewer?attributeXmlFile=org.bluetooth.characteristic.battery_level.xml
let dataIdentifier = "2A19"

public class RMBLEBatteryService: RMBLEGenericService {
    
    private var batteryLevel: String = ""
    
    //Check wether this is the desired service. Compare the service identifier
    open override class func isCorrectService(service: CBService)->Bool?
    {
        if service.uuid.uuidString == serviceIdentifier
        {
            return true
        }
        return false
    }
    
    override public init(with service: CBService) {
        super.init(with: service)
        if service.characteristics != nil
        {
            for c in service.characteristics!
            {
                if c.uuid.uuidString == dataIdentifier
                {
                    self.characteristic = c;
                    calcBatteryValue(characteristic: c)
                    break;
                }
            }
        }
    }
    
    override public func updateData(characteristic: CBCharacteristic) {
        self.characteristic = characteristic
        calcBatteryValue(characteristic: characteristic)
    }
    
    private func calcBatteryValue(characteristic: CBCharacteristic)
    {
        if let data = characteristic.value {
            var values = [UInt8](repeating: 0, count: data.count)
            data.copyBytes(to: &values, count: data.count)
            self.batteryLevel = String(format: "%d", values[0])
        }
    }
    
    override public func getValue() -> String? {
        return self.batteryLevel
    }
    
}
