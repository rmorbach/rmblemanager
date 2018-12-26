//
//  RMBLEService.swift
//  RMBLEManager
//
//  Created by Rodrigo Morbach on 26/12/18.
//  Copyright © 2018 Morbach Inc. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol RMBLEService {
    static func isCorrect(service: CBService) -> Bool
    func updateData(for characteristic: CBCharacteristic)
    func getValue() -> String?
}
