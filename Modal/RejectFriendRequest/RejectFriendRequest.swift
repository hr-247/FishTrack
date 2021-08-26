//
//  RejectFriendRequest.swift
//  TrackApp
//
//  Created by sanganan on 12/17/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//

import Foundation
struct RejectRequestModal : Decodable
{
    let Success : Int?
    let Message : String?
    
    enum CodingKey : String
    {
        case Success = "Success"
        case Message = "Message"
    }
}
