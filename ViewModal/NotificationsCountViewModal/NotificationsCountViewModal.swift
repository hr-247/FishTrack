//
//  File.swift
//  TrackApp
//
//  Created by sanganan on 12/24/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//

import Foundation
struct NotificationsCountViewModal {
    let count : Int?
    init(notifications : CountModal) {
        self.count = notifications.notifCount!
    }
}
       
   
