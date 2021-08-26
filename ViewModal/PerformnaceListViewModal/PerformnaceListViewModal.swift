//
//  PerformnaceListViewModal.swift
//  TrackApp
//
//  Created by saurav sinha on 24/12/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//

import UIKit

//struct PerformnaceListViewModal {
//
//    var dur: Int?
//    var addpartner: [partNameModal?]
//    var pos: [positionsModal?]
//    var satisrating: Int?
//    var exprating: Int?
//    var sharewithfriends:Bool?
//    var id: String?
//    var userid: String?
//    var loc: locModal?
//    var rte: String?
//    var asananame: String?
//    var exta: String?
//    var satisfcton: String?
//    var cretdtime: Int?
//
//    init(perfrmncelist:performancelistModal)
//    {
//        self.dur = perfrmncelist.duration
//        self.addpartner = perfrmncelist.userPartner!
//        self.pos = perfrmncelist.positions
//        self.satisrating = perfrmncelist.satisfactionRating
//        self.exprating = perfrmncelist.experienceRating
//        self.sharewithfriends = perfrmncelist.shareWithFriends
//        self.id = perfrmncelist._id
//        self.userid = perfrmncelist.userId?._id
//        self.loc = perfrmncelist.userLocation
//        self.rte = perfrmncelist.rate?.rate
//        self.asananame = perfrmncelist.asanaName?.asanaName
//        self.exta = perfrmncelist.extra?.extraName
//        self.satisfcton = "\(perfrmncelist.satisfaction?.satisfaction)"
//        self.cretdtime = perfrmncelist.createdTime
//    }
//}
struct locViewModal {
    var locName  : String?
    init(loc : locModal) {
        self.locName = loc.locationName
    }
}
