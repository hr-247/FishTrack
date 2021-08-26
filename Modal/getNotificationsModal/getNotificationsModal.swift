//
//  getNotificationsModal.swift
//  TrackApp
//
//  Created by saurav sinha on 23/12/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//

import Foundation

struct getNotificationsModal: Decodable {
    
    let success: Int?
    let Message: String?
    let Notifications: [notificationsModal]
    
    enum CodingKey: String {
        case success = "success"
        case Message = "message"
        case Notifications = "notifications"
    }
    
}
struct notificationsModal: Decodable {
    
    let notificationType: Int?
    let userId: String?
    let createdTime: Int?
    var friendReqAcceptedId : friendAcceptedReqModal?
    var friendRequestId: friendrequestidModal?
    var performanceId : performanceIdModal?
    var userWhoCommented : userWhoCommentedModal?
    
    enum CodingKey: String {
        case notificationType = "notification type"
        case userId = "userid"
        case friendReqAcceptedId = "req accepted notification"
        case friendRequestId = "friendrequestid"
        case performanceId = "performanceIdMOdel"
        case createdTime = "createdTime"
        case userWhoCommented = "userWhoCommented"

    }
    
}
struct friendAcceptedReqModal : Decodable {
    var status : Int?
    var _id :  String?
    var userId : frndReqAccUserModal?
   
    enum CodingKey : String {
        case status = "status"
        case _id = "_id"
        case userId = "userId"
          }
}
struct frndReqAccUserModal : Decodable {
    var userImage : String?
    var  username : String?
    var  _id : String?

    enum CodingKey : String {
        case userImage = "userImage"
        case username = "username"
        case _id = "_id"

    }
}
struct friendrequestidModal: Decodable {
    
    let status: Int?
    var _id : String?
    let userWhoSentRequest: userwhosentreqModal?
    
    enum CodingKey: String {
        case status = "status"
        case _id = "id"
        case userWhoSentRequest = "sender"
    }
    
}

struct performanceIdModal: Decodable{
    
    let userId:userwhosentreqModal?
    let _id:String?

    enum CodingKey: String {
        
        case userId = "user id"
        case _id = "_id"

    }
}

struct userwhosentreqModal: Decodable {
    let _id:String?
    let username: String?
    let userImage: String?
    
    enum CodingKey: String {
        case username = "username"
        case userImage = "userimage"
        case _id = "_id"
    }
    
}
struct userWhoCommentedModal : Decodable
{
    let _id:String?
    let username: String?
    let userImage: String?
    
}
