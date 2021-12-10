//
//  TrackersListViewController.swift
//  SYGNAL - CBRNE Training
//
//  Created by IOS on 01/12/21.
//

import UIKit
import CoreBluetooth
import CoreLocation
import AVFoundation

class TrackersListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var centralManager: CBCentralManager?
    var peripherals : [BluetoothListModel] = []
    @IBOutlet weak var distanceLabel: UILabel!
    var mainCharacteristic:CBCharacteristic? = nil
    let locationManager = CLLocationManager()
    let systemSoundID: SystemSoundID = 1016
    var deviceList : DevicesModel?
    var isGasSaved = false
    var feeet = 0.0
    var rssii : NSNumber = 0
    var name = ""
    var distancePer = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "TrackerListTableCell", bundle: nil), forCellReuseIdentifier: "TrackerListTableCell")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.locationManager.stopUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
        // bluetooth manager
        centralManager = CBCentralManager(delegate: self, queue: nil)
        centralManager?.scanForPeripherals(withServices: nil, options: nil)
        if isGasSaved {
            name = deviceList?.gasName ?? ""
            let bluetoothObjct = BluetoothListModel(name: deviceList?.gasName ?? "", distance: feeet, RSSSI: 0, gasName: deviceList?.gasName ?? "", min: deviceList?.min ?? 0.0, max: deviceList?.max ?? 0.0, scale: deviceList?.scale ?? "")
            peripherals.append(bluetoothObjct)
            tableView.reloadData()
        }
    }
    
    @IBAction func addGasButtonTapped(_ sender: Any) {
        moveToAddGas()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        moveToHome()
    }
    
}

extension TrackersListViewController: CBCentralManagerDelegate, CBPeripheralDelegate, CLLocationManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if (central.state == .poweredOn){
            self.centralManager?.scanForPeripherals(withServices: nil, options: nil)
        }
        else {
            // do something like alert the user that ble is not on
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        // Carlyle HR 0053
        print("Distance --- \(peripheral.name ?? "")")// Noisefit Active
       let namee = peripheral.name ?? ""
        if isGasSaved { // Colorfit Pro 2 //\(deviceList?.gasName ?? "")
        if peripheral.name != nil && namee.contains("\(deviceList?.gasName ?? "")") {
            name = peripheral.name ?? ""
           //pow(10, ((-56-Double(rssi))/(10*2)))*3.2808
            let distance =  pow(10.0,((abs((RSSI as AnyObject).doubleValue)-80)/(10*4.3)))

            print("\(peripheral.name ?? "") -- bluetooth")
            feeet = distance * 3.3
            rssii = RSSI
            let maxx = (deviceList?.max ?? 0.0)
            self.distancePer = ((feeet - (deviceList?.min ?? 0.0)) / maxx) * 100
            
            if self.distancePer < (deviceList?.min ?? 0.0) {
                self.distancePer = 0
            }
            
            if self.distancePer > (deviceList?.max ?? 0.0) {
                self.distancePer = 100
            }
            
            self.distanceLabel.text = ""
//            let bluetoothObjct = BluetoothListModel(name: peripheral.name ?? "", distance: feeet, RSSSI: RSSI, gasName: deviceList?.gasName ?? "", min: deviceList?.min ?? 0.0, max: deviceList?.max ?? 0.0, scale: deviceList?.scale ?? "")
//            peripherals.append(bluetoothObjct)
//
            self.centralManager?.stopScan()
            print("Distance --- \(peripheral.name ?? "") --- \(distance) ------ RSSI: \(RSSI)")
        }
        }
       
        tableView.reloadData()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        peripherals.removeAll()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.centralManager?.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
}

extension TrackersListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackerListTableCell", for: indexPath) as! TrackerListTableCell
        
        cell.deviceNameLabel.text = "\(name)"
        cell.distanceLabel.text = "\(String(format: "%.2f", feeet)) f."
        cell.alertValueLabel.text = "\(peripherals[indexPath.row].max) f."
        cell.minAlertValueLabel.text = "\(peripherals[indexPath.row].min) f."
        cell.scaleLabel.text = "\(String(format: "%.1f", self.distancePer)) \(peripherals[indexPath.row].scale)   Gas Name: \(peripherals[indexPath.row].gasName)"
        
        if feeet  < peripherals[indexPath.row].min || feeet > peripherals[indexPath.row].max {
            AudioServicesPlaySystemSound(systemSoundID)
            cell.distanceLabel.textColor = .red
            cell.alertIV.isHidden = false
        }else {
            cell.alertIV.isHidden = true
            cell.distanceLabel.textColor = .white
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripherals.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
