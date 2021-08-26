//
//  TermsViewController.swift
//  TrackApp
//
//  Created by sanganan on 11/15/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//

import UIKit


class TermsViewController: UIViewController {
    
    @IBOutlet weak var termsTxtVw: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commonNavigationBar(title: "TermsandConditionsKey".localized(), controller: AppUtils.Controllers.termsVC, badgeCount: "0")
    //    self.view.backgroundColor = Constant.Color.backGroundColor

        let textView = UITextView(frame: CGRect(x: 20, y: 10, width: Int(self.view.frame.size.width)-70, height: Int(self.view.frame.size.height) ))
        
        textView.textAlignment = .center
        textView.textColor = .white
        textView.backgroundColor = .black
        textView.textColor = UIColor.white
        textView.text = "LoremipsumdolorsitametconsecteturadipiscingelitseddoeiusmodtemporincididuntutlaboreetdoloremagnaaliquaUtenimadminimveniamquisnostrudexercitationullamcolaborisnisiutaliquipexeacommodoconsequatDuisauteiruredolorinreprehenderitinvoluptatevelitessecillumdoloreeufugiatnullapariaturExcepteursintoccaecatcupidatatnonproidentsuntinculpaquiofficiadeseruntmollitanimidestlaborumKey".localized()
        
        textView.font = UIFont.boldSystemFont(ofSize: 20)
        textView.font = UIFont(name: "Helvetica Neue", size: 17)
       
         self.view.addSubview(textView)
        
        if UIDevice().userInterfaceIdiom == .phone {
                   switch UIScreen.main.nativeBounds.height {
                   case 1136:
                       print("iPhone 5 or 5S or 5C")
                       
                   case 1334:
                       print("iPhone 6/6S/7/8")
                    let textView = UITextView(frame: CGRect(x: 10, y: 10, width: Int(self.view.frame.size.width)-70, height: Int(self.view.frame.size.height) ))
                    
                       
                   case 1920, 2208:
                       print("iPhone 6+/6S+/7+/8+")
                    let textView = UITextView(frame: CGRect(x: 10, y: 10, width: Int(self.view.frame.size.width)-70, height: Int(self.view.frame.size.height) ))
                    
                    
                   case 2436:
                       print("iPhone X/XS/11 Pro")
                     let textView = UITextView(frame: CGRect(x: 20, y: 20, width: Int(self.view.frame.size.width), height: Int(self.view.frame.size.height) ))
                     
                       
                   case 2688:
                       print("iPhone XS Max/11 Pro Max")
                      let textView = UITextView(frame: CGRect(x: 20, y: 20, width: Int(self.view.frame.size.width), height: Int(self.view.frame.size.height) ))
                      
                   case 1792:
                       print("iPhone XR/ 11 ")
                    let textView = UITextView(frame: CGRect(x: 20, y: 20, width: Int(self.view.frame.size.width), height: Int(self.view.frame.size.height) ))
                    
                       
                   default:
                       print("Unknown")
                   }
        }
    }
}
