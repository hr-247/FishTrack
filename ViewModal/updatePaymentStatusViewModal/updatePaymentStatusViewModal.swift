//
//  updatePaymentStatusViewModal.swift
//  TrackApp
//
//  Created by sanganan on 1/8/20.
//  Copyright © 2020 Sanganan. All rights reserved.
//

import Foundation
struct UpdatePaymentStatusViewModal
{
    var Success : Int?
    var Message : String?
    init(paymentStatus : UpdatePaymentStatusModal) {
        self.Success = paymentStatus.Success
        self.Message = paymentStatus.Message
    }
}
