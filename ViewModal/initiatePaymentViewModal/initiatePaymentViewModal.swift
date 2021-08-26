//
//  initiatePaymentViewModal.swift
//  TrackApp
//
//  Created by sanganan on 1/8/20.
//  Copyright © 2020 Sanganan. All rights reserved.
//

import Foundation
struct InitiatePaymentViewModal {
    var Success : Int?
    var Message : String?
    var paymentCraeted : PaymentCraetedModal?
    init(initiatePayment : InitiatePaymentModal) {
        self.Success = initiatePayment.Success
        self.Message = initiatePayment.Message
        self.paymentCraeted = initiatePayment.paymentCraeted
    }
}
struct PaymentCraetedViewModal{
    var paymentStatus : Int?
    var _id : String?
    init(paymentCreated : PaymentCraetedModal) {
        self.paymentStatus = paymentCreated.paymentStatus
        self._id = paymentCreated._id
    }
    }
    
