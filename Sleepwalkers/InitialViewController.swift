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
    
//Properties
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var mainLabel: UILabel!
    
    
//Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.layer.cornerRadius = 15
        mainLabel.layer.cornerRadius = 15
    }
}
