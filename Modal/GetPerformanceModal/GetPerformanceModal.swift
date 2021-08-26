//
//  GetRateModal.swift
//  TrackApp
//
//  Created by sanganan on 12/2/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//

import Foundation
struct  getPerformanceModal:Decodable
{
    var Success : Int
    var Baits : [BaitModal]
    var FishLengths : [FishLengthModal]
    var FishWeights : [FishWeightModal]
    var Rods : [RodModal]
    var WaterDepths : [WaterDepthModal]

    enum CodingKey:String{
        case Success = "Success"
        case Baits = "Baits"
        case FishLengths = "FishLengths"
        case FishWeights = "FishWeights"
        case Rods = "Rods"
        case WaterDepths = "WaterDepths"

    }
    
}
struct BaitModal:Decodable
{
    var _id : String?
    var baitName : String?

    enum CodingKey:String{
        case _id = "_id"
        case baitName = "baitName"
    }
}
struct FishLengthModal : Decodable
{
    var _id : String?
    var fishLength : String?
  
    enum CodingKey:String{
        case _id = "id"
        case fishLength = "fishLength"
    }
}
struct FishWeightModal : Decodable
{
    var _id : String?
    var fishWeight : String?
  
    enum Codingkey: String
    {
        case _id = "id"
        case fishWeight = "fishWeight"
    }
}
struct RodModal : Decodable
{
    var _id : String?
    var  rodName : String?
  //  var satisfactionName : Int?
  
    enum CodingKey:String
  {
        case _id = "id"
        case rodName = "rodName"
        //case satisfactionName = "satisfactionName"
    }
}
struct WaterDepthModal : Decodable
{
    var _id : String?
    var waterDepth : String?
  
    enum Codingkey: String
    {
        case _id = "id"
        case waterDepth = "waterDepth"
    }
}
