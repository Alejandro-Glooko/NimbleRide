//
//  RideViewController.swift
//  NimbleRide
//
//  Created by Nicholas Randhawa on 11/8/16.
//  Copyright © 2016 Alejandro Puente. All rights reserved.
//

import UIKit
import CoreLocation

class RideViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var altitudeLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var avgSpeedLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timerResetButton: UIButton!
    @IBOutlet weak var timerToggleButton: UIButton!
    @IBOutlet weak var calorieLabel: UILabel!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    
    var bikeTimer = Timer()
    var timerCount = 0, pointsTaken = 0.0, calories = 0.0
    var timerFlag = 0 //0 = paused, 1 = running
    var nextLocation:CLLocation!
    var previousLocation:CLLocation!
    var distance = 0.0, speed = 0.0, altitude = 0.0, totalDistance = 0.0, avgSpeed = 0.0, totalSpeed = 0.0, weight = 160
    
    func runTimer () {
        timerCount += 1
        timerLabel.text = String (format: "%02d:%02d:%02d", (timerCount/3600)%60, (timerCount/60)%60, timerCount%60)
    }
    
    @IBAction func timerToggleButton (_ send: AnyObject){
        if (timerFlag == 0){
            timerFlag = 1
            timerToggleButton.setTitle("Pause", for: .normal)
            bikeTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: NSSelectorFromString("runTimer"), userInfo: nil, repeats: true)
        }
        else {
            timerFlag = 0
            timerToggleButton.setTitle("Resume", for: .normal)
            bikeTimer.invalidate()
        }
    }
    
    @IBAction func timerResetButton (_ send: AnyObject){
        timerLabel.text = "00:00:00"
        timerCount = 0
        timerFlag = 0
        bikeTimer.invalidate()
        timerToggleButton.setTitle("Start", for: .normal)
    }
    
    func addCalorie (speed: Double, calorie: Double) -> Double {
        var count: Double
        switch speed {
        case 0..<10:    // speed < 10
            count = calorie + calcCalorie(MET: 4.0, weight: Double(weight))
        case 10..<12:   // speed 10 < x < 12
            count = calorie + calcCalorie(MET: 6.0, weight: Double(weight))
        case 12..<14:   // speed 12 < x < 14
            count = calorie + calcCalorie(MET: 8.0, weight: Double(weight))
        case 14..<16:   // speed 14 < x < 16
            count = calorie + calcCalorie(MET: 10.0, weight: Double(weight))
        case 16..<20:   // speed 16 < x < 20
            count = calorie + calcCalorie(MET: 12.0, weight: Double(weight))
        case 20..<100:     // speed 20 < x
            count = calorie + calcCalorie(MET: 16.0, weight: Double(weight))
        default:
            count = calorie
        }
        return count
    }
    
    func calcCalorie (MET: Double, weight: Double) -> Double {
        return MET * (weight * 0.45359237) * (1/3600) // calorie burn = MET * weight in kgs * time in hours
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        altitude = (locations.last!.altitude * 3.28084)
        altitudeLabel.text = String(format: "%.0f ft", altitude)
        speed = (locations.last!.speed * 2.23694)
        if (speed < 0){
            speed = 0
        }
        speedLabel.text = String(format: "%.2f mph", speed)

        if (timerToggleButton.title(for: .normal) == "Start"){ //timer has not started
            distance = 0
            totalSpeed = 0
            pointsTaken = 0
            avgSpeed = 0
            previousLocation = locations.last
        }

        else if (timerToggleButton.title(for: .normal) == "Pause"){ //timer is running
            nextLocation = locations.last
            pointsTaken += 1
            distance += nextLocation.distance(from: previousLocation)
            totalSpeed += nextLocation.speed
            avgSpeed = totalSpeed / pointsTaken
            if (avgSpeed < 0){
                avgSpeed = 0
            }
            previousLocation = nextLocation
            //calories = distance / 50
            calories = addCalorie(speed: speed, calorie: calories)
        }

        else { //timer is paused
            previousLocation = locations.last
        }

        totalDistance = distance * 0.000621371
        distanceLabel.text = String(format: "%.2f miles", totalDistance)
        avgSpeedLabel.text = String(format: "%.2f mph", avgSpeed * 2.23694)
        calorieLabel.text = String(format: "%.0f", calories)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error" + error.localizedDescription)
    }
}

