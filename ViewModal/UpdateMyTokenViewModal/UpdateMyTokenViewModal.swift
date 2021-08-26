//
//  UpdateMyTokenViewModal.swift
//  TrackApp
//
//  Created by sanganan on 1/8/20.
//  Copyright © 2020 Sanganan. All rights reserved.
//

import Foundation
struct UpdateMyTokenViewModal : Decodable
{
    var Success : Int?
    var Message : String?
    init(updateToken : UpdateMyTokenModal) {
        self.Success = updateToken.Success
        self.Message = updateToken.Message
    }
}


