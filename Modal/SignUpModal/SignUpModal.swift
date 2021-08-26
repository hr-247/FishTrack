//
//  SignUpModal.swift
//  TrackApp
//
//  Created by sanganan on 11/25/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//

import UIKit
struct resultModal:Decodable{
    let Success:Int?
    var message: MessageModal?
    var deviceCreated : DeviceModal?
    var Message : String?
    init(Success:Int?,message: MessageModal?,deviceCreated : DeviceModal?,Message : String?)
    {
        self.Success = Success
        self.message = message
        self.deviceCreated =  deviceCreated
        self.Message = Message
    }
    enum CodinghKey: String {
        case Success = "success"
        case message = "mes"
        case deviceCreated = "device"
        case Message = "message"
    }
}
struct MessageModal : Decodable
{
    var Success:Int?
    var Message:String?
    var User:SignUpModal?
    
    init(Success:Int?,Message:String?,user:SignUpModal?)
    {
        self.Success = Success
        self.Message = Message
        self.User = user
    }
    enum CodingKey:String{
        case Success = "Success"
        case Message = "Message"
        case User = "User"
    }
}
struct SignUpModal: Decodable {
    var isactive:Bool?
    var _id:String?
    var userImage : String?
    var username:String?
    var email:String?
    var password:String?
    var createdTime:Int?
    var __v:Int?
    var location:locationModal?
    init(isactive:Bool?,_id:String?,userImage:String?,username:String?,email:String?,password:String?,createdTime:Int?,__v:Int?,location:locationModal?)
    {
        self.isactive = isactive
        self._id = _id
        self.userImage = userImage
        self.username = username
        self.email = email
        self.password = password
        self.createdTime = createdTime
        self.__v = __v
        self.location = location
    }
    enum CodingKey:String{
        case isactive = "a"
        case _id = "d"
        case username = "ty"
        case email = "e"
        case password  = "p"
        case createdTime = "c"
        case __v = "c45"
        case location = "ewerwe"
        
    }
}
struct locationModal: Decodable
{
    var type : String?
    var coordinates:[Double]?
    init(type:String?,coordinates:[Double]?){
        self.type = type
        self.coordinates = coordinates
    }
    enum CodingKey:String{
        case type = "a"
        case coordinates = "d"
    }
}
struct DeviceModal : Decodable
{
    let Success : String?
    var Device : DeviceTypeModal?
    init(Success : String?,Device : DeviceTypeModal?) {
        self.Success = Success
        self.Device = Device
    }
    enum  CodingKey: String {
        case Success = "success"
        case Device = "Device"
    }
}
struct DeviceTypeModal : Decodable
{
    let deviceType : Int?
    let deviceId : String?
    init(deviceType : Int?,deviceId : String?) {
        self.deviceType = deviceType
        self.deviceId = deviceId
    }
}
