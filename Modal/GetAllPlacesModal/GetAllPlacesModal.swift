//
//  GetAllPlacesModal.swift
//  TrackApp
//
//  Created by saurav sinha on 02/12/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//

import Foundation

struct GetAllPlacesModal: Decodable {
    
    let Success: Int?
    let Places : [placesModal]
    
    enum CodingKey:String {
        case Success = "success"
        case Places = "places"
    }
    
}

struct placesModal: Decodable {
    
    let _id: String?
    let placeName: String?
    
    init(id:String,place:String?)
    {
        self._id = id
        if let plac = place
        {
        self.placeName = plac
        }else{
            self.placeName = "No place"
        }
    }
    enum CodingKey:String {
        
        case _id = "id"
        case placeName = "place name"
        
    }
    
}


