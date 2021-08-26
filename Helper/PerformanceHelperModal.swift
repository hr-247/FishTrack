//
//  PerformanceHelperModal.swift
//  TrackApp
//
//  Created by shubham tyagi on 12/12/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//

import UIKit



//{
//    "userId":"5e4b89fb8dff6424f42fd9a1",
//    "statusDescription":"This is my 4nd performance",
//    "performanceImage":"https://images.unsplash.com/photo-1506126613408-eca07ce68773?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
//    "dateTime":"1578400611",
//    "duration":"150",
//    "fishName":["5e4b979310ddb907f85b8ceb","5e4b979310ddb907f85b8cea","5e4b979310ddb907f85b8ce9"],
//    "location":"5e4b9acdf1acd22614b23d38",
//    "fishLength":"5e4a86f4eb6a3331386d8e16",
//    "fishWeight":"5e4a870e95317610e49df335",
//    "baitName":"5e4a67be17619608a42c16b2",
//    "rodName":"5e4a789c8416034310414709",
//    "waterDepth":"5e4a7b6f65187c1a78012631",
//    "fishingLicence":4002,
//    "experienceRating":5,
//    "shareWithFriends" :1
//}



struct PerformanceHelperModal {
    var userId : String = ""
    //    var partnerData:[allPartnersModal] = []
    var positionData:[positionsModal] = []
    var place:[placesModal] = []
    var time:String = ""
    
    var duration:String = ""
    
    
    // new fields
    var status:String = ""
    var statusImage :String = ""
    var fishNames = [""]
    var fishIDs = [""]
    var lengthName :String = ""
    var lengthID :String = ""
    var wgtName :String = ""
    var wgtID :String = ""
    var baitName :String = ""
    var baitId :String = ""
    var rodName :String = ""
    var rodId :String = ""
    var waterDepName :String = ""
    var waterDepID :String = ""
    var licenseName :String = ""
    var licenseID :String = ""
    
    
    
    var newPlaceName: String = ""
    var locName:String = ""
    var loca : String = ""
    
    var location : String = ""
    
    //    var rate:String = ""
    //    var asanas:String = ""
    //    var extra:String = ""
    //    var satisfaction = ""
    //    var satisfationRate = ""
    var experienceRate = ""
    var shareFriend = ""
    var dateTimeStamp:String?
    //    var rateID:String = ""
    //    var asanaID:String = ""
    //    var extraID:String = ""
    //    var satisID:String = ""
    init(userID:String,place:[placesModal],time:String,duration:String,experienceRate:String,ShareFrnd:String,dateTimeStamp:Int,status : String,statusImage : String, fishName : [String], fishID : [String],length : String,lengthId : String,wgt : String,wgtId : String,baith : String,baithId : String,rod : String,rodId : String,waterDep : String,waterDepId : String,license : String,licenseId : String)
    {
        self.userId = userID
        self.duration = duration
        self.experienceRate = experienceRate
        self.place = place
        self.time = time
        self.shareFriend = ShareFrnd
        
        self.status = status
        self.statusImage = statusImage
        self.fishNames = fishName
        self.fishIDs = fishID
        self.lengthName  = length
        self.lengthID  = lengthId
        self.wgtName  = wgt
        self.wgtID  = wgtId
        self.baitName  = baith
        self.baitId  = baithId
        self.rodName  = rod
        self.rodId  = rodId
        self.waterDepName  = waterDep
        self.waterDepID = waterDepId
        self.licenseName  = license
        self.licenseID  = licenseId
        
        
        
        
    }
    //dateTimeStamp
    init()
    {
        self.userId = AppUtils.AppDelegate().userId
        //        self.asanas = ""
        self.duration = ""
        self.experienceRate = "0"
        //        self.partnerData = []
        self.positionData = []
        self.place = []
        self.time = "DateTimeKey".localized()
        //        self.rate = "Rate"
        //        self.extra = ""
        self.shareFriend = "0"
        //        self.satisfaction = ""
        //        self.satisfationRate = "0"
        self.dateTimeStamp = String(NSDate().timeIntervalSince1970)
        status = ""
        statusImage  = ""
        fishNames = [String]()
        fishIDs = [String]()
        lengthName  = ""
        lengthID  = ""
        wgtName  = ""
        wgtID  = ""
        baitName  = ""
        baitId  = ""
        rodName  = ""
        rodId  = ""
        waterDepName  = ""
        waterDepID  = ""
        licenseName  = ""
        licenseID  = ""
        location = ""
        
        
        
        //        self.rateID = "5dcbebcf84756f0fd87dc377"
        //        self.asanaID = "5dcbed581e37e34024093ce2"
        //        self.extraID = "5dcbed581e37e34024093ce2"
        //        self.satisID = "5dcbed581e37e34024093ce2"
    }
    
}

struct locationHelperModal: Decodable{
    var Success:Int?
    var Location:loc?
    
    enum CodingKey:String{
        case Success = "sample"
        case Location = "id"
    }
}
struct loc: Decodable{
    var _id:String?
    enum CodingKey:String{
        case _id = "id"
    }
}

