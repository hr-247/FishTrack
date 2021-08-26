//
//  AppUtils.swift
//  TrackApp
//
//  Created by sanganan on 11/21/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//

import UIKit
import Toaster


class AppUtils: NSObject {
    
    //MARK: appdelegate object
    static func AppDelegate() -> AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    
    static func goToPreviousPage(navigation:UINavigationController?,whichPage:AnyObject)
    {
        if let nav = navigation
        {
            let navigationArray = nav.viewControllers
            for (index,item) in (navigationArray.enumerated())
            {
                if item.isKind(of: whichPage as! AnyClass)
                {
                    navigation?.popToViewController((navigation?.viewControllers[index])!, animated: true)
                }
            }
        }
    }
    static func showToast(message : String)
    {
        let toast = Toast(text: message, delay: 0.1, duration: 1.5)
        toast.view.backgroundColor = UIColor.darkGray
        toast.view.font = UIFont.systemFont(ofSize: 14)
        toast.show()
        
        
    }
    
    static func isValidEmail(testStr:String) -> Bool {
        
        print("validate emilId: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
        
    }
    
    //    static func isValidPwd(testStr:String) -> Bool {
    //
    //        print("validate password: \(testStr)")
    //        let pwdRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*_])(?=.*\\d)\\S{8,}$"
    //        let pwdTest = NSPredicate(format: "SELF MATCHES %@", pwdRegEx)
    //        let result = pwdTest.evaluate(with: testStr)
    //        return result
    //
    //    }
    
    //    static func isValidUsername(testStr:String) -> Bool {
    //
    //           print("validate username: \(testStr)")
    //           let userRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)\\S{8,}$"
    //           let userTest = NSPredicate(format: "SELF MATCHES %@", userRegEx)
    //           let result = userTest.evaluate(with: testStr)
    //           return result
    //
    //       }
    static func heightOfStatAndNavibar(view:UIViewController) -> CGFloat{
        let str =  UIApplication.shared.statusBarFrame.height + (view.navigationController?.navigationBar.frame.height)!
        return str
    }
    static func getDataInLocal()-> NSDictionary{
        let defaultdata = UserDefaults.standard
        let dict = NSDictionary()
        
        return dict
    }
    static func getStringForKey(key : String) -> String?
    {
        let defaultdata = UserDefaults.standard
        
        if let val =  defaultdata.value(forKey: key) as? String
        {
            return val
        }
        
        return nil
    }
    static func setStringForKey(key : String,val:String)
    {
        let defaultdata = UserDefaults.standard
        
        defaultdata.set(val, forKey: key)
        defaultdata.synchronize()
        
    }
    static func stringToDictionary(_ strToJSON : String)-> NSDictionary!{
        print("JsonString:\(strToJSON)");
        let data = strToJSON.data(using: String.Encoding.utf8)
        
        var dict : NSDictionary!;
        do {
            
            // dict = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! Dictionary<String, AnyObject>
            dict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
            // print(dict)
            return dict;
            
        }
            
        catch let error as NSError {
            print("Error is:\(error)");
            
        }
        
        return dict;
        
    }
    static func timestampToDate(timeStamp : Double) -> String{
        let date = Date(timeIntervalSince1970: timeStamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local //Set timezone that you want
        //  dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "d MMM yyyy  hh:mm a" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    static func timestampToDate1(timeStamp : Double) -> String{
        let date = Date(timeIntervalSince1970: timeStamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local //Set timezone that you want
        //  dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "d MMM yyyy" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    static func dateToTimestamp(date : Int)->NSDate{
        let myTimeStamp = NSDate(timeIntervalSince1970: TimeInterval(date))
        return myTimeStamp
    }
    
    static func particularTimeInMiliseconds(Date:Date) -> Int {
        let nowDouble = Date.timeIntervalSince1970
        return( Int(nowDouble))
    }
    
    static func getParticularTimeFormat(format:String ,date:Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.dateFormat = format
        let strDate = dateFormatter.string(from: date)
        
        return String(describing: strDate)
    }
    
    enum purchase : String{
        case basic_monthly = "com.fishtrack.basicmonthly"
        case basic_yearly = "com.fishtrack.basicyearly"
        case premium_monthly = "com.fishtrack.newpremiummonthly"
        case premium_yearly = "com.fishtrack.newpremiumyearly"
    }
    
    enum Controllers {
        case home
        case walkThrough
        case withVC
        case locationVC
        case placesVC
        case positionsVC
        case statsVC
        case myFriendsVC
        case searchFriendsVC
        case loginVC
        case settingsVC
        case notificationVC
        case aboutVC
        case addYourPerfrmnceVC
        case forgetPwdVC
        case signUpVC
        case inviteFriendsVC
        case termsVC
        case performanceDetailsVC
        case updatePassVC
        case partnerVC
        case fishType
        case reactType
        case basic
        case comment
        
        func get()->UIViewController{
            switch self {
                
            case .home:
                return HomeViewController(nibName: "HomeViewController", bundle: nil)
                
            case .walkThrough:
                return WalkThroughViewController(nibName: "WalkThroughViewController", bundle: nil)
                
            case .withVC:
                return WithViewController(nibName: "WithViewController", bundle: nil)
                
            case .locationVC:
                return LocationViewController(nibName: "LocationViewController", bundle: nil)
                
            case .placesVC:
                return PlacesViewController(nibName: "PlacesViewController", bundle: nil)
                
            case .positionsVC:
                return PositionsViewController(nibName: "PositionsViewController", bundle: nil)
                
            case .statsVC:
                return StatsViewController(nibName: "StatsViewController", bundle: nil)
                
            case .myFriendsVC:
                return MyFriendsViewController(nibName: "MyFriendsViewController", bundle: nil)
                
            case .searchFriendsVC:
                return SearchFriendsViewController(nibName: "SearchFriendsViewController", bundle: nil)
                
            case .loginVC:
                return LoginViewController(nibName: "LoginViewController", bundle: nil)
                
            case .settingsVC:
                return SettingsViewController(nibName: "SettingsViewController", bundle: nil)
                
            case .notificationVC:
                return NotificationViewController(nibName: "NotificationViewController", bundle: nil)
                
            case .aboutVC:
                return AboutViewController(nibName: "AboutViewController", bundle: nil)
                
            case .addYourPerfrmnceVC:
                return AddYourPerformanceViewController(nibName: "AddYourPerformanceViewController", bundle: nil)
                
            case .forgetPwdVC:
                return ForgetPasswordViewController(nibName: "ForgetPasswordViewController", bundle: nil)
                
            case .signUpVC:
                return SignUpViewController(nibName: "SignUpViewController", bundle: nil)
                
            case .inviteFriendsVC:
                return InviteFriendsViewController(nibName: "InviteFriendsViewController", bundle: nil)
                
            case .termsVC:
                return TermsViewController(nibName: "TermsViewController", bundle: nil)
                
            case .performanceDetailsVC:
                return PerformanceDetailsViewController(nibName: "PerformanceDetailsViewController", bundle: nil)
                
            case .updatePassVC:
                return UpdatePasswordViewController(nibName: "UpdatePasswordViewController", bundle: nil)
                
            case .partnerVC:
                return PartnerViewController(nibName: "PartnerViewController", bundle: nil)
                
            case .fishType:
                return FishTypeViewController(nibName: "FishTypeViewController", bundle: nil)
                
            case .reactType:
                return ReactionsViewController(nibName: "ReactionsViewController", bundle: nil)
                
            case .basic:
                return BasicSubscriptionViewController(nibName: "BasicSubscriptionViewController", bundle: nil)
                
            case .comment:
                return AddCommentViewController(nibName: "AddCommentViewController", bundle: nil)
            }
        }
    }
    
    
}
