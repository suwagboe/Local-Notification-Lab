//
//  CreatingATimerController.swift
//  Local-Notification-Lab
//
//  Created by Pursuit on 2/20/20.
//  Copyright © 2020 Pursuit. All rights reserved.
//

import UIKit
import UserNotifications

protocol CreatingATimerControllerDelegate {
    func didTheTimerPickerChange(_ createATimeController: CreatingATimerController)
}

class CreatingATimerController: UIViewController {

    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var timerPicker: UIDatePicker!
    
    private var timeInterval: TimeInterval!
    
    private var delegate: CreatingATimerControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    private func createLocalNotificationForTheTimer(){
        
        let content = UNMutableNotificationContent()
        
        content.title = titleTextField.text ?? "Nothing was entered inside of the textField..."
        
        let identifier = UUID().uuidString
        
        if let imageURL = Bundle.main.url(forResource: "hourglass timer image", withExtension: "png") {
            print("you got a image")
            do{
                
              let attachment = try UNNotificationAttachment(identifier: identifier, url: imageURL, options: nil)
                content.attachments = [attachment] // you need [] because that is what it returns
            }catch {
                print("there is no attachment please come back and check inside of the create local notification")
                
                
            }
        } else{
            print("image cannot be found")
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
         
        UNUserNotificationCenter.current().add(request) { (error) in
            // once this runs it will get in the pending notification...
            if let error = error {
                print("error adding the request \(error)")
            } else {
                print("request was successfully added and clicked done. ")
            }
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.didTheTimerPickerChange(self)
        createLocalNotificationForTheTimer()
        dismiss(animated: true)
        
    }
    
    
    @IBAction func timerPickerChanged(_ sender: UIDatePicker){
  // want a delegate for when it changes because the change effects the other controller
    // this helps signal a change to be watched.
        
    guard sender.countDownDuration < 0 else { return }
        timeInterval = sender.countDownDuration
    }
    
}
