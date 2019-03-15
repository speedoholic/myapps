//
//  AddAppViewController.swift
//  My Apps
//
//  Created by Kushal Ashok on 3/15/19.
//  Copyright © 2019 my. All rights reserved.
//

import UIKit

protocol AddAppDelegate: class {
    func addApp(_ newApp: MyApp)
}

class AddAppViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField?
    @IBOutlet weak var bundleIdTextField: UITextField?
    @IBOutlet weak var actionButton: UIButton?
    
    weak var addAppDelegate:AddAppDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func actionButtonTapped(_ sender: Any) {
        if let name = nameTextField?.text,
            let bundleId = bundleIdTextField?.text {
            print("Addin app \(name) with bundle ID: \(bundleId)")
            let newApp = MyApp()
            newApp.trackName = name
            newApp.bundleId = bundleId
            addAppDelegate?.addApp(newApp)
            self.navigationController?.popViewController(animated: true)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
