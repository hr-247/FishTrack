//
//  PositionsViewModal.swift
//  TrackApp
//
//  Created by saurav sinha on 03/12/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//

import UIKit

struct  PositionsViewModal {
    var id: String?
    var posName: String?
    var posImage: String?
    
    // D i
    init(positionModal:positionsModal)
    {
        self.id = positionModal._id
        self.posName = positionModal.positionName
        self.posImage = positionModal.positionImage
        
    }
    
}
