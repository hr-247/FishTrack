//
//  RelationModal.swift
//  TrackApp
//
//  Created by saurav sinha on 02/12/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//

import UIKit

struct  RelationViewModal {
    
    var id:String?
    var relationName: String?
    
    // D i
    init(relationModal:relationsModal)
    {
        self.id = relationModal._id
        self.relationName = relationModal.relationName
    }
    
}
