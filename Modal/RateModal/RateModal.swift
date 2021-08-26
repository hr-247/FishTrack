//
//  RateModal.swift
//  TrackApp
//
//  Created by sanganan on 11/26/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//

import Foundation
struct createRateModal:Decodable{
    var Success: Int
    var Rate : RateModal?
    
    init(Success:Int,Rate:RateModal) {
        self.Success = Success
        self.Rate = Rate
    }
    enum CodeKey: String{
        case Success = "success"
        case Rate = "rate"
    }
}
struct RateModal:Decodable {
    
    var rate : String?
    
    init(rate:String)
    {
        self.rate = rate

    }
    enum CodeKey: String{
        case rate = "rate"
    }

}
