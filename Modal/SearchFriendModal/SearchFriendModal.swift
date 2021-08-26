//
//  SearchFriendModal.swift
//  TrackApp
//
//  Created by sanganan on 1/6/20.
//  Copyright © 2020 Sanganan. All rights reserved.
//

import Foundation
struct SearchFriendModal : Decodable
{
    var Success : Int?
    var Result : [FriendsDataModal?]
    init(success : Int?,result : [FriendsDataModal?]) {
        self.Success = success
        self.Result = result
    }
}
struct FriendsDataModal : Decodable
{
    var username : String?
    var _id : String?
    var email : String?
    var userImage : String?
    var isFriend : MyFriendsDataModal?
    var incomingFriendRequest : MyFriendsDataModal?
    var pendingFriendRequest : MyFriendsDataModal?
    init(username : String?, _id : String?, userImage : String?, isFriend : MyFriendsDataModal?) {
        self.username = username
        self._id = _id
        self.userImage = userImage
        self.isFriend = isFriend
//        self.incomingFriendRequest = incomingFriendRequest
//        self.email = em
    }
}
struct MyFriendsDataModal : Decodable
{
    var _id : String?
    var status : Int?
    var userId : String?
    var friendUserId : String?
    var requestId : String?
    init(_id : String?,status : Int?,userId : String?,friendUserId : String?,requestId : String?) {
        self._id = _id
        self.status = status
        self.userId = userId
        self.friendUserId = friendUserId
        self.requestId = requestId
    }
}
