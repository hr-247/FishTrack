//
//  ForgetPasswordViewModal.swift
//  TrackApp
//
//  Created by sanganan on 1/28/20.
//  Copyright © 2020 Sanganan. All rights reserved.
//

import UIKit
struct ForgetPasswordViewModal : Decodable {
    var   Success : Int?
    var Message : String?
    var  mailStatus : statusModal?
    
    init(mStatus  : ForgetPasswordModal) {
        self.Success = mStatus.Success
        self.Message = mStatus.Message
        self.mailStatus = mStatus.mailStatus
    }
    
  
}

struct statusViewModal : Decodable
{
    var  Status : String?
    
    init(status : statusModal) {
        self.Status = status.Status
    }
}
