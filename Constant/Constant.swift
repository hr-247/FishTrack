//
//  Constant.swift
//  TrackApp
//
//  Created by saurav sinha on 20/11/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//

import UIKit

class Constant: NSObject {
    #if Development
    //http://3.127.68.12:3000    http://api.fishtrackapp.com/
//    static let basicApi:String            = "http://3.127.68.12:3000"
    static let basicApi:String            = "http://api.fishtrackapp.com"
   // static let basicApi:String            = "https://fish-track-app.herokuapp.com"
    static let sandboxUrl:String          = "https://sandbox.itunes.apple.com/verifyReceipt"
    #else
//    static let basicApi:String            = "http://3.127.68.12:3000"
    static let basicApi:String            = "http://api.fishtrackapp.com"
   // static let basicApi:String            = "https://fish-track-app.herokuapp.com"
    static let sandboxUrl:String          = "https://sandbox.itunes.apple.com/verifyReceipt"
    // static let sandboxUrl:String          = "https://buy.itunes.apple.com/verifyReceipt"
    #endif
    //MARK:UserDefault data
    static let isPaid : String = String()
    static let email :String                = "email"
    static let id :String                   = "id"
    static let userImage : String          = "userimage"
    static let username :String             = "username"
    static let latitude : String            = "latitude"
    static let longitude : String           = "longitude"
    static let walkthrough :String         = "walkthrough_flag"
    static let isPaymentDone :String       = "isPaymentDone"
    static let referralCode :String        = "referralCode"
    static let subscriptionENd :String     = "subscriptionENd"
    static let bucketName :String           = "trackapp1"
    //MARK: withClassConstant
    
    static let addPartnerStatus: String   = "YouhadadddedmaxpartnerKey".localized()
    static let noPartnerAdded: String     = "NoFriendtheretoadd/UpdateKey".localized()
    static let withValidation: String     = "FillalldetailsKey".localized()
    static let partnerDeletd: String      = "PartnerDeletedKey".localized()
    
    //MARK: ServicesConstant
    
    static let offlineMsg: String         = "YouseemsofflineKey".localized()
    
    //MARK: Color Codes
    struct Color{
        static let buttonColor : UIColor = UIColor(red: 166/255 , green: 242/255, blue: 69/255, alpha: 1)
        static let backGroundColor:UIColor = UIColor(red: 35/255 , green: 187/255, blue: 218/255, alpha: 1)
        static let navColor : UIColor = UIColor(red: 5/255, green: 20/255, blue: 43/255, alpha: 1)
        static let gradientBackGroundColor:UIColor = UIColor(red: 107/255 , green: 83/255, blue: 37/255, alpha: 1)
        
        static let gradientBackGroundColor2:UIColor = UIColor(red: 50/255 , green: 40/255, blue: 20/255, alpha: 1)
        static let gradientBackGroundColor3:UIColor = UIColor(red: 33/255 , green: 33/255, blue: 33/255, alpha: 1)
    }
    
    
    static let addAllDetails: String      = "PleaseaddAllDetailsKey".localized()
    static let mandatoryDetailsKey: String      = "MandatoryDetailsKey".localized()
    static let succesAddPerfrmnce: String = "SuccessfullyPerformanceAddedKey".localized()
    static let failAddPerfrmnce:String    = "PleaseenteralldatafirstKey".localized()
    
    //MARK: Login Constant
    
    static let emailPwdErr: String        = "PleasefillemailandpasswordKey".localized()
    
    //MARK: Login Constant
    
    static let noPlacesSelectd: String    = "PleaseSelectAtleastOnePlaceKey".localized()
    
    //MARK: Signup Constant
    
    static let invalidEmail: String       = "invalidemailKey".localized()
    static let unmatchPwd: String         = "PasswordsarenotmatchingKey".localized()
    static let untickCheckbox: String     = "PleasetickcheckboxKey".localized()
    static let fillAllDetails: String?    = "PleasefillalldetailsKey".localized()
    
}
