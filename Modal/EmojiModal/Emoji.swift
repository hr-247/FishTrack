//
//  Emoji.swift
//  TrackApp
//
//  Created by Ankit  Jain on 12/02/20.
//  Copyright © 2020 Sanganan. All rights reserved.
//

import Foundation
struct PartnerResponseModal : Decodable {
    var Success : Int?
    var Emojis : [Emoji]?
    
    enum CodingKey : String
    {
        case Success = "Success"
        case Emojis = "Emojis"
    }
}

struct Emoji : Decodable {
    var _id : String?
    var emojiUrl : String?
    var createdTime : Int?
    var __v : Int?
    
    enum CodingKey : String
    {
        case _id = "_id"
        case emojiUrl = "emojiUrl"
        case createdTime = "createdTime"
        case __v = "__v"

    }
    
}
