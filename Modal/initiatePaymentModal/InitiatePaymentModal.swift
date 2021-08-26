//
//  InitiatePaymentModal.swift
//  TrackApp
//
//  Created by sanganan on 1/8/20.
//  Copyright © 2020 Sanganan. All rights reserved.
//

import Foundation
struct InitiatePaymentModal: Decodable {
    var Success : Int?
    var Message : String?
    var paymentCraeted : PaymentCraetedModal?
    enum CodingKey : String
    {
        case Success = "success"
        case Message = "msg"
        case paymentCraeted = "payment created"
    }
}
struct PaymentCraetedModal  : Decodable {
    var paymentStatus : Int?
    var _id : String?
    enum CodingKey : String {
        case paymentStatus  = "status"
        case _id = "id"
    }
    }
