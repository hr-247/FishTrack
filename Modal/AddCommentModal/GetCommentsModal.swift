//
//  GetCommentsModal.swift
//  TrackApp
//
//  Created by sanganan on 10/8/20.
//  Copyright © 2020 Sanganan. All rights reserved.
//

import UIKit
struct GetCommentsModal : Decodable {
    var Success : Int?
    var Comments : [CommentsModal]?
    
    enum CodingKey : String
    {
        case Success = "Success"
        case Comments = "Comments"
        
    }
}
struct CommentsModal : Decodable {
    var  user : UserInfoModal?
    var comment : String?
    var createdTime : Int?
    
    enum CodingKey : String
    {
        case user = "user"
        case comment = "comment"
        case createdTime = "createdTime"
        
    }
    
}
