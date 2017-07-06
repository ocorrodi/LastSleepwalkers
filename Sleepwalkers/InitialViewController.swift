//
//  InitialViewController.swift
//  Sleepwalkers
//
//  Created by Portia Wang on 7/5/17.
//  Copyright © 2017 Portia Wang. All rights reserved.
//

import Foundation
import UIKit

class InitialViewController: UIViewController{
    
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        let name = defaults.string(forKey: "name")
        if let name = name{
            print("info entered")
            performSegue(withIdentifier: "loggedInSegue", sender: self)
        }else{
            print("no info entered")
            performSegue(withIdentifier: "profileSegue", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
