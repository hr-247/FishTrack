//
//  FishTypeModal.swift
//  TrackApp
//
//  Created by Ankit  Jain on 20/02/20.
//  Copyright © 2020 Sanganan. All rights reserved.
//

import UIKit

struct FishTypeModal: Decodable {
    
    var Success : Int?
    var Fishes : [Fish]?
       
       enum CodingKey : String
       {
           case Success = "Success"
           case Fishes = "Fishes"
       }

}


struct Fish: Decodable {
    
 //   var isactive : Bool?
    var _id : String?
    var fishName : String?
//    var createdTime : Int?
//    var __v : Int?

       enum CodingKey : String
       {
  //      case isactive = "isactive"
        case _id = "_id"
        case fishName = "fishName"
//        case createdTime = "createdTime"
//        case __v = "__v"

       }

}
