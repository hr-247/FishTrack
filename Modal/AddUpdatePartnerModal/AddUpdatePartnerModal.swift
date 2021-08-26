//
//  AddUpdatePartnerModal.swift
//  TrackApp
//
//  Created by saurav sinha on 10/12/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//

import Foundation

struct AddUpdatePartnerModal: Decodable {
    
    let Success: Int?
    let AllPartners: [allPartnersModal]?
    
    enum CodingKey: String {
        
        case Success = "success"
        case AllPartners = "all partners"
    }
    
}
struct allPartnersModal: Decodable {

    let _id: String?
    let gender: Int?
    let name: String?
    let relationShipStaus: String?
    let relationshipName: String?
    let partnerEmoji: String?

    enum CodingKey: String {

        case _id = "id"
        case gender = "gender"
        case name = "name"
        case relationShipStaus = "relationship status"
        case relationshipName = "relationshipName"
        case partnerEmoji = "partnerEmoji"

    }
}
