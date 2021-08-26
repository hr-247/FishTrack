//
//  GetAllRelationsModal.swift
//  TrackApp
//
//  Created by saurav sinha on 02/12/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//

import Foundation

struct GetAllRelationsModal: Decodable {

    let Success: Int?
    let Relations : [relationsModal]
    
    enum CodingKey:String {
        case Success = "success"
        case Relations = "relations"
    }

    
}

struct relationsModal: Decodable {

    let _id: String?
    let relationName: String?
    init(id:String,relation:String)
    {
        self._id = id
        self.relationName = relation
    }
    enum CodingKey:String {

        case _id = "id"
        case relationName = "partner name"

    }

}
