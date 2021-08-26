//
//  MyFriendViewModal.swift
//  TrackApp
//
//  Created by sanganan on 12/5/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//
import Foundation
struct FriendInfoViewModal{
    var user : UserInfoModal?
    var id : String?
    var createdTime : Int?
    var duration : Int?
    
    
    var baitName: BaitModal?
    var fishName: [Fish]?
    var fishingLicence: Int?
    var fishWeight: FishWeightModal?
    var fishLength : FishLengthModal?
    var rodName: RodModal?
    var performanceImage : String?
    var statusDescription : String?
    var shareWithFriends : Bool?
    var waterDepth : WaterDepthModal?
    var location : String?
    
    
    var muscleLikes : MuscleLikeModal?
    var thumbLikes : ThumbLikeModal?
    var thumblikeCount : Int = 0
    var  musclelikeCount : Int = 0
    var commentCount : Int? = 0
    
    var rate : Double?
    var  isCommented : [isCommentedModal]?
    
    
    init(FriendsInfoModal:FriendInfoModal)
    {
        if let loc = FriendsInfoModal.userLocation?.locationName
        {
            self.location = loc
        }
         self.user = FriendsInfoModal.user
        self.id = FriendsInfoModal._id!
        self.createdTime = FriendsInfoModal.createdTime!
        self.duration = FriendsInfoModal.duration
        
        self.baitName = FriendsInfoModal.baitName
        self.fishName = FriendsInfoModal.fishName
        self.fishWeight =  FriendsInfoModal.fishWeight
        self.fishLength =  FriendsInfoModal.fishLength
        self.rodName =  FriendsInfoModal.rodName
        self.performanceImage =  FriendsInfoModal.performanceImage
        self.shareWithFriends =  FriendsInfoModal.shareWithFriends
        self.statusDescription =  FriendsInfoModal.statusDescription
        self.waterDepth =  FriendsInfoModal.waterDepth
        self.isCommented = FriendsInfoModal.isCommented
        self.muscleLikes = FriendsInfoModal.musclelikes
        self.thumbLikes = FriendsInfoModal.thumblikes
        
        if let thumb = FriendsInfoModal.thumblikeCount
        {
            self.thumblikeCount = thumb
        }
        if let muscle = FriendsInfoModal.musclelikeCount
        {
            self.musclelikeCount = muscle
        }
        if let comment = FriendsInfoModal.commentCount
        {
            self.commentCount = comment
        }
        
        if let rate = FriendsInfoModal.experienceRating
        {
            self.rate = rate
        }
        else
        {
            self.rate = nil
        }
        
    }
}
struct  UserInfoViewModal{
    var id : String?
    var username : String?
    var location : LocationInfoModal?
    var userImage : String?
    init(UsersInfoModal:UserInfoModal) {
        self.id = UsersInfoModal._id
         if UsersInfoModal.username != nil
         {
            self.username = UsersInfoModal.username
        }
        else
         {
            self.username = "No username"
        }
        self.location = UsersInfoModal.location!
        self.userImage = UsersInfoModal.userImage!
    }
}
struct PartnerInfoViewModal:Decodable
{
    var id : String?
    init(PartnersInfoModal:PartnerInfoModal) {
        self.id = PartnersInfoModal._id!
    }
}
struct LocationInfoViewModal
{
    var type : String?
       var coordinates : [String]?
    init(LocationsInfoModal:LocationInfoModal) {
        if let locationName = LocationsInfoModal.type{
            self.type = locationName
        }
        else{
            self.type = "No Type"
        }
       if let coordinatesName = LocationsInfoModal.coordinates
       {
          self.coordinates = coordinatesName
        }
       else{
        self.coordinates = ["No Coordinates"]
        }
    }
}
struct PositionInfoViewModal
{
   var _id : String?
    var positionImage : String?
    init(PositionsInfoModal:PositionInfoModal) {
        self._id = PositionsInfoModal._id!
        self.positionImage = PositionsInfoModal.positionImage!
    }
}
