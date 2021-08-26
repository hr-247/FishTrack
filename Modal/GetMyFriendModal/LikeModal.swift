//
//  LikeModal.swift
//  TrackApp
//
//  Created by Ankit  Jain on 12/02/20.
//  Copyright © 2020 Sanganan. All rights reserved.
//

import Foundation


//musclelikes =             {
//    "__v" = 0;
//    "_id" = 5e43c18a1801140017b8d048;
//    createdTime = 1581498762;
//    isactive = 1;
//    likeType = 8001;
//    performance = 5e391c16862f90001709f24a;
//    userWhoLiked = 5e327bfcf9e2150017575435;
//};

struct  MuscleLikeModal :Decodable{
    var _id : String
    var likeType : Int?
    var isactive : Bool?
    var performance : String?
    var createdTime : Int?
    var __v : Int?
    var userWhoLiked : String?

    enum CodingKey : String
    {
        case _id = "_id"
        case likeType = "likeType"
        case isactive = "isactive"
        case performance = "performance"
        case createdTime = "createdTime"
        case __v = "__v"
        case userWhoLiked = "userWhoLiked"

    }
}

struct  ThumbLikeModal :Decodable{
    var _id : String
    var likeType : Int?
    var isactive : Bool?
    var performance : String?
    var createdTime : Int?
    var __v : Int?
    var userWhoLiked : String?


    enum CodingKeys : String,CodingKey
    {
        case _id = "_id"
        case likeType = "likeType"
        case isactive = "isactive"
        case performance = "performance"
        case createdTime = "createdTime"
        case __v = "__v"
        case userWhoLiked = "userWhoLiked"
   
    }
}




struct  MuscleLikeResponse :Decodable{
    var Success : Int?
    var LikeCreated : MuscleLikeModal
    enum CodingKeys : String,CodingKey
    {
        case Success = "Success"
        case LikeCreated = "LikeCreated"
    }
}

struct  ThumbLikeResponse :Decodable{
    var Success : Int?
    var LikeCreated : ThumbLikeModal
    enum CodingKeys : String,CodingKey
    {
        case Success = "Success"
        case LikeCreated = "LikeCreated"
    }
}

//{
//
//    "Success": 1,
//    "isactive": 0,
//    "LikeStatus": "Disliked"
//}

struct  ToggleStatusResponse :Decodable{
    var Success : Int?
    var LikeStatus : String?
    var isactive : Int?

    enum CodingKeys : String,CodingKey
    {
        case Success = "Success"
        case LikeStatus = "LikeStatus"
        case isactive = "isactive"

    }
}
