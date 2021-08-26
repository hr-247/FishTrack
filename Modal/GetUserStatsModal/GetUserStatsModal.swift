//
//  GetUserStatsModal.swift
//  TrackApp
//
//  Created by saurav sinha on 03/12/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//

import Foundation


struct User_StatsModal:Decodable {
    
    let Success:String?
    let User_Stats:GetUserStatsModal?
    
    enum CodingKey: String {
        case User_Stats = "User_Stats"
        case Success = "sucess"
    }
}

struct GetUserStatsModal: Decodable {
    let AverageDuration: Double?
    let AverageExperience: Double?
    let TopPositions: [String]?
    let MonthwisePerformance: monthwiseModal?
    
    init(avgduration:Int?,avgexp:Int?,toppos:[String],monthwise:monthwiseModal) {
       
        self.AverageDuration = Double(avgduration!)
        self.AverageExperience = Double(avgexp!)
        self.TopPositions = toppos
        self.MonthwisePerformance = monthwise
    }
    
    
    enum CodingKey: String {
        case AverageDuration = "average duration"
        case AverageExperience = "average experience"
        case TopPositions = "top positions"
        case MonthwisePerformance = "monthwise Performance"
    }
    
}

struct monthwiseModal: Decodable {
    var Nov : Int? = 0
    var Dec : Int? = 0
    var Jan : Int? = 0
    var Feb : Int? = 0
    var Mar : Int? = 0
    var Apr : Int? = 0
    var May : Int? = 0
    var Jun : Int? = 0
    var Jul : Int? = 0
    var Aug : Int? = 0
    var Sep : Int? = 0
    var Oct : Int? = 0
    
    init(nov:Int?, dec:Int?, jan:Int?, feb:Int?, mar:Int?, apr:Int?, may:Int?, jun:Int?, jul:Int?, aug:Int?, sep:Int?, oct:Int? ) {
        if let n = nov
        {
            self.Nov = n
        }
        
        if let d = dec
        {
            self.Dec = d
        }
        
        if let ja = jan
        {
            self.Jan = ja
        }
       
        if let f = feb
        {
            self.Feb = f
        }
      
        if let mr = mar
        {
            self.Mar = mr
        }
        
        if let a = apr
        {
            self.Apr = a
        }
        
        if let my = may
        {
            self.May = my
        }
        
        if let jn = jun
        {
            self.Jun = jn
        }
        
        if let jl = jul
        {
            self.Jul = jl
        }
       
        if let a = aug
        {
            self.Aug = a
        }
       
        if let s = sep
        {
            self.Sep = s
        }
        
        if let o = oct
        {
            self.Oct = o
        }
        
    }
    
    enum CodingKey: String {
        
        case Nov = "nov"
        case Dec = "dec"
        case Jan = "jan"
        case Feb = "feb"
        case Mar = "mar"
        case Apr = "apr"
        case May = "may"
        case Jun = "jun"
        case Jul = "jul"
        case Aug = "aug"
        case Sep = "sep"
        case Oct = "oct"
        
    }
}

