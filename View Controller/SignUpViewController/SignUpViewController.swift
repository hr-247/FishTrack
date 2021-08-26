//
//  SignUpViewController.swift
//  TrackApp
//
//  Created by sanganan on 11/4/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var topCons8: NSLayoutConstraint!
    @IBOutlet weak var topCons7: NSLayoutConstraint!
    @IBOutlet weak var topCons6: NSLayoutConstraint!
    @IBOutlet weak var topCons5: NSLayoutConstraint!
    @IBOutlet weak var topCons4: NSLayoutConstraint!
    @IBOutlet weak var topCons3: NSLayoutConstraint!
    @IBOutlet weak var topCons2: NSLayoutConstraint!
    @IBOutlet weak var topCons9: NSLayoutConstraint!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet var boxStatementLabel: UILabel!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var rePassField: UITextField!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet var tcLabel: UILabel!
    @IBOutlet weak var tndCBtn: UIButton!
    @IBOutlet weak var andLbl: UILabel!
    @IBOutlet weak var privacyPolicyBtn: UIButton!
    @IBOutlet weak var eyeButton: UIButton!
 
    
    //MARK:- Variables
    
    var eyeBtnCheck = false
    var checkBtnChck = false
    
    
    //MARK:- View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commonNavigationBar(title: "SignUpKey".localized(), controller: AppUtils.Controllers.signUpVC, badgeCount: "0")
        // self.view.backgroundColor = Constant.Color.backGroundColor
        
        self.emailField.placeholder = "Email2Key".localized()
        self.userNameField.placeholder = "Username2Key".localized()
        self.passwordField.placeholder = "Password2Key".localized()
        self.rePassField.placeholder = "EnterreferralcodeifAnyKey".localized()
        self.locationLabel.text = "AccessMyLocationKey".localized()
        self.doneButton.setTitle("SignUpKey".localized(), for: .normal)
        self.boxStatementLabel.text = "Youmustbeatleasteighteen(18)yearsofageoraboveKey".localized()
        self.tcLabel.text = "ClickingSignUpmeansthatyouagreetotheKey".localized()
        self.tndCBtn.setTitle("Terms&ConditionsKey".localized(), for: .normal)
        self.andLbl.text = "andKey".localized()
        self.privacyPolicyBtn.setTitle("PrivacyPolicyKey".localized(), for: .normal)
        
        
        self.eyeButton.setImage(UIImage(named: "notvisible"), for: .normal)
        self.checkBtn.setImage(UIImage(named: "uncheck"), for: .normal)
        if eyeBtnCheck == false{
            self.passwordField.isSecureTextEntry = true
        }else{
            self.passwordField.isSecureTextEntry = false
        }
        self.doneButton.backgroundColor = Constant.Color.buttonColor
        
        self.tndCBtn.setTitleColor(Constant.Color.buttonColor, for: .normal)
        self.privacyPolicyBtn.setTitleColor(Constant.Color.buttonColor, for: .normal)
        //self.rePassField.isSecureTextEntry = true
        
        //      self.topConstraint.constant = (UIScreen.main.bounds.height - (0.88*UIScreen.main.bounds.height))
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                self.topConstraint.constant = (UIScreen.main.bounds.height - (0.98*UIScreen.main.bounds.height))
                self.topCons2.constant = (topCons2.constant - (0.3*topCons2.constant))
                self.topCons3.constant = (topCons3.constant - (0.3*topCons3.constant))
                self.topCons4.constant = (topCons4.constant - (0.3*topCons4.constant))
                self.topCons5.constant = (topCons5.constant - (0.1*topCons5.constant))
                self.topCons6.constant = (topCons6.constant - (0.1*topCons6.constant))
                self.topCons7.constant = (topCons7.constant - (0.8*topCons7.constant))
                self.topCons8.constant = (topCons8.constant - (0.85*topCons8.constant))
                self.topCons9.constant = (topCons9.constant - (0.67*topCons9.constant))
                
                return
            case 1334:
                self.topConstraint.constant = (UIScreen.main.bounds.height - (0.92*UIScreen.main.bounds.height))
                self.topCons7.constant = (topCons7.constant - (0.72*topCons7.constant))
                self.topCons8.constant = (topCons8.constant - (0.78*topCons8.constant))
                self.topCons9.constant = (topCons9.constant - (0.62*topCons9.constant))
                
                return
            default:
                return
            }
        }
    }
    
    
    @IBAction func eyeBtnActn(_ sender: UIButton) {
        if eyeBtnCheck == false{
            self.passwordField.isSecureTextEntry = false
            self.eyeButton.setImage(UIImage(named: "visible"), for: .normal)
            self.eyeBtnCheck = true
        }else{
            self.eyeBtnCheck = false
            self.eyeButton.setImage(UIImage(named: "notvisible"), for: .normal)
            self.passwordField.isSecureTextEntry = true
        }
    }
    
    //MARK:- SIGNUP API CALL
    func signUPApiCall(){
        
        Utils.startLoading(self.view)
        if let data = rePassField.text
        {
            rePassField.text = data
        }else{
            rePassField.text = ""
        }
        let url:String = "\(Constant.basicApi)/signup"
        let userData = UserDefaults.standard
        let lat = Double(userData.string(forKey: Constant.latitude) ?? "0.0")
        let long = Double(userData.string(forKey: Constant.longitude) ?? "0.0")
        let dict:[String:Any] = ["email":emailField.text!,"username":userNameField.text!,"userImage":"https://previews.123rf.com/images/irwanjos/irwanjos1404/irwanjos140400014/27783537-dinosaur-cartoon.jpg","password":passwordField.text!,"referredBy":rePassField.text!,"loc":["type":"Point","coordinates":[lat!,long!]],"device":["deviceType":1100,"deviceId":AppUtils.AppDelegate().FCMToken!]]
        
        Service.sharedInstance.postRequest(Url:url,modalName: resultModal.self , parameter: dict as [String:Any]) { (response, error) in
            DispatchQueue.main.async {
                Utils.stopLoading()
                
                if let res = response?.Success
                {
                    if res == 1{
                        
                        let userData = UserDefaults.standard
                        userData.set(response?.message?.User?.email, forKey: Constant.email)
                        userData.set(response?.message?.User?._id, forKey: Constant.id)
                        userData.set(response?.message?.User?.username, forKey: Constant.username)
                        userData.set(response?.message?.User?.userImage, forKey: Constant.userImage)
                        userData.synchronize()
                        
                        if let userId = response?.message?.User?._id
                        {
                            AppUtils.AppDelegate().userId = userId
                        }
                        let vc:HomeViewController = HomeViewController()
                        self.navigationController?.pushViewController(vc, animated: true)
                        AppUtils.showToast(message: (response?.message?.Message)!)
                        self.removeVCFromStack(numberOFStack: 2)
                        
                    }else{
                        AppUtils.showToast(message: (response?.Message)!)
                    }
                }else{
                    // do in case of error
                }
            }
        }
    }
    
    
    @IBAction func checkBtnActn(_ sender: Any) {
        if checkBtnChck == false{
            Utils.sharedInstance.initLocationManager() // always update current location
            self.checkBtn.setImage(UIImage(named: "check"), for: .normal)
            
            self.checkBtnChck = true
        }else{
            self.checkBtnChck = false
            self.checkBtn.setImage(UIImage(named: "uncheck"), for: .normal)
        }
        
        
    }
    
    @IBAction func tcButton(_ sender: Any) {
        
        let vc = TermsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        return
    }
    //MARK:- DONE BUTTON & VALIDATION
    @IBAction func doneButton(_ sender: Any) {
        
        let email = AppUtils.isValidEmail(testStr: emailField.text!)
        
        
        //   let pwd = AppUtils.isValidPwd(testStr: passwordField.text!)
        
        
        //        let userName = AppUtils.isValidUsername(testStr: userNameField.text!)
        //        AppUtils.showToast(message: "Please fill all details")
        
        if email == true && userNameField.text != "" && passwordField.text != "" {
            
            self.signUPApiCall()
            // AppUtils.showToast(message: "Signup successfully", view: self.view)
        }
        else if (emailField.text == "" || userNameField.text == "" || passwordField.text == "") {
            AppUtils.showToast(message: Constant.fillAllDetails!)
        }
        else if email == false{
            
            AppUtils.showToast(message: Constant.invalidEmail)
        }
        //        else if pwd == false {
        //
        //            AppUtils.showToast(message: "inavlid paasword")
        //
        //        }
        //        else if (self.checkValue == false)
        //        {
        //            AppUtils.showToast(message: Constant.untickCheckbox)
        //        }
    }
}



