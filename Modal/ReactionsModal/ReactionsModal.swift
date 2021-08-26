//
//  ReactionsModal.swift
//  TrackApp
//
//  Created by sanganan on 3/17/20.
//  Copyright © 2020 Sanganan. All rights reserved.
//

import Foundation
struct ReactionsModal : Decodable {
   var  Success : Int?
    var   Message : String?
      var  AllLikes : [allLykData]?
    var MuscleLikes : [musLykData]?
    var ThumbLikes : [okLykData]?
    
    init(suc : Int,mess : String,allLyk : [allLykData] ,musLyk : [musLykData],okLyk : [okLykData]) {
        self.Success = suc
        self.Message = mess
        self.AllLikes = allLyk
        self.MuscleLikes = musLyk
        self.ThumbLikes = okLyk
    }
           
}
struct allLykData : Decodable {
    
  var  username: String?
   var  userImage: String?
    var likeType : Int?
    init(uName : String,uImage : String,lykTyp : Int) {
        self.username = uName
        self.userImage = uImage
        self.likeType = lykTyp
    }
}
struct musLykData : Decodable {
    
  var  username: String?
   var  userImage: String?
    var  likeType: Int?

    init(uName : String,uImage : String) {
        self.username = uName
        self.userImage = uImage
        self.likeType = 8001
    }
}
struct okLykData : Decodable {
    
  var  username: String?
   var  userImage: String?
    var  likeType: Int?

    init(uName : String,uImage : String) {
        self.username = uName
        self.userImage = uImage
        self.likeType = 8002
    }
}
