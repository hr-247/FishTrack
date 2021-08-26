//
//  TokenModal.swift
//  TrackApp
//
//  Created by shubham tyagi on 17/01/20.
//  Copyright © 2020 Sanganan. All rights reserved.
//

import UIKit

class TokenModal: Decodable {
    var Success :Int?
    var Message :String?
    enum CodingKeys: String, CodingKey {
        case Success = "userId"
        case Message = "Message"
    }

}


class DeletePerformanceModal: Decodable {
    var Success :Int?
    var Message :String?
    enum CodingKeys: String, CodingKey {
        case Success = "Success"
        case Message = "Message"
    }

}
