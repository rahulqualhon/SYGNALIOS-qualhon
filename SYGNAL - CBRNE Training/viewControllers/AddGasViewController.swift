//
//  AddGasViewController.swift
//  SYGNAL - CBRNE Training
//
//  Created by IOS on 01/12/21.
//

import UIKit
import iOSDropDown

class AddGasViewController: UIViewController {

    @IBOutlet weak var minAlertTF: UITextField!
    @IBOutlet weak var gasDropDown: DropDown!
    @IBOutlet weak var alertTF: UITextField!
    @IBOutlet weak var percentageDropDown: DropDown!
    
    var deviceList : DevicesModel?
    var selectedGas = ""
    var selectedBLEDevice = ""
    var selectedGasScale = ""
    var minAlertValue = 2.0
    var alertValue = 18.0
    var item = ["1","2","3","4","5","6"]
    var arrsessionRange = ["500 m","1 km","3 km","5 km","10 km","20 km","50 km","100 km","No Limit"]
    var arrSelectGas = ["Oxygen",
                           "Carbon Monoxide (CO)",
                           "Methane","Chlotine (CL2)",
                           "Hydrogen Sulfide (H2S)",
                           "sulfur Dioxide (SO2)",
                           "Nitric Oxide (NO)"
                           ,"Chlorine Dioxide (CLO2)",
                           "Hydrogen Cyanide (HCN)",
                           "Hydrogen Chloride (HCL)",
                           "Phosphine (PH3)",
                           "Nitrogen Oxide (NO2)",
                           "Hydrogen (H2)",
                           "Ammonia (NH3)",
                           "Carbon Dioxide (CO2)",
                           "Gamma","VOC","PID","LEL",]
    
    var bleName = ["oxy_ble",
                           "car_mono_ble",
                           "meth_ble","chlotine_ble",
                           "hydro_sul_ble",
                           "sul_dio_ble",
                           "nitric_oxy_ble"
                           ,"chl_dio_ble",
                           "hydro_cyn_ble",
                           "hydro_chl_ble",
                           "phosphine_ble",
                           "nitro_oxi_ble",
                           "hydrogen_ble",
                           "ammonia_ble",
                           "car_dio_ble",
                           "gamma_ble","voc_ble","pid_ble","lel_ble"]
    
    var arrSelectGasScale = ["%","%LEL","PPM","PPB","%VOL","µSv","µSv/h","µRem","mRem"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        gasDropDown.optionArray = arrSelectGas
        percentageDropDown.optionArray = arrSelectGasScale
        
        gasDropDown.didSelect{(selectedText , index ,id) in
                self.selectedGas = selectedText
            self.selectedBLEDevice = self.bleName[index]
        }
     
        percentageDropDown.didSelect{(selectedText , index ,id) in
                self.selectedGasScale = selectedText
        }
        
    }
    
    @IBAction func valueChangeButtonsTapped(_ sender: UIButton) {
        switch sender.tag {
        case 101:
                if minAlertValue > 1 {
                    minAlertValue -= 0.5
                    minAlertTF.text = "\(minAlertValue) f."
                }
            break
        case 102:
            if (minAlertValue + 0.5) < alertValue {
                if minAlertValue < 30 {
                    minAlertValue += 0.5
                    minAlertTF.text = "\(minAlertValue) f."
                }
            }else {
                showSnackbar(message: "Min Alert value can not be greater than Alert value", isErrorMessage: true)
            }
            break
        case 103:
            if (alertValue - 0.5) > minAlertValue {
                if alertValue > 1 {
                    alertValue -= 0.5
                    alertTF.text = "\(alertValue) f."
                }
            }else {
                showSnackbar(message: "Alert value can not be lesser than Min Alert value", isErrorMessage: true)
            }
            break
        default:
                if alertValue < 30 {
                    alertValue += 0.5
                    alertTF.text = "\(alertValue) f."
                }
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if isValid() {
            deviceList = DevicesModel(gasName: selectedGas, min: minAlertValue, max: alertValue, scale: selectedGasScale, distance: 0.0, deviceName: self.selectedBLEDevice)
            moveToTrackerList(deviceModel: deviceList!, isGasSaved: true)
        }
    }
    
    func isValid() -> Bool {
        if selectedGas == "" {
            showSnackbar(message: "Please select gas!", isErrorMessage: true)
        }else if selectedGasScale == "" {
            showSnackbar(message: "Please select gas scale!", isErrorMessage: true)
        }else if minAlertValue > alertValue {
            showSnackbar(message: "Min alert value cannot be greater than alert value!", isErrorMessage: true)
        }else {
            return true
        }
        return false
    }
    
}
