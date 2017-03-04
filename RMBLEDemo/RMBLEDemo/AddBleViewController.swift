//
//  AddBleViewController.swift
//  RMBLEDemo
//
//  Created by Rodrigo Morbach on 01/03/17.
//  Copyright © 2017 Morbach Inc. All rights reserved.
//

import UIKit
import RMBLEManager

class AddBleViewController: UIViewController {
    
    var devices = [CBPeripheral]()
    var bleManager = RMBLEManager.sharedBLEManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.bleManager.delegate = self;
        self.devices.removeAll()
        self.bleManager.stopScan()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        bleManager.startScan()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
}

extension AddBleViewController: UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "bleCell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        {
            let peripheral = devices[indexPath.row]
            var name = ""
            if peripheral.name != nil
            {
                name = peripheral.name!
            }
            else
            {
                name = peripheral.identifier.uuidString
            }
            cell.textLabel?.text = name
            return cell
        }
        return UITableViewCell(style: .default, reuseIdentifier: "bleCell")
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
}


extension AddBleViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let peripheral = devices[indexPath.row]
        UserDefaults.standard.setValue(peripheral.identifier.uuidString, forKey: "connectUUID")
        UserDefaults.standard.synchronize()
        self.bleManager.stopScan()
        self.perform(#selector(back), with: nil, afterDelay: 0.3)
    }
}


extension AddBleViewController:RMBLEManagerProtocol
{
    func bleManager(bleManager: RMBLEManager?, didGetNotification characteristic: CBCharacteristic?) {
        
    }
    
    func bleManager(bleManager: RMBLEManager?, didWrite characteristic: CBCharacteristic?) {
        
    }
    
    func bleManager(bleManager: RMBLEManager?, didDeviceReady peripheral: CBPeripheral?) {
        
    }
    
    func bleManager(bleManager: RMBLEManager?, didDiscover peripheral: CBPeripheral?) {
        if devices.contains(peripheral!)
        {
            return
        }
        devices.append(peripheral!)
        self.tableView.reloadData()
        
    }
    
    func bleManager(bleManager: RMBLEManager?, didFail error: RMBLEError) {
        
    }
    
    func bleManager(bleManager: RMBLEManager?, didDisconnect peripheral: CBPeripheral) {
        
    }
    
    func bleManager(bleManager: RMBLEManager?, didConnect peripheral: CBPeripheral?) {
        
    }
}


