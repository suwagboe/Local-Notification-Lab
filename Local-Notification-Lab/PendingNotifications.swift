//
//  PendingNotifications.swift
//  Local-Notification-Lab
//
//  Created by Pursuit on 2/20/20.
//  Copyright © 2020 Pursuit. All rights reserved.
//

import Foundation
import UserNotifications

class PendingNotifications{
    
      public func getPendingNotifications(completion: @escaping ([UNNotificationRequest]) ->()) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (request) in
            print("there are \(request.count) pending request.")
            completion(request)
            
        }
        
    }
    
}
