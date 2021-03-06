//
//  SettingsViewController.swift
//  NimbleRide
//
//  Created by Alejandro Puente on 4/2/17.
//  Copyright © 2017 Alejandro Puente. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let settings = ["Go Premium", "Units of Measurement", "Help", "Manage Accounts", "My Music", "Terms of Service", "Logout"]
    var myIndex = 0
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return(settings.count)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let settingsCell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsViewControllerViewCell
        settingsCell.settingsLabel.text = settings[indexPath.row]
        settingsCell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        return (settingsCell)
        
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        myIndex = indexPath.row
        debugPrint("SettingsViewController \(myIndex)")
        if(myIndex == 0){
            performSegue(withIdentifier: "Premium", sender: self)
        } else if (myIndex == 1) {
            performSegue(withIdentifier: "Units", sender: self)
        } else if (myIndex == 2) {
            performSegue(withIdentifier: "Help", sender: self)
        } else if (myIndex == 3) {
            performSegue(withIdentifier: "Manage", sender: self)
        } else if (myIndex == 4) {
            performSegue(withIdentifier: "Music", sender: self)
        } else if (myIndex == 5) {
            performSegue(withIdentifier: "TOS", sender: self)
        } else if (myIndex == 6) {
            performSegue(withIdentifier: "Logout", sender: self)
        }
    
    }



    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
