//
//  ViewController.swift
//  Sleepwalkers
//
//  Created by Portia Wang on 7/4/17.
//  Copyright © 2017 Portia Wang. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

var defaults: UserDefaults = UserDefaults.standard
class ProfileViewController: UIViewController {
    
    //Properties
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var contactNameTextField: UITextField!
    @IBOutlet weak var contactNumberTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    
    
    //Functions
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //segue to main controller if name was entered
        
        nextButton.layer.cornerRadius = 15
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let name = defaults.string(forKey: "name"),
            let nameOfContact = defaults.string(forKey: "contactName"),
            let number = defaults.string(forKey: "contactNumber") {
            nameTextField.text = name
            contactNameTextField.text = nameOfContact
            contactNumberTextField.text = number
        }
        
    }
    
    
    //dismissing keyboard if clicked elsewhere
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //save data in user defaults
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        //
        if (nameTextField.text == "") || (contactNameTextField.text == "") || (contactNumberTextField.text == "") {
            let alertController = UIAlertController(title: "", message:
                "Did you enter all your information correctly?", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } else {
            defaults.set(contactNumberTextField.text, forKey:"contactNumber")
            defaults.set(nameTextField.text, forKey:"name")
            defaults.set(contactNameTextField.text, forKey:"contactName")
            self.performSegue(withIdentifier: "goToMainSegue", sender: self)
        }
    }
    
}

