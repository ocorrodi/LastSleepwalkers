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
    
//properties
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var contactNameTextField: UITextField!
    @IBOutlet weak var contactNumberTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!

    
    
//functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let name = defaults.string(forKey: "name")
        if let name = name{
            performSegue(withIdentifier: "goToMainSegue", sender: self)
        }
        
        
        nextButton.layer.cornerRadius = 15
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func unwindToViewController(_ segue: UIStoryboardSegue){
    }
    

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
        }
    }

}

