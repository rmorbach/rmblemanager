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
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.backgroundColor = UIColor.cyan
        self.tableView.refreshControl?.tintColor = UIColor.white
        self.tableView.refreshControl?.addTarget(self, action: #selector(reloadTable), for: UIControlEvents.valueChanged)
        let attributedTextProperties = [NSForegroundColorAttributeName: UIColor.black]
        let attributedString = NSAttributedString(string: "Scanning devices", attributes: attributedTextProperties)
        self.tableView.refreshControl?.attributedTitle = attributedString
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
    
    func reloadTable()
    {
        self.devices.removeAll()
        self.tableView.reloadData()
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
        if devices.count > 0
        {
            self.tableView.backgroundView = nil
            self.tableView.separatorStyle = .singleLine
            return 1
        }
        let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100))
        emptyLabel.text = "None devices have been found"
        emptyLabel.textColor = UIColor.red
        emptyLabel.textAlignment = NSTextAlignment.center
        emptyLabel.sizeToFit()
        self.tableView.backgroundView = emptyLabel
        self.tableView.separatorStyle = .none
        return 0
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
        if let refreshControl = self.tableView.refreshControl
        {
            if refreshControl.isRefreshing
            {
                refreshControl.endRefreshing()
            }
        }
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


