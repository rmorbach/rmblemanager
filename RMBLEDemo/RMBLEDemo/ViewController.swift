//
//  ViewController.swift
//  RMBLEDemo
//
//  Created by Rodrigo Morbach on 01/03/17.
//  Copyright © 2017 Morbach Inc. All rights reserved.
//

import UIKit
import RMBLEManager

class ViewController: UIViewController {
    
    var bleManager = RMBLEManager.sharedBLEManager
    var batteryService: RMBLEBatteryService?
    
    
    @IBOutlet weak var batteryLevelLabel: UILabel!
    
    @IBOutlet weak var status: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.bleManager.delegate = self
        if let storedUUID = UserDefaults.standard.string(forKey: "connectUUID")
        {
            let uuid = UUID(uuidString: storedUUID)!
            self.bleManager.connect(to: uuid)
            self.bleManager.startScan()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
}
extension ViewController: RMBLEManagerProtocol
{
    func bleManager(bleManager: RMBLEManager?, didFail error: RMBLEError) {
        
    }
    
    
    func bleManager(bleManager: RMBLEManager?, didDeviceReady peripheral: CBPeripheral?) {
        for service in peripheral!.services!
        {
            if RMBLEBatteryService.isCorrectService(service: service)!{
                self.batteryService = RMBLEBatteryService(with: service)
                self.bleManager.setNotifyState(for: self.batteryService?.characteristic, enabled: true)
                guard let v = self.batteryService?.getValue() else
                {
                    return
                }
                self.batteryLevelLabel.text = "Battery: \(v) %"
            }
        }
    }
    func bleManager(bleManager: RMBLEManager?, didDiscover peripheral: CBPeripheral?) {
        
    }
    
    func bleManager(bleManager: RMBLEManager?, didWrite characteristic: CBCharacteristic?) {
        
    }
    
    func bleManager(bleManager: RMBLEManager?, didGetNotification characteristic: CBCharacteristic?) {
        if RMBLEBatteryService.isCorrectService(service: characteristic!.service)!
        {
            self.batteryService!.updateData(characteristic: characteristic!)
            guard let v = self.batteryService?.getValue() else
            {
                return
            }
            self.batteryLevelLabel.text = "Battery: \(v) %"
        }
    }
    
    func bleManager(bleManager: RMBLEManager?, didDisconnect peripheral: CBPeripheral) {
        self.status.text = "Disconnected"
        self.batteryLevelLabel.isHidden = true
    }
    
    func bleManager(bleManager: RMBLEManager?, didConnect peripheral: CBPeripheral?) {
        self.status.text = "Connected to \(peripheral!.name!)"
        self.batteryLevelLabel.isHidden = false
        self.batteryLevelLabel.text = "-";
    }
}

