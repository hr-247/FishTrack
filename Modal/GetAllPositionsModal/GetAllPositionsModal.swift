//
//  GetAllPositionsModal.swift
//  TrackApp
//
//  Created by saurav sinha on 03/12/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//

import Foundation

struct GetAllPositionsModal: Decodable {

    let Success: Int?
    let Positions : [positionsModal]
    
    enum CodingKey:String {
        case Success =  "Success"
        case Positions = "positions"
        
    }
}

struct positionsModal: Codable {

    let _id: String?
    let positionName: String?
    let positionImage: String?
    init(id:String, posname:String, posimage:String)
    {

        self._id = id
        self.positionName = posname
        self.positionImage = posimage

    }
    enum CodingKeys:String, CodingKey {

        case _id = "_id"
        case positionName = "positionName"
        case positionImage = "positionImage"

    }

}
