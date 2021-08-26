//
//  updateUserPasswordViewModal.swift
//  TrackApp
//
//  Created by sanganan on 1/8/20.
//  Copyright © 2020 Sanganan. All rights reserved.
//

import Foundation
struct updateUserPasswordViewModal {
    var Success : Int?
    var Message : String?
    init(updatePass : updateUserPasswordModal) {
        self.Success = updatePass.Success
        self.Message = updatePass.Message
    }
}
