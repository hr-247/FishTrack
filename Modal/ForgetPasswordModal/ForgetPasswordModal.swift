//
//  ForgetPasswordModal.swift
//  TrackApp
//
//  Created by sanganan on 1/28/20.
//  Copyright © 2020 Sanganan. All rights reserved.
//

import UIKit
struct ForgetPasswordModal : Decodable {
    var   Success : Int?
    var Message : String?
    var  mailStatus : statusModal?
    
    enum CodingKey : String
    {
        case Success = "Success"
        case Message = "Message"
        case mailStatus = "mailStatus"
    }
}

struct statusModal : Decodable
{
    var  Status : String?
    
    enum CodingKey : String
    {
        case Status = "Status"
    }
}
