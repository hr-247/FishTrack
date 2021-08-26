//
//  notificationsViewModal.swift
//  TrackApp
//
//  Created by saurav sinha on 23/12/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//

import UIKit

struct notificationsViewModal {
    
    var uname: String?
    var uimg: String?
    
    init(notifiModal: userwhosentreqModal) {
        
        self.uname = notifiModal.username
        self.uimg = notifiModal.userImage
    }
    
   
}
