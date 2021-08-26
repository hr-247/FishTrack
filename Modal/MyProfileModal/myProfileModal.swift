//
//  myProfileModal.swift
//  TrackApp
//
//  Created by sanganan on 1/16/20.
//  Copyright © 2020 Sanganan. All rights reserved.
//


//"payment": {
//           "_id": "5e30377b7da2830dc0676a3d",
//           "isactive": true,
//           "userId": "5e300785722c451f7cacd02c",
//           "endTime": 1582896635,
//           "startTime": 1580218235,
//           "createdTime": 1580218235,
//           "__v": 0
//       }
import Foundation
struct myProfileModal : Decodable {
    var Success : Int
    var isPremimum : Int
    var isBasic : Int

    var user : userDetailModal
    
    enum CodingKey : String {
        case Success = "Success"
        case isPremimum = "isPremimum"
        case isBasic = "isBasic"
        case user = "user"
      
    }
    
}
class payment : Decodable {
  
    var startTime : Int
    var endTime : Int
    enum CodingKey : String {
        case startTime = "startTime"
        case endTime = "endTime"
          
    }
    
}
struct userDetailModal : Decodable {
    var username : String?
    var email : String?
    var userImage : String?
    var referral : String?
    var paymentBasic: payment?
    var paymentPrem: payment?

    //referral
    enum CodingKey : String {
        case username = "username"
        case email = "email"
        case userImage = "userImage"
        case referral = "referral"
        case paymentBasic = "paymentBasic"
        case paymentPrem = "paymentPrem"

    }
}
