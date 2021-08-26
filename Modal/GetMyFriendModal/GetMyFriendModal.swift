//
//  GetMyFriendModal.swift
//  TrackApp
//
//  Created by sanganan on 12/4/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//

import Foundation
struct MyFriendModal:Decodable
{
    var Success : Int?
    var Friend_Timeline : [FriendInfoModal]?
    var Details : FriendInfoModal?
    init(Success : Int,Friend_Timeline : [FriendInfoModal])
    {
        self.Success = Success
        self.Friend_Timeline = Friend_Timeline
        enum CodingKey : String
        {
            case Friend_Timeline = "Friend_Timeline"
            case Success = "Success"
            case Details = "Details"
        }
        
        //        enum CodingKeys : String,CodingKey
        //        {
        //            case Friend_Timeline = "Friend_Timeline"
        //            case Success
        //        }
    }
    
}



//struct performancelistModal : Decodable {
//

//
//    //dateTime
//    enum CodingKeys: String, CodingKey {
//        case duration = "duration"
//        case baitName = "baitName"
//        case fishName = "fishName"
//        case fishingLicence = "fishingLicence"
//        case experienceRating = "experienceRating"
//        case shareWithFriends = "shareWithFriends"
//        case _id = "_id"
//        case userId = "userId"
//        case userLocation = "location"
//        case fishWeight = "fishWeight"
//        case rodName = "rodName"
//        case createdTime = "dateTime"
//        case _v = "_v"
//        case performanceImage = "performanceImage"
//        case statusDescription = "statusDescription"
//        case waterDepth = "waterDepth"
//        case fishLength = "fishLength"
//
//
//    }
//}

struct FriendInfoModal: Decodable{
    var user : UserInfoModal?
    var _id : String?
    var createdTime : Int?
    var duration : Int?
    var userLocation: locModal?
    
    let baitName: BaitModal?
    let fishName: [Fish]?
    let fishingLicence: Int?
    let fishWeight: FishWeightModal?
    let fishLength : FishLengthModal?
    let rodName: RodModal?
    let performanceImage : String?
    let statusDescription : String?
    let waterDepth : WaterDepthModal?
    
    var shareWithFriends : Bool?
    var experienceRating : Double?
    var musclelikes : MuscleLikeModal?
    var thumblikes : ThumbLikeModal?
    var thumblikeCount : Int? = 0
    var musclelikeCount : Int? = 0
    var commentCount : Int? = 0
    var isCommented :  [isCommentedModal]
    
    
    
    enum CodingKeys: String, CodingKey {
        
        case userLocation = "location"
        case user = "user"
        case _id = "_id"
        case createdTime = "createdTime"
        case duration = "duration"
        case baitName =  "baitName"
        case fishName =  "fishName"
        case fishingLicence =  "fishingLicence"
        case fishWeight = "fishWeight"
        case fishLength =  "fishLength"
        case rodName =  "rodName"
        case performanceImage =  "performanceImage"
        case statusDescription = "statusDescription"
        case waterDepth = "waterDepth"
        case shareWithFriends = "shareWithFriends"
        case experienceRating = "experienceRating"
        case musclelikes = "musclelikes"
        case thumblikes = "thumblikes"
        case thumblikeCount = "thumblikeCount"
        case musclelikeCount = "musclelikeCount"
        case commentCount = "commentCount"
        case isCommented = "isCommented"
        
    }
    
}


//{
//               "_id": "5e427a01bd825b29584c59c3",
//               "likeType": 8001,
//               "isactive": true,
//               "userWhoLiked": "5e327b97f9e2150017575434",
//               "performance": "5e3806134195330017106985",
//               "createdTime": 1581414913,
//               "__v": 0
//           }




struct  UserInfoModal: Decodable{
    var _id : String?
    var username : String?
    var location : LocationInfoModal?
    var userImage : String?
    init(_id : String,username : String,location : LocationInfoModal,userImage : String) {
        self._id = _id
        self.username = username
        self.location = location
        self.userImage = userImage
    }
    enum CodingKeys : String,CodingKey
    {
        case _id = "_id"
        case username = "username"
        case location = "location"
        case userImage = "userImage"
    }
}
struct PartnerInfoModal:Decodable
{
    var _id : String?
    init(_id : String) {
        self._id = _id
    }
    enum CodingKey : String
    {
        case _id = "_id"
    }
}
struct LocationInfoModal:Decodable
{
    var type : String?
    var coordinates : [String]?
    init(type : String,coordinates : [String]) {
        self.type = type
        self.coordinates = coordinates
    }
    enum CodingKey : String{
        case type = "type"
        case coordinates = "coordinates"
    }
}
struct PositionInfoModal : Decodable
{
    var _id : String?
    var positionImage : String?
    init(_id : String, positionImage : String) {
        self._id = _id
        self.positionImage = positionImage
    }
    enum  codingKey : String {
        case _id = "id"
        case positionImage = "positions"
    }
}

struct isCommentedModal : Decodable
{
    var _id : String?
//       var comment : String?
//       var performance : String?
//       var user : String?
    
    enum CodingKey : String{
        case _id = "_id"
//        case comment = "comment"
//        case performance = "performance"
//        case user = "user"
    }
}
