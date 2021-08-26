//
//  RejectRequestViewModal.swift
//  TrackApp
//
//  Created by sanganan on 1/6/20.
//  Copyright © 2020 Sanganan. All rights reserved.
//

import Foundation
struct RejectRequestViewModal {
    var Success : Int?
    var Message : String?
    init(rejectRequest : RejectRequestModal) {
        self.Success = rejectRequest.Success
        self.Message = rejectRequest.Message
    }
}
