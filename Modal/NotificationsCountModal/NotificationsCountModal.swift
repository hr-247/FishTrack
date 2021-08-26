//
//  File.swift
//  TrackApp
//
//  Created by sanganan on 12/24/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//

import Foundation
struct NotificationsCountModal : Decodable{
    var myNotificationsCount : CountModal?
    enum CodingKey : String {
        case myNotificationsCount = "count"
    }
    }

struct CountModal : Decodable{
  var  notifCount : Int?
    enum CodingKey : String {
        case notifCount = "Count"
    }
    }

