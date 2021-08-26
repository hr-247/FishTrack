//
//  UIVCExtension.swift
//  TrackApp
//
//  Created by saurav sinha on 24/12/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//

import UIKit
import BadgeSwift
import SafariServices

extension UIViewController {
    
    var whichControlller: String{
        get{
            return ""
        }
    }
    
    func removeVCFromStack(numberOFStack pos:Int){
        guard let navigationController = self.navigationController else { return }
        let navigationArray = navigationController.viewControllers // To get all UIViewController stack as Array
        //        print("navigationArray:",navigationArray.count)
        //        var arr:Array = navigationArray
        //        for (i,item)  in navigationArray.enumerated()
        //        {
        //             print("navigationArray:",arr.count,i)
        //            if (i < pos)
        //            {
        //                break
        //            }
        //            navigationController.viewControllers.remove(at: i)
        //        }
        //
        //        navigationArray = arr
        //        print("navigationArray:",navigationArray.count)
        //        self.navigationController?.viewControllers = navigationArray
        
        
        
        let lastVC = navigationArray.last
        self.navigationController?.viewControllers = [lastVC!]
        
    }
    
    func commonNavigationBar(title:String , controller:AppUtils.Controllers,badgeCount : String)
        
    {
        self.title = title.lowercased().capitalizingFirstLetter()
        navigationController?.navigationBar.barTintColor = Constant.Color.navColor
        // self.navigationController?.view.backgroundColor = Constant.Color.navColor
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 25)!]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        switch (controller){
            
        case .loginVC:
            self.navigationItem.setHidesBackButton(true, animated:true);
            
            
        case .home:
            
            let button = UIButton(type: .custom)
            button.setImage(UIImage (named: "notification.png"), for: .normal)
            button.addTarget(self, action: #selector(notifyButton), for: .touchUpInside)
     //       button.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
            
            button.widthAnchor.constraint(equalToConstant: 20).isActive = true
            button.heightAnchor.constraint(equalToConstant: 23).isActive = true
            
            let barButtonItem = UIBarButtonItem(customView: button)
            let badge = BadgeSwift(frame: CGRect(x: 10, y: -5, width: 18, height: 18))
            
            badge.font = UIFont(name: "Helvetica Neue", size: 13)
            badge.textColor = UIColor.black
            badge.textAlignment = .center
            badge.badgeColor = UIColor.white
            badge.layer.cornerRadius =  badge.frame.width/2
            badge.text = String(badgeCount)
            button.addSubview(badge)
            
            if Int(badgeCount)! > 0
            {
                badge.isHidden = false
            }else{
                badge.isHidden = true
            }
            
            let button2 = UIButton(type: .custom)
            button2.setImage(UIImage(named: "info-button.png"), for: .normal)
            button2.addTarget(self, action: #selector(infoButton), for: .touchUpInside)
            
     //       button2.frame = CGRect(x: 0.0, y: 0.0, width: 35, height: 35)
            button2.widthAnchor.constraint(equalToConstant: 22).isActive = true
            button2.heightAnchor.constraint(equalToConstant: 25).isActive = true
            
            let barButtonItem2 = UIBarButtonItem(customView: button2)
            self.navigationItem.rightBarButtonItems  = [barButtonItem,barButtonItem2]
            let button3 = UIButton(type: .custom)
            button3.setImage(UIImage(named: "settings"), for: .normal)
            button3.addTarget(self, action: #selector(settings), for: .touchUpInside)
            
    //        button3.frame = CGRect(x: 0.0, y: 0.0, width: 35, height: 35)
            button3.widthAnchor.constraint(equalToConstant: 25).isActive = true
            button3.heightAnchor.constraint(equalToConstant: 25).isActive = true
            
            let barButtonItem3 = UIBarButtonItem(customView: button3)
            self.navigationItem.leftBarButtonItem  = barButtonItem3
            
        case .addYourPerfrmnceVC:
            let button = UIButton(type: .custom)
            button.setImage(UIImage (named: "back.png"), for: .normal)
            button.addTarget(self, action: #selector(backButton), for: .touchUpInside)
         //   button.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
            button.widthAnchor.constraint(equalToConstant: 20).isActive = true
            button.heightAnchor.constraint(equalToConstant: 25).isActive = true
            
            let barButtonItem = UIBarButtonItem(customView: button)
            self.navigationItem.leftBarButtonItem  = barButtonItem
            navigationItem.leftBarButtonItem?.tintColor = .white
            
            self.navigationItem.rightBarButtonItem  = UIBarButtonItem(title: "OKKey".localized(), style: .plain, target: self, action: #selector(addTapped))
           
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
            
        case .fishType:
            let button = UIButton(type: .custom)
            button.setImage(UIImage (named: "back.png"), for: .normal)
            button.addTarget(self, action: #selector(backButton), for: .touchUpInside)
      //      button.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
            
            button.widthAnchor.constraint(equalToConstant: 20).isActive = true
            button.heightAnchor.constraint(equalToConstant: 25).isActive = true
            
            let barButtonItem = UIBarButtonItem(customView: button)
            self.navigationItem.leftBarButtonItem  = barButtonItem
            navigationItem.leftBarButtonItem?.tintColor = .white
            self.navigationItem.rightBarButtonItem  = UIBarButtonItem(title: "AddKey".localized(), style: .plain, target: self, action: #selector(addFishTapped))
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
            
        case .locationVC,.searchFriendsVC,.notificationVC,.settingsVC,.signUpVC,.termsVC,.forgetPwdVC,.aboutVC,.inviteFriendsVC, .partnerVC, .updatePassVC,.reactType, .performanceDetailsVC,.comment:
            let button = UIButton(type: .custom)
            button.setImage(UIImage (named: "back.png"), for: .normal)
            button.addTarget(self, action: #selector(backButton), for: .touchUpInside)
       //     button.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
            
            button.widthAnchor.constraint(equalToConstant: 20).isActive = true
            button.heightAnchor.constraint(equalToConstant: 25).isActive = true
            
            let barButtonItem = UIBarButtonItem(customView: button)
            self.navigationItem.leftBarButtonItem  = barButtonItem
            //            let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
            //            image.image = UIImage(named: "back")
            //            let button1 = UIBarButtonItem(image: image.image, style: .plain, target: self, action: #selector(backButton))
            //            self.navigationItem.leftBarButtonItem = button1
            self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
            

            
            
            
            
            
        case .placesVC:
            let button = UIButton(type: .custom)
            button.setImage(UIImage (named: "back.png"), for: .normal)
            button.addTarget(self, action: #selector(backButton), for: .touchUpInside)
          //  button.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
            
            button.widthAnchor.constraint(equalToConstant: 20).isActive = true
            button.heightAnchor.constraint(equalToConstant: 25).isActive = true
            
            let barButtonItem = UIBarButtonItem(customView: button)
            self.navigationItem.leftBarButtonItem  = barButtonItem
            self.navigationItem.leftBarButtonItem?.tintColor = .white
            let button2 = UIBarButtonItem(title: "OKKey".localized(), style: .plain, target: self, action: #selector(okButtonPlacesVC))
            self.navigationItem.rightBarButtonItem = button2
            self.navigationItem.rightBarButtonItem?.tintColor = .white
            
        case .withVC:
            let button = UIButton(type: .custom)
            button.setImage(UIImage (named: "back.png"), for: .normal)
            button.addTarget(self, action: #selector(backButton), for: .touchUpInside)
       //     button.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
            
            button.widthAnchor.constraint(equalToConstant: 20).isActive = true
            button.heightAnchor.constraint(equalToConstant: 25).isActive = true
            
            let barButtonItem = UIBarButtonItem(customView: button)
            self.navigationItem.leftBarButtonItem  = barButtonItem
            self.navigationItem.leftBarButtonItem?.tintColor = .white
            
            let button2 = UIBarButtonItem(title: "OKKey".localized(), style: .plain, target: self, action: #selector(okButtonWVC))
            self.navigationItem.rightBarButtonItem = button2
            self.navigationItem.rightBarButtonItem?.tintColor = .white
            
        case .positionsVC:
            let button = UIButton(type: .custom)
            button.setImage(UIImage (named: "back.png"), for: .normal)
            button.addTarget(self, action: #selector(backButton), for: .touchUpInside)
        //    button.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
            
            button.widthAnchor.constraint(equalToConstant: 20).isActive = true
            button.heightAnchor.constraint(equalToConstant: 25).isActive = true
            
            let barButtonItem = UIBarButtonItem(customView: button)
            self.navigationItem.leftBarButtonItem  = barButtonItem
            self.navigationItem.leftBarButtonItem?.tintColor = .white
            
            let button2 = UIBarButtonItem(title: "DoneKey".localized(), style: .plain, target: self, action: #selector(doneButtonPosVC))
            self.navigationItem.rightBarButtonItem = button2
            
            self.navigationItem.rightBarButtonItem?.tintColor = .white
            
        case .myFriendsVC:
            let button = UIButton(type: .custom)
            button.setImage(UIImage (named: "back.png"), for: .normal)
            button.addTarget(self, action: #selector(backButton), for: .touchUpInside)
        //    button.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
            
            button.widthAnchor.constraint(equalToConstant: 20).isActive = true
            button.heightAnchor.constraint(equalToConstant: 25).isActive = true
            
            let barButtonItem = UIBarButtonItem(customView: button)
            self.navigationItem.leftBarButtonItem  = barButtonItem
            navigationItem.leftBarButtonItem?.tintColor = .white
            
            let button2 = UIButton(type: .custom)
            button2.setImage(UIImage (named: "Search_120px.png"), for: .normal)
            button2.addTarget(self, action: #selector(searchFriends), for: .touchUpInside)
      //      button2.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
            
            button2.widthAnchor.constraint(equalToConstant: 23).isActive = true
            button2.heightAnchor.constraint(equalToConstant: 23).isActive = true
            
            let barButtonItem2 = UIBarButtonItem(customView: button2)
            self.navigationItem.rightBarButtonItem = barButtonItem2
            navigationItem.rightBarButtonItem?.tintColor = .white
            
            
            
            
            
        case .statsVC: break
            
            
            //        case .performanceDetailsVC:
            //            let button = UIButton(type: .custom)
            //            button.setImage(UIImage (named: "notification.png"), for: .normal)
            //            button.addTarget(self, action: #selector(notifyPDButton), for: .touchUpInside)
            //            button.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
            //            let barButtonItem = UIBarButtonItem(customView: button)
            //            let badge = BadgeSwift(frame: CGRect(x: 16, y: -3, width: 25, height: 25))
            //
            //            badge.font = UIFont(name: "Helvetica Neue", size: 13)
            //            badge.textColor = UIColor.black
            //            badge.textAlignment = .center
            //            badge.badgeColor = UIColor.white
            //            badge.layer.cornerRadius =  badge.frame.width/2
            //            badge.text = String(badgeCount)
            //          //  button.addSubview(badge)
            //
            //            let button2 = UIButton(type: .custom)
            //            button2.setImage(UIImage(named: "info-button.png"), for: .normal)
            //            button2.addTarget(self, action: #selector(infoPDButton), for: .touchUpInside)
            //
            //            button2.frame = CGRect(x: 0.0, y: 0.0, width: 35, height: 35)
            //
            //            let barButtonItem2 = UIBarButtonItem(customView: button2)
            //            self.navigationItem.rightBarButtonItems  = [barButtonItem,barButtonItem2]
            //            let button3 = UIButton(type: .custom)
            //            button3.setImage(UIImage(named: "back"), for: .normal)
            //            button3.addTarget(self, action: #selector(back), for: .touchUpInside)
            //            let barButtonItem3 = UIBarButtonItem(customView: button3)
            //            self.navigationItem.leftBarButtonItem  = barButtonItem3
            
            
        default:
            let button2 = UIButton(type: .custom)
            button2.setImage(UIImage(named: "info-button.png"), for: .normal)
            button2.addTarget(self, action: #selector(infoButton), for: .touchUpInside)
            
       //     button2.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
            button2.widthAnchor.constraint(equalToConstant: 20).isActive = true
            button2.heightAnchor.constraint(equalToConstant: 25).isActive = true
            let barButtonItem2 = UIBarButtonItem(customView: button2)
            self.navigationItem.rightBarButtonItems  = [barButtonItem2]
        }
    }
    @objc private func infoPDButton()
    {
        
    }
    @objc private func notifyPDButton()
    {
        
    }
    @objc private func back()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK:- HomeVC
    @objc private func settings()
    {
        let vc = AppUtils.Controllers.settingsVC.get() as! SettingsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func notifyButton()
    {
        let vc = AppUtils.Controllers.notificationVC.get() as! NotificationViewController
        self.navigationController?.pushViewController(vc, animated: true)
        return
    }
    @objc private func infoButton()
    {
        let vc = AppUtils.Controllers.aboutVC.get() as! AboutViewController
        self.navigationController?.pushViewController(vc, animated: true)
        //        if let url = URL(string: "http://fishtrackapp.com/faq") {
        //            let config = SFSafariViewController.Configuration()
        //            config.entersReaderIfAvailable = true
        //
        //            let vc = SFSafariViewController(url: url, configuration: config)
        //            vc.preferredBarTintColor = Constant.Color.navColor
        //            vc.preferredControlTintColor = .white
        //            present(vc, animated: true)
        //        }
    }
    
    // MARK:- Common Back Button(pop)
    @objc private func backButton()
    {
       // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "BackButton"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK:- AddPerformanceVC
    @objc func addTapped()
    {
        //  NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AddButton"), object: nil)
    }
    
    // MARK:- AddFishType
    @objc func addFishTapped()
    {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AddFish"), object: nil)
    }
    
    //MARK:- ALERT METHOD
    
    
    //completion:@escaping ((T?,Error?) -> Void)
    func alert(title : String , message : String,tag : String,completion:@escaping ((_ text:String) -> Void)) {
        var data : String = String()
        _ = ""
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "SAVEKey".localized(), style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("Added")
            let whiteSpace = ((alertController.textFields![0].text!) ).trimmingCharacters(in: .whitespaces)
            if whiteSpace.count != 0 {
                data = whiteSpace
            }
            
            completion(data)
        }
        
        let cancelAction = UIAlertAction(title: "CancelKey".localized(), style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancelled")
            
        }
        
        alertController.addTextField { (textField:UITextField) -> Void in
            textField.keyboardType = .alphabet
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK:- SearchFriendsVC
    @objc func searchFriends()
    {
        let vc = AppUtils.Controllers.searchFriendsVC.get() as! SearchFriendsViewController
        self.navigationController?.pushViewController(vc, animated: true)
        return
    }
    
    //MARK:- PlacesVC
    @objc func okButtonPlacesVC(){
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OKButtonLoca"), object: nil)
    }
    
    // MARK:- WithVC
    @objc func okButtonWVC()
    {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OKButtonWithVC"), object: nil)
    }
    
    //MARK:- PositionVC
    @objc func doneButtonPosVC()
    {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DoneButtonPosVC"), object: nil)
    }
    
    @objc func unfriendActn()
    {
        
    }
    // MARK:- Email validation
       func isValidEmail(testStr:String) -> Bool {
           
           let emailRegEx = "^[a-zA-Z][A-Z0-9a-z._%+-]+@[A-Za-z0-9-]+\\.[A-Za-z]{2,4}$"
         //  let trimmedString = testStr.trimmingCharacters(in: .whitespaces)
           let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
           let result = emailTest.evaluate(with: testStr)
           return result
           
       }
    
    func isValidUsrName(testStr:String) -> Bool {
        
        guard testStr.count > 2, testStr.count < 18 else { return false }

        let predicateTest = NSPredicate(format: "SELF MATCHES %@", "^(?=\\S{6})[a-zA-Z]\\w*(?:\\.\\w+)*(?:@\\w+\\.\\w{2,4})?$")
        return predicateTest.evaluate(with: testStr)
    }
    
    
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
