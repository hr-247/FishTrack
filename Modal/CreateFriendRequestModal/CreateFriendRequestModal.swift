//
//  CreateFriendRequestModal.swift
//  TrackApp
//
//  Created by saurav sinha on 16/12/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//

import Foundation

struct CreateFriendRequestModal: Decodable {
    
    let Success: Int?
    let Message: String?
    
    enum CodingKey: String {
        
        case Success = "success"
        case Message = "message"
    }
}

struct CreateResponseResult:Decodable{
    let friendReqCreated : CreateFriendRequestModal
}

