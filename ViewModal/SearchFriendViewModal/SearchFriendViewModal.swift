//
//  SearchFriendViewModal.swift
//  TrackApp
//
//  Created by sanganan on 1/6/20.
//  Copyright © 2020 Sanganan. All rights reserved.
//

import Foundation
struct SearchFriendViewModal
{
    let Success : Int?
    var Result : [FriendsDataModal?]
    init(SearchFriends : SearchFriendModal) {
        self.Success = SearchFriends.Success!
        self.Result = SearchFriends.Result
    }
}
struct FriendsDataViewModal
{
    var username : String?
    var _id : String?
    var userImage : String?
    var isFriend : MyFriendsDataModal?
    init(FriendsDatas : FriendsDataModal) {
        self.username = FriendsDatas.username!
        self.userImage = FriendsDatas.userImage!
        self._id = FriendsDatas._id!
        self.isFriend = FriendsDatas.isFriend
    }
}
struct MyFriendsDataViewModal
{
    var _id : String?
    var status : Int?
    var userId : String?
    var friendUserId : String?
    var requestId : String?
    init(MyFriendsDatas : MyFriendsDataModal) {
        self._id = MyFriendsDatas._id!
        self.status = MyFriendsDatas.status!
        self.userId = MyFriendsDatas.userId!
        self.friendUserId = MyFriendsDatas.friendUserId!
        self.requestId = MyFriendsDatas.requestId!
        
    }
}

