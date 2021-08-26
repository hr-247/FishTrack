//
//  LoginModal.swift
//  TrackApp
//
//  Created by sanganan on 11/25/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//
import UIKit

struct LoginModal: Decodable
{
let Message: String?
let Success: Int?
let token:String?
    let payload: payloadModel?
    enum CodingKey:String{
        case Message = "m"
        case Success = "s"
        case token =
        "token"
        case payload = "payloadModel"
    }
}

struct payloadModel: Decodable
{
    let username: String?
    let id: String?
    let email: String?
    
}
