//
//  GetAllFriendsModal.swift
//  TrackApp
//
//  Created by saurav sinha on 16/12/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//

import Foundation

struct GetAllFriendsModal: Decodable {
    
    let Success: Int?
    let All_Friends: [allFriendsModal]
    
    enum CodingKey: String {
        
        case Success = "success"
        case All_Friends = "all friends"
    }
}
struct allFriendsModal: Decodable {
    
    let friend : friendModal
    
    enum CodingKey: String {
        
        case friend = "friend"
    }
}

struct friendModal: Decodable {
    
    let _id : String?
    let username : String?
    let userImage : String?
    //email
    let email : String?
    enum Codingkey: String {
        
        case _id = "id"
        case username = "UserName"
        case userImage = "UserImage"
        case email = "email"
    }
    
}

