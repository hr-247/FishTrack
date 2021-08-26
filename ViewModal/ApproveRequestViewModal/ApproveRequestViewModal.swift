//
//  ApproveRequestViewModal.swift
//  TrackApp
//
//  Created by sanganan on 1/6/20.
//  Copyright © 2020 Sanganan. All rights reserved.
//

import Foundation
struct ApproveFriendRequestViewModal {
    
    var Success: Int?
    var Friends: [approvefriendsModal]
    init(approveReq : ApproveFriendRequestModal) {
        self.Success = approveReq.Success
        self.Friends = approveReq.Friends
    }
  }

struct approvefriendsViewModal {

    var  userId: String?
    var friendUserId: String?
    var requestId: String?
    init(approveFriendsReq : approvefriendsModal) {
        self.userId = approveFriendsReq.userId
        self.friendUserId = approveFriendsReq.friendUserId
        self.requestId = approveFriendsReq.requestId
    }
    }

