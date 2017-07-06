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
    
    //properties
    let locationManager = CLLocationManager()
    @IBOutlet weak var mainButton: UIButton!
    var initLocation = CLLocationCoordinate2D()
    var currentLocation = CLLocationCoordinate2D()
    
    @IBOutlet weak var nameOfContactTextField: UILabel!
    @IBOutlet weak var contactNumber: UILabel!
    
    var isGettingLocation = false
    var isRinging = false
    let sunEmoji = "☀️"
    let moonEmoji = "🌙"
    let clockEmoji = "⏱"
    var avPlayer: AVAudioPlayer!
    
    //functions
    
    func getLocation(manager: CLLocationManager) -> CLLocationCoordinate2D {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        return locValue
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
            mainButton.backgroundColor = UIColor.white
            self.initLocation = self.getLocation(manager: locationManager)
        }
        
        if isGettingLocation {
            isGettingLocation = false
            mainButton.setAttributedTitle(NSAttributedString(string: sunEmoji), for: .normal)
            mainButton.backgroundColor = UIColor.yellow
            
        } else {
            isGettingLocation = true
            mainButton.setAttributedTitle(NSAttributedString(string: moonEmoji), for: .normal)
            mainButton.backgroundColor = UIColor.black
            self.initLocation = self.getLocation(manager: locationManager)
            _ = Timer.scheduledTimer(timeInterval: 5, target: self, selector: Selector("detectLocation"), userInfo: nil, repeats: true)
            
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
                isRinging = true
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    func getHelp(){
        
    }
    
    func detectLocation(){
        self.currentLocation = getLocation(manager: locationManager)
        
        let pointI = MKMapPointForCoordinate(initLocation)
        let pointC = MKMapPointForCoordinate(currentLocation)
        var distance : CLLocationDistance = MKMetersBetweenMapPoints(pointI, pointC)
        if distance.magnitude >= 7{
            
            wakeUp()
            
            
        }
    }
    
}
