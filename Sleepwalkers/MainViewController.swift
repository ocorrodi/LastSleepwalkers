//
//  MainController.swift
//  Sleepwalkers
//
//  Created by Portia Wang on 7/4/17.
//  Copyright © 2017 Portia Wang. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit
import AVFoundation
import MessageUI
import AddressBookUI
import AudioToolbox

class MainViewController : UIViewController, MFMessageComposeViewControllerDelegate, CLLocationManagerDelegate {
    
    //Properties
    
    let locationManager = CLLocationManager()
    var initLocation = CLLocationCoordinate2D()
    var currentLocation = CLLocationCoordinate2D()
    var isGettingLocation = false
    var isRinging = false
    let sunEmoji = "☀️"
    let moonEmoji = "🌙"
    let clockEmoji = "⏱"
    var avPlayer: AVAudioPlayer!
    let blueColor = UIColor(displayP3Red: 64, green: 161, blue: 255, alpha: 1)
    var location = ""
    let composeVC = MFMessageComposeViewController()
    
    @IBOutlet weak var nameOfContactTextField: UILabel!
    @IBOutlet weak var contactNumber: UILabel!
    @IBOutlet weak var sleepModeLabel: UILabel!
    @IBOutlet weak var mainButton: UIButton!
    

    //Functions
    
    
    @IBAction func settingsButtonTapped(_ sender: Any) {

        self.performSegue(withIdentifier: "editInfo", sender: self)
    }
    
    
    func reverseGeocoing(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        print(location)
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) -> Void in
            print(self.location)
            self.composeVC.recipients = [defaults.string(forKey: "contactNumber")!]
            if self.location != "" {
                self.composeVC.body = "I sleepwalked and need your help! Find me at: \(self.location)!!!"
                self.present(self.composeVC, animated: true,completion: nil)
            }
            
//            if error != nil{
//                print(error)
//                return
//            } else if (placemarks?.count)! > 0 {
//                let pm = placemarks![0]
//                let address = ABCreateStringWithAddressDictionary(pm.addressDictionary!, false)
//                self.location = address
//                //                if (pm.areasOfInterest?.count)! > 0{
//                //                    let areaOfInterest = pm.areasOfInterest?[0]
//                //                    self.location = areaOfInterest!
//                //                }else{
//                //                    self.location = "No description of area"
//                //                }
//            }
        }
    }
    
    
    
    @IBAction func getHelpButtonTapped(_ sender: UIButton) {
        let myLocation = getLocation(manager: locationManager)
        reverseGeocoing(latitude: myLocation.latitude, longitude: myLocation.longitude)
    }
    
    //dismiss help controller
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func unwindToViewController(_ segue: UIStoryboardSegue){
    }
    
//    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//        if identifier == "modifyContact"{
//            return true
//        }
//        if identifier == "toInfo"{
//            return true
//        }
//        return false
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainButton.layer.cornerRadius = 100
        
        composeVC.messageComposeDelegate = self
        
        nameOfContactTextField.text = "Contact Name: " + ( defaults.string(forKey: "contactName"))!
        contactNumber.text = "Contact Number: " + ( defaults.string(forKey: "contactNumber"))!
        
        // For use in background
        self.locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self as? CLLocationManagerDelegate
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        locationManager.delegate = self
    }
    
    
    
    @IBAction func mainButtonTapped(_ sender: UIButton) {
        
        //wakeUp()
        if isRinging{
            avPlayer.stop()
            isRinging = false
            isGettingLocation = false
            mainButton.setAttributedTitle(NSAttributedString(string: sunEmoji), for: .normal)
            mainButton.backgroundColor = UIColor.yellow
            self.initLocation = self.getLocation(manager: locationManager)
            self.sleepModeLabel.text = "Tap before  😴"
        }
        
        if isGettingLocation {
            isGettingLocation = false
            mainButton.setAttributedTitle(NSAttributedString(string: sunEmoji), for: .normal)
            mainButton.backgroundColor = UIColor.yellow
            self.sleepModeLabel.text = "Tap before  sleeping 😴"
            
        } else {
            isGettingLocation = true
            mainButton.setAttributedTitle(NSAttributedString(string: moonEmoji), for: .normal)
            mainButton.backgroundColor = UIColor.black
            self.initLocation = self.getLocation(manager: locationManager)
            _ = Timer.scheduledTimer(timeInterval: 5, target: self, selector: Selector("detectLocation"), userInfo: nil, repeats: true)
            self.sleepModeLabel.text = "Tap when awake 🛌"
            
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied {
            let alertController = UIAlertController(title: "", message:
                "Enable location services in settings for sleepwalkers to function properly", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    func wakeUp() {
        if let urlpath = Bundle.main.path(forResource: "alarmNoise",ofType: "wav") {
            //let url = NSURL.fileURL(withPath: urlpath!)
            let url = URL(fileURLWithPath: urlpath)
            //var audioPlayer = AVAudioPlayer()
            
            do{
                avPlayer = try AVAudioPlayer(contentsOf: url)
                avPlayer.prepareToPlay()
                avPlayer.play()
                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
                mainButton.setAttributedTitle(NSAttributedString(string: clockEmoji), for: .normal)
                mainButton.backgroundColor = UIColor.white
                isRinging = true
                self.sleepModeLabel.text = "Tap to stop alarm ⏰"
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    func getLocation(manager: CLLocationManager) -> CLLocationCoordinate2D {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        return locValue
    }
    
    func detectLocation(){
        self.currentLocation = getLocation(manager: locationManager)
        if isGettingLocation {
            let pointI = MKMapPointForCoordinate(initLocation)
            let pointC = MKMapPointForCoordinate(currentLocation)
            var distance : CLLocationDistance = MKMetersBetweenMapPoints(pointI, pointC)
            if distance.magnitude >= 12.5{
                
                wakeUp()
            }
            
        }
    }
    
    
    
}
