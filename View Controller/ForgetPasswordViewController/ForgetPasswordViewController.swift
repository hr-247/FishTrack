//
//  ForgetPasswordViewController.swift
//  TrackApp
//
//  Created by sanganan on 11/19/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//

import UIKit

class ForgetPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.commonNavigationBar(title: "ForgotpasswordKey".localized(), controller: AppUtils.Controllers.forgetPwdVC, badgeCount: "0")
        
        self.emailTextField.placeholder = "EnteryouremailidKey".localized()
        self.sendBtn.setTitle("SendKey".localized(), for: .normal)
        
     //   self.view.backgroundColor = Constant.Color.backGroundColor
        self.sendBtn.backgroundColor = Constant.Color.buttonColor

        self.emailTextField.text = AppUtils.getStringForKey(key: Constant.email)
        
        }
    
    @IBAction func emailSentActn(_ sender: Any) {
        if self.emailTextField.text != ""
        {
            self.forgotPassApi()
        }
        else{
            AppUtils.showToast(message: "PleaseentervalidemailidKey".localized())
        }
        
    }
    
    //MARK:- FORGOT PASSWORD POST API
       func forgotPassApi()
       {
           Utils.startLoading(self.view)
           let url : String = "\(Constant.basicApi)/forgotPassword"
        let dict:[String:Any] = ["userEmail":self.emailTextField.text!]
           
        Service.sharedInstance.postRequest(Url:url,modalName: ForgetPasswordModal.self, parameter: dict as [String:Any]) { (response, error) in
               DispatchQueue.main.async {
                   Utils.stopLoading()
                   if let res = response?.Success
                   {
                       if res == 1{
                        self.navigationController?.popViewController(animated: true)
                        AppUtils.showToast(message: (response?.mailStatus?.Status)!)
                       }else
                       {
                        AppUtils.showToast(message: (response?.Message)!)
                    }
                
                   }
               }
           }
       }
       
    
}
