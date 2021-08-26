//
//  updateUserUsernameViewModal.swift
//  TrackApp
//
//  Created by sanganan on 1/8/20.
//  Copyright © 2020 Sanganan. All rights reserved.
//

import Foundation
struct updateUserUsernameViewModal
{
    var Success : Int?
    var Message : String?
    init(updateUserN : updateUserUsernameModal) {
        self.Success = updateUserN.Success
        self.Message = updateUserN.Message
    }
}
