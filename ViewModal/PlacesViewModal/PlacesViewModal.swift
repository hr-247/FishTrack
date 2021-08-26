//
//  PlacesViewModal.swift
//  TrackApp
//
//  Created by saurav sinha on 02/12/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//

import UIKit

struct  PlacesViewModal {
    var id : String?
    var placeName : String?
    
    // D i
    init(placeModal : placesModal)
    {
        self.id = placeModal._id
        if let plac = placeModal.placeName
        {
        self.placeName = plac
        }else{
            self.placeName = "No place"
        }
    }
    
}

