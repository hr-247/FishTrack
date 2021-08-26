//
//  dateWisePerfrmnceModal.swift
//  TrackApp
//
//  Created by saurav sinha on 24/12/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//

import Foundation

struct dateWisePerfrmnceModal : Decodable {
    
    let Success: Int?
    let Performance_Details: [performancelistModal]?
    
    enum CodingKeys: String, CodingKey {
        
        case Success = "Success"
        case Performance_Details = "PerformanceList"
    }
}

//{
//    "__v" = 0;
//    "_id" = 5f4143f5bc0612767333d055;
//    createdTime = 1598112757;
//    dateTime = 1598026320;
//    duration = 3;
//    experienceRating = 4;
//    fishName =             (
//                        {
//            "__v" = 0;
//            "_id" = 5e5ce67c560cbc2f00c9abc5;
//            createdTime = 1583146620;
//            fishName = Albacore;
//            isactive = 1;
//        },
//                        {
//            "__v" = 0;
//            "_id" = 5e5ce67c560cbc2f00c9abc8;
//            createdTime = 1583146620;
//            fishName = "Algae eater";
//            isactive = 1;
//        },
//                        {
//            "__v" = 0;
//            "_id" = 5e5ce67c560cbc2f00c9abca;
//            createdTime = 1583146620;
//            fishName = "Alligator gar";
//            isactive = 1;
//        }
//    );
//    fishingLicence = 4002;
//    location =             {
//        "__v" = 0;
//        "_id" = 5f4143e9bc0612767333d054;
//        createdTime = 1598112745;
//        location =                 {
//            coordinates =                     (
//                "28.58924084114499",
//                "77.39572195210489"
//            );
//            type = Points;
//        };
//        locationName = Noida;
//        place =                 (
//                                {
//                "__v" = 0;
//                "_id" = 5e5e0349517010308c9c7c17;
//                createdTime = 1583219529;
//                isactive = 1;
//                placeName = Ocean;
//            },
//                                {
//                "__v" = 0;
//                "_id" = 5e5e0356517010308c9c7c19;
//                createdTime = 1583219542;
//                isactive = 1;
//                placeName = Brook;
//            }
//        );
//    };
//    shareWithFriends = 1;
//    userId = 5f1ec391a8ca2f64c89c7889;
//}

struct performancelistModal : Decodable {
    
    let duration: Int
    let baitName: BaitModal?
    let fishName: [Fish]?
    let fishingLicence: Int?
    let experienceRating: Int?
    let shareWithFriends:Bool?
    let _id: String?
 //   let userId: userM?
    let userLocation: locModal?
    let fishWeight: FishWeightModal?
    let fishLength : FishLengthModal?
    let rodName: RodModal?
    let createdTime: QuantumValue
   // let createdTime: Int?

    let _v: Int?
    let performanceImage : String?
    let statusDescription : String?
    let waterDepth : WaterDepthModal?
    var lengthInString: String?
    var depthInString: String?
    var weightInString: String?

    //dateTime
    enum CodingKeys: String, CodingKey {
        case duration = "duration"
        case baitName = "baitName"
        case fishName = "fishName"
        case fishingLicence = "fishingLicence"
        case experienceRating = "experienceRating"
        case shareWithFriends = "shareWithFriends"
        case _id = "_id"
    //    case userId = "userId"
        case userLocation = "location"
        case fishWeight = "fishWeight"
        case rodName = "rodName"
        case createdTime = "dateTime"
        case _v = "_v"
        case performanceImage = "performanceImage"
        case statusDescription = "statusDescription"
        case waterDepth = "waterDepth"
        case fishLength = "fishLength"
        case lengthInString = "lengthInString"
        case depthInString = "depthInString"
        case weightInString = "weightInString"


    }
}


enum QuantumValue: Decodable {

    case float(Float), string(String), int(Int)

    init(from decoder: Decoder) throws {
        if let float = try? decoder.singleValueContainer().decode(Float.self) {
            self = .float(float)
            return
        }

        if let string = try? decoder.singleValueContainer().decode(String.self) {
            self = .string(string)
            return
        }
        if let int = try? decoder.singleValueContainer().decode(Int.self) {
                   self = .int(int)
                   return
               }

        throw QuantumError.missingValue
    }

    enum QuantumError:Error {
        case missingValue
    }
}

//enum ObjectValue: Decodable {
//
//    case userObj(userM), string(String)
//
//    init(from decoder: Decoder) throws {
//        if let obj = try? decoder.singleValueContainer().decode(userM.self) {
//            self = .userObj(obj)
//            return
//        }
//
//        if let str = try? decoder.singleValueContainer().decode(String.self) {
//            self = .string(str)
//            return
//        }
//        
//
//        throw ObjectError.missingValue
//    }
//
//    enum ObjectError:Error {
//        case missingValue
//    }
//}





struct userM : Decodable{
    var username:String?
    var _id: String?
    var userImage : String?
    
    enum CodingKeys: String, CodingKey {
          case username = "username"
          case _id = "_id"
          case userImage = "userImage"
    }
}

class ratem:Decodable{
    var rate:String
}
class asanaNameM:Decodable{
    var asanaName:String
}

class extraM:Decodable{
    var extraName:String
}
class satisfactionM :Decodable{
    var satisfaction : Int
}
struct partNameModal : Decodable {
    
    var name : String?
    
    enum CodingKey : String {
        case name = "name"
    }
}
struct locModal : Decodable
{
    var locationName : String?
    
    enum CodingKey  : String {
        case locationName = "locationName"
    }
}

