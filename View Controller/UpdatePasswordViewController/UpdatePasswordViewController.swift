//
//  UpdatePasswordViewController.swift
//  TrackApp
//
//  Created by sanganan on 1/27/20.
//  Copyright © 2020 Sanganan. All rights reserved.
//

import UIKit

class UpdatePasswordViewController: UIViewController {
    
    @IBOutlet weak var oldPassLbl: UITextField!
    @IBOutlet weak var newPassLbl: UITextField!
    @IBOutlet weak var reEnterPass: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commonNavigationBar(title: "UpdatepasswordKey".localized(), controller: AppUtils.Controllers.updatePassVC, badgeCount: "0")
    //    self.view.backgroundColor = Constant.Color.backGroundColor
        self.saveBtn.backgroundColor = Constant.Color.buttonColor
        
        self.saveBtn.setTitle("SAVEKey".localized(), for: .normal)
        self.oldPassLbl.placeholder = "OldPasswordKey".localized()
        self.newPassLbl.placeholder = "NewPasswordKey".localized()
        self.reEnterPass.placeholder = "ReenterPasswordKey".localized()

    }
    
    @IBAction func savePassActn(_ sender: Any) {
        if (self.newPassLbl.text == self.reEnterPass.text && self.oldPassLbl.text != "" && self.newPassLbl.text != "")
        {
            self.updatePassApi()
        }
        else{
            if (self.oldPassLbl.text == "" && self.newPassLbl.text  == "" && self.reEnterPass.text == "")
            {
                AppUtils.showToast(message: "PleasefillalldetailsKey".localized())
            }
            else if self.oldPassLbl.text == ""
            {
                AppUtils.showToast(message: "PleasefilloldPasswordKey".localized())
            }
            else if self.newPassLbl.text == ""
            {
                AppUtils.showToast(message: "PleasefillNewPasswordKey".localized())
            }
            else if self.newPassLbl.text != self.reEnterPass.text
            {
                AppUtils.showToast(message: "PasswordsarenotmatchingKey".localized())
            }
        }
    }
    //MARK:- UPDATE PASSWORD POST API
    func updatePassApi()
    {
        Utils.startLoading(self.view)
        let url : String = "\(Constant.basicApi)/updateUserPassword"
        let dict:[String:Any] = ["userId":AppUtils.AppDelegate().userId,"oldPassword": self.oldPassLbl.text ,"newPassword":self.newPassLbl.text]
        
        Service.sharedInstance.postRequest(Url:url,modalName: updateUserPasswordModal.self , parameter: dict as [String:Any]) { (response, error) in
            DispatchQueue.main.async {
                Utils.stopLoading()
                if let res = response?.Success
                {
                    if res == 1{
                        let vc:HomeViewController = HomeViewController()
                        self.navigationController?.pushViewController(vc, animated: true)
                        AppUtils.showToast(message: (response?.Message)!)
                     }
                    else
                    {
                        AppUtils.showToast(message: (response?.Message)!)
                    }
                }
            }
        }
    }
    
}
