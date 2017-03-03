//
//  RMBLEGenericService.swift
//  RMBLEManager
//
//  Created by Rodrigo Morbach on 01/03/17.
//  Copyright © 2017 Morbach Inc. All rights reserved.
//
// Extracted from https://www.bluetooth.com/specifications/gatt/services
// Services are collections of characteristics and relationships to other services that encapsulate the behavior of part of a device
// All services you want to monitor must inherit from this class


import UIKit

open class RMBLEGenericService: NSObject {

    public var service: CBService?
    public var characteristic: CBCharacteristic?
    
    //Check wether this is the desired service
    open class func isCorrectService(service: CBService)->Bool?
    {
        //Subclasses should override this
        return nil
    }
    
    public init(with service: CBService)
    {
        super.init()
        self.service = service
        //Subclasses should override this method
    }
    
    //This method should be called when the connected BLE device sends data up-to-date
    open func updateData(characteristic: CBCharacteristic)
    {
        //Subclasses should override this method
    }
    
    //Return the formatted value from this service
    //The calculation of the data might vary from service to service
    open func getValue()->String?
    {
        //Subclasses should override this method
        return nil
    }
    
}
