//
//  GetUserStatsViewModal.swift
//  TrackApp
//
//  Created by saurav sinha on 03/12/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//
import UIKit

struct  GetUserStatsViewModal {
    var avgduration: Int
    var avgexperience: Double
    var toppositions: [String]
    var mnthperformance: monthwiseModal
    
    //    var perfrmncelist : [performancelistModal]
    //    var cretdtime : [String] = []
    
    // D i
    init(statsmodal:GetUserStatsModal)
    {
        if  let str = statsmodal.AverageDuration
        {
//            self.avgduration = String(describing: Int(ceil(str)))
            self.avgduration = Int(str)

        }else{
//            self.avgduration = "0"
            self.avgduration = 0
        }
        if let avgExp =  statsmodal.AverageExperience
        {
            self.avgexperience = avgExp
        }
        else
        {
            self.avgexperience = 0.0
        }
        if let  topPos   = statsmodal.TopPositions
        {
            self.toppositions = topPos
        }
        else
        {
            self.toppositions = []
        }
        self.mnthperformance =  monthwiseModal.init(nov: statsmodal.MonthwisePerformance?.Nov, dec: statsmodal.MonthwisePerformance?.Dec, jan: statsmodal.MonthwisePerformance?.Jan, feb: statsmodal.MonthwisePerformance?.Feb, mar: statsmodal.MonthwisePerformance?.Mar, apr: statsmodal.MonthwisePerformance?.Apr, may: statsmodal.MonthwisePerformance?.May, jun: statsmodal.MonthwisePerformance?.Jun, jul: statsmodal.MonthwisePerformance?.Jul, aug: statsmodal.MonthwisePerformance?.Aug, sep: statsmodal.MonthwisePerformance?.Sep, oct: statsmodal.MonthwisePerformance?.Oct)
    }
    
    func AverageMonth() -> String{
        
        let res:Int = (((mnthperformance.Nov!) + (mnthperformance.Dec!) + (mnthperformance.Jan!) + (mnthperformance.Feb!) + (mnthperformance.Mar!) + (mnthperformance.Apr!) + (mnthperformance.May!) + (mnthperformance.Jun!) + (mnthperformance.Jul!) + (mnthperformance.Aug!) + (mnthperformance.Sep!) + (mnthperformance.Oct!)))
        let time = String(describing: Int(ceil(Float(res/12))))
        
        return time
        
    }
}


struct  GetUserStatsViewModal1 {
    var perfrmncelist : [performancelistModal]
    var cretdtime : [String] = []
    var dur : [String] = []
    init(perfrmncelistmodal:dateWisePerfrmnceModal) {
        
        if let str  = perfrmncelistmodal.Performance_Details
        {
            self.perfrmncelist = str
        }else{
            self.perfrmncelist = []
        }
        for item in perfrmncelistmodal.Performance_Details!
        {
            
            switch item.createdTime {
                case .string(let text):
                    print(text)
                    self.cretdtime.append(AppUtils.timestampToDate(timeStamp: Double(text)!  ))

                case .float(let num):
                    print(num)
                
                self.cretdtime.append(AppUtils.timestampToDate(timeStamp: Double(num)  ))

                
                case .int(let inte):
                    self.cretdtime.append(AppUtils.timestampToDate(timeStamp: Double(inte)  ))

                     print(inte)
            }
            
            self.dur.append("\(item.duration)")
        }
    //    print( self.cretdtime, "time")
        
    }
}
