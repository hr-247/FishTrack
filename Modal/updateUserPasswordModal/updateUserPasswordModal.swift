//
//  updateUserPasswordModal.swift
//  TrackApp
//
//  Created by sanganan on 1/8/20.
//  Copyright © 2020 Sanganan. All rights reserved.
//

import Foundation
struct updateUserPasswordModal : Decodable {
    var Success : Int?
    var Message : String?
    enum CodingKey : String
    {
    case Success = "success"
    case Message = "msg"
    }
}
