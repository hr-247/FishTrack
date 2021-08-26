//
//  InviteFriendsViewController.swift
//  TrackApp
//
//  Created by sanganan on 11/7/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//

import UIKit


class InviteFriendsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.refralLblOutlet.text = AppUtils.getStringForKey(key: Constant.referralCode)
        self.commonNavigationBar(title: "InviteFriendsKey".localized(), controller: AppUtils.Controllers.inviteFriendsVC, badgeCount: "0")
    //    self.view.backgroundColor = Constant.Color.backGroundColor

        self.txtlabel()
        self.txtButton()
    }
    
    func txtlabel()
    {
        let textLbl1 = UILabel(frame: CGRect(x: 20, y: (UIScreen.main.bounds.height/2)-30, width: UIScreen.main.bounds.width - 40, height: 90))
        textLbl1.text = "YourreferralcodeisKey".localized()  + (AppUtils.getStringForKey(key: Constant.referralCode) ?? "")
               textLbl1.font = UIFont(name: "Helvetica Neue-Bold", size: 18.0)
               textLbl1.numberOfLines = 0
               textLbl1.textColor = UIColor.white
               textLbl1.textAlignment = .center
               self.view.addSubview(textLbl1)
        
//        let textLbl3 = UILabel(frame: CGRect(x: (UIScreen.main.bounds.width / 2)-120, y: (UIScreen.main.bounds.height/2)-170, width: 240, height: 60))
//        textLbl3.text = "YourreferralcodeisKey".localized()
//        textLbl3.font = UIFont(name: "Helvetica Neue-Bold", size: 25.0)
//        textLbl3.numberOfLines = 2
//        textLbl3.textColor = UIColor.white
//        textLbl3.textAlignment = .center
//        self.view.addSubview(textLbl3)
        
 
        
    let textLbl2 = UILabel(frame: CGRect(x: 20, y: (UIScreen.main.bounds.height/2)-130, width: UIScreen.main.bounds.width - 40, height: 90))
        textLbl2.text = "Invitefriends&get1monthsubscriptionfreeKey".localized()
        textLbl2.font = UIFont(name: "Helvetica Neue-Bold", size: 18.0)
        textLbl2.numberOfLines = 0
        textLbl2.textColor = UIColor.white
        textLbl2.textAlignment = .center
        self.view.addSubview(textLbl2)
    }
    func txtButton()
    {
        let txtButton = UIButton(frame: CGRect(x: (UIScreen.main.bounds.width/2)-120, y:(UIScreen.main.bounds.height/2)+70, width: 250, height: 40))
        txtButton.backgroundColor = Constant.Color.navColor
        txtButton.setTitle("InviteFriendsKey".localized(), for: .normal)
        txtButton.setTitleColor(UIColor.white, for: .normal)
        txtButton.layer.cornerRadius = 20
        txtButton.borderWidth = 2
        txtButton.borderColor = Constant.Color.buttonColor
        txtButton.addTarget(self, action:#selector(self.refreClicked), for: .touchUpInside)
        self.view.addSubview(txtButton)
    }
    
    @objc func refreClicked()
     {
           
           let str = "HellocheckoutthisnewfunappIt’scalledyourtrackappYoucantryitonemonthforfreeCan’twaittofollowyour performancesClickheretodownloadHereismyreferralcodeKey".localized()
           let finalStr = str.replacingOccurrences(of: "XXXX", with: "\(AppUtils.getStringForKey(key: Constant.referralCode)!)")

           let items = [finalStr]
           let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
           ac.setValue("InviteFriendsKey".localized(), forKey: "Subject")
           present(ac, animated: true)
       }

}
