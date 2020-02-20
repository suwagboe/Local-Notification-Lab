//
//  ViewController.swift
//  Local-Notification-Lab
//
//  Created by Pursuit on 2/20/20.
//  Copyright © 2020 Pursuit. All rights reserved.
//

import UIKit

class theListOfTimersController: UIViewController {
    // table view
    // make the call a subtitile cell
    
    // swiping left deletes the cell
    
    @IBOutlet weak var tableview: UITableView!
    
    // the array of timers
    private var timersList = [String](){
        didSet{
            // reload the table view when the value here gets updated.
        }
    }
    
    private let notificationCenterInstanceSingleton = UNUserNotificationCenter.current()
    // the one and only instance of notifications

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.dataSource = self
        
    }
    
    private func checkForNotificationAuthorization(){
        notificationCenterInstanceSingleton.getNotificationSettings { (settings) in
         
            if settings.authorizationStatus == .authorized {
                print("app is authorized for the usage of notifications")
            } else {
                    print("there was user does not want to use notifications")
                // I need self here because im inside of a closure.??
                self.requestNotificationsPermissions()
            }
        }
    }
    
    private func requestNotificationsPermissions(){
        
        notificationCenterInstanceSingleton.requestAuthorization(options: [.alert, .sound]) {
            (granted, error) in
            // the two outcomes of this completion are either you were granted access or there was an error
            if let error = error {
                print("the error is located on line 54 inside of the listOfTimersController the error is \(error)")
            }
            
            if granted {
                print("access was granted.")
            } else {
                print("access was denied.")
            }
            
        }
        
    }



}

//cell name : listCell

extension theListOfTimersController: UITableViewDataSource{
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return timersList.count
      }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableview.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)
              
              return cell
    }
 
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      
    }
}

