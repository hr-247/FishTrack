//
//  updateUserUsernameModal.swift
//  TrackApp
//
//  Created by sanganan on 1/8/20.
//  Copyright © 2020 Sanganan. All rights reserved.
//

import Foundation
struct updateUserUsernameModal : Codable {
    var Success : Int?
    var Message : String?
    enum CodingKeys : String, CodingKey
    {
       case Success = "Success"
           case Message = "Message"
    }
}
