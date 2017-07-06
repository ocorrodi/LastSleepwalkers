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

class MainViewController : UIViewController{
    
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
    
    @IBOutlet weak var nameOfContactTextField: UILabel!
    @IBOutlet weak var contactNumber: UILabel!
    @IBOutlet weak var sleepModeLabel: UILabel!
    @IBOutlet weak var mainButton: UIButton!

    //Functions
    
    
    @IBAction func getHelpButtonTapped(_ sender: UIButton) {
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self as! MFMessageComposeViewControllerDelegate
        
        
        //configure content
        let location = getLocation(manager: locationManager)
        
        composeVC.recipients = [defaults.string(forKey: "contactNumber")!]
        composeVC.body = "I sleepwalked and need your help! Find me at:"
        self.present(composeVC, animated: true,completion: nil)
    }
    
    //dismiss help controller
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult: MessageComposeResult){
        controller.dismiss(animated: true, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
    }
    
    @IBAction func unwindToViewController(_ segue: UIStoryboardSegue){
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "modifyContact"{
            return true
        }
        if identifier == "toInfo"{
            return true
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainButton.layer.cornerRadius = 100
        
        nameOfContactTextField.text = "Contact Name: " + ( defaults.string(forKey: "contactName"))!
        contactNumber.text = "Contact Number: " + ( defaults.string(forKey: "contactNumber"))!
        
        // For use in background
        self.locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self as? CLLocationManagerDelegate
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
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
    
    func wakeUp() {
        if let urlpath = Bundle.main.path(forResource: "alarmNoise",ofType: "wav") {
            //let url = NSURL.fileURL(withPath: urlpath!)
            let url = URL(fileURLWithPath: urlpath)
            //var audioPlayer = AVAudioPlayer()
            
            do{
                avPlayer = try AVAudioPlayer(contentsOf: url)
                avPlayer.prepareToPlay()
                avPlayer.play()
                mainButton.setAttributedTitle(NSAttributedString(string: clockEmoji), for: .normal)
                mainButton.backgroundColor = UIColor.white
                isRinging = true
                self.sleepModeLabel.text = "Tap to stop alarm ⏰"
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    func getHelp(){
        
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
