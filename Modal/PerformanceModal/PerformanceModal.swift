//
//  File.swift
//  TrackApp
//
//  Created by sanganan on 11/29/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//
import Foundation
struct performanceResultModal: Decodable{
    var performanceCreated:PerformanceModal
}
struct PerformanceModal : Decodable
{
    var Success : Int?
    var Message : String?
   // var Performance_Record : Performance_RecordModal?
    init(Success:Int?,Message:String) {
        self.Success = Success
        self.Message = Message
      //  self.Performance_Record = Performance_Record
    }
    enum codingkey : String
    {
        case Message = "message"
    }
}
struct Performance_RecordModal : Decodable
{
    var duration : Int?
    var addPartner : [String]?
    var positions : [String]?
    var satisfactionRating : Int?
    var experienceRating : Int?
    var shareWithFriends  : Bool?
    var _id : String?
    var userId : String?
    var dateTime : Int?
    var location : String?
    var rate : String?
    var asanaName : String?
    var extra : String?
    var satisfaction : String?
    
    init(duration:Int,addPartner:[String],positions:[String],satisfactionRating: Int,experienceRating:Int,shareWithFriends: Bool,_id:String,userId:String,dateTime : Int,location:String,rate : String,asanaName:String,extra:String,satisfaction:String)
    {
        self.duration = duration
        self.addPartner = addPartner
        self.positions = positions
        self.satisfactionRating = satisfactionRating
        self.experienceRating = experienceRating
        self.shareWithFriends = shareWithFriends
        self._id = _id
        self.userId = userId
        self.dateTime = dateTime
        self.location = location
        self.rate = rate
        self.asanaName = asanaName
        self.extra = extra
        self.satisfaction = satisfaction
    }
    enum CodingKey:String
    {
        case userId = "userId"
        case dateTime = "dateTime"
        case location = "location"
        case rate = "rate"
        case asanaName = "assaname"
        case extra  = "extra"
        case satisfaction = "satisfaction"
    }
}
