//
//  CreateFriendRequestViewModal.swift
//  TrackApp
//
//  Created by sanganan on 1/6/20.
//  Copyright © 2020 Sanganan. All rights reserved.
//

import Foundation
struct CreateFriendRequestViewModal {
    var Success : Int?
    var Message : String?
    init(createFriendReq : CreateFriendRequestModal) {
        self.Success = createFriendReq.Success!
        self.Message = createFriendReq.Message!
    }
}
