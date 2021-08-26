//
//  ApproveFriendRequestModal.swift
//  TrackApp
//
//  Created by saurav sinha on 16/12/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//

import Foundation

struct ApproveFriendRequestModal: Decodable {
    
    var Success: Int?
    var Friends: [approvefriendsModal]
    
    enum CodingKey: String {
        case Success = "success"
        case Friends = "friends"
    }
}

struct approvefriendsModal : Decodable {

    var  userId: String?
    var friendUserId: String?
    var requestId: String?
    
    enum CodingKey: String {
        case  userId = "userid"
        case friendUserId = "frenduserid"
        case requestId = "requestid"
    }
}
