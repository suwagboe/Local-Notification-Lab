//
//  TimerDetailController.swift
//  Local-Notification-Lab
//
//  Created by Pursuit on 2/20/20.
//  Copyright © 2020 Pursuit. All rights reserved.
//

import UIKit

class TimerDetailController: UIViewController {

    //    var timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(UIMenuController.update), userInfo: nil, repeats: true)
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var practiceLabel: UILabel!
    
    var count = 10
    
    var blank: String?
    
     var timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(UIMenuController.update), userInfo: nil, repeats: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        update()

    }
    
    func update() {
    if(count > 0) {
        timerLabel.text = "\(count -= 1)"
        }
        
        guard let something = blank  else {
            print("the segue is not properly working")
            return
        }
        
        practiceLabel.text = something
}
    
    
}
