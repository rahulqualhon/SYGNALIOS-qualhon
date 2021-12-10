//
//  HomeViewController.swift
//  SYGNAL - CBRNE Training
//
//  Created by IOS on 01/12/21.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func createSessionButtonTapped(_ sender: Any) {
        moveToTrackerList()
    }
    
}
