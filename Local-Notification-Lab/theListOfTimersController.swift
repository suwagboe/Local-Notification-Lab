//
//  ViewController.swift
//  Local-Notification-Lab
//
//  Created by Pursuit on 2/20/20.
//  Copyright © 2020 Pursuit. All rights reserved.
//

import UIKit
import UserNotifications

class theListOfTimersController: UIViewController {
    // table view
    // make the call a subtitile cell
    
    // swiping left deletes the cell
    
    @IBOutlet weak var tableview: UITableView!
    
    private var instanceOfPendingNotification = PendingNotifications()
    
    // the array of timers
    private var timersList = [UNNotificationRequest](){
        didSet{
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
        }
    }
    
    private let notificationCenterInstanceSingleton = UNUserNotificationCenter.current()
    // the one and only instance of notifications
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkForNotificationAuthorization()
        tableview.dataSource = self
        // why do I need the singleton delegate????
        notificationCenterInstanceSingleton.delegate = self
    }
    
    // only gain access to the delegate if we do the prepare for segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // because it is embedded in a nav controller I need to unwrapp it.
        if segue.identifier == "TimerDetailController" {
        guard let timerDC = segue.destination as? TimerDetailController else { fatalError("check inside of the prepare for segue function...") }
        
        timerDC.blank = "So it is working"
        } else if segue.identifier == "CreatingATimerController"{
            guard let navController = segue.destination as? UINavigationController, let createController = navController.viewControllers.first as? CreatingATimerController else {
                 fatalError("couldnt load create controller")
        }
            createController.delegate = self
        }
    }
    
    private lazy var createController: CreatingATimerController = {
        // getting the instance from storyboard
        // tells navcontroller get me the first view controller to get the instance
        guard let createController = storyboard?.instantiateViewController(identifier: "CreatingATimerController") as? CreatingATimerController else {
            fatalError("couldnt load nav controller")
        }
        // set dataPersistence property
        return createController
    }()
    
    @objc private func loadNotification(){
        instanceOfPendingNotification.getPendingNotifications { (requests) in
            // we are querying the class that has a function that has a completion that returns the amount of requests that were called in the table view.
            self.timersList = requests
            // stop the refresh controller from animating
            // remove from the UI
            DispatchQueue.main.async {
             //   self.refreshControl.endRefreshing()
            }
        }
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

extension theListOfTimersController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)
        
        let specific = timersList[indexPath.row]
        
        cell.textLabel?.text = specific.content.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      
        if editingStyle == .delete {
            removeTimer(atIndexPath: indexPath)
        }
        
    }
    
    private func removeTimer(atIndexPath indexPath: IndexPath){
        let timerList = timersList[indexPath.row] // this gives the function a notification
     
        let stringIdentifier =  timerList.identifier
                       
               // remove notification from UNNNotification Center
        notificationCenterInstanceSingleton.removePendingNotificationRequests(withIdentifiers: [stringIdentifier])
               
               // remove from array of notifications
               // calling the array and removing it from the notificationS array from above
               timersList.remove(at: indexPath.row)
               
               // remove from tableView
               tableview.deleteRows(at: [indexPath], with: .automatic)
    }
    
    
    
}

extension theListOfTimersController: UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
         
         completionHandler(.alert)
         
     }
}

extension theListOfTimersController: CreatingATimerControllerDelegate {
    func didTheTimerPickerChange(_ createATimeController: CreatingATimerController) {
        loadNotification()
    }
}
