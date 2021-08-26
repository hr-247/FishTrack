//
//  UpdateUserEmailViewModal.swift
//  TrackApp
//
//  Created by sanganan on 1/8/20.
//  Copyright © 2020 Sanganan. All rights reserved.
//

import Foundation
struct UpdateUserEmailViewModal
{
    var Success : Int?
    var Message : String?
    init(updateEmail : UpdateUserEmailModal) {
        self.Success = updateEmail.Success
        self.Message = updateEmail.Message
    }
}
