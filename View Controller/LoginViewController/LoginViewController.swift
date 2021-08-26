//
//  LoginViewController.swift
//  TrackApp
//
//  Created by sanganan on 11/4/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//
import UIKit
import SkyFloatingLabelTextField
import RxSwift

final class LoginViewController: UIViewController,UITextFieldDelegate {
    var checkValue : Bool = false
    var eyeBtnCheck = false
    var checkBtnChck = false
    
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var bgImg: UIImageView!
    @IBOutlet weak var checkBox: UIButton!
    @IBOutlet weak var remMeLbl: UILabel!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var forgetPwdBtn: UIButton!
    @IBOutlet weak var loginEyeBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
        
        {
        didSet{
            self.passwordField.isSecureTextEntry = true
        }
    }
    private let bag       = DisposeBag()
    private var viewModel:LoginViewModal! = LoginViewModal()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commonNavigationBar(title:"LoginKey".localized(), controller: AppUtils.Controllers.loginVC, badgeCount: "0")
        
        self.loginEyeBtn.setImage(UIImage(named: "notvisible"), for: .normal)
        
        if eyeBtnCheck == false{
            self.passwordField.isSecureTextEntry = true
        }else{
            self.passwordField.isSecureTextEntry = false
        }
        self.checkBox.setImage(UIImage(named: "check"), for: .selected)
        self.checkBox.setImage(UIImage(named: "uncheck"), for: .normal)
        self.signInButton.backgroundColor = Constant.Color.buttonColor
        self.viewBinding()
        self.topConstraint.constant = (UIScreen.main.bounds.height - (0.88*UIScreen.main.bounds.height))
        
        
        self.emailField.placeholder = "EmailKey".localized()
        self.passwordField.placeholder = "PasswordKey".localized()
        self.remMeLbl.text = "RemembermeKey".localized()
        self.signInButton.setTitle("LoginKey".localized(), for: .normal)
        self.forgetPwdBtn.setTitle("Forgotpassword2Key".localized(), for: .normal)
        self.signUpLabel.text = "DonthaveanaccountKey".localized()
        self.signUpBtn.setTitleColor(Constant.Color.buttonColor, for: .normal)
        
        self.signUpBtn.setTitle("Signup2Key".localized(), for: .normal)
        
        //        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        //        self.navigationController?.navigationBar.shadowImage = UIImage()
        //        self.navigationController?.navigationBar.isTranslucent = true
        //        self.navigationController?.view.backgroundColor = UIColor.clear
//        self.emailField.setLeftPaddingPoints(20)
//        self.passwordField.setLeftPaddingPoints(20)
        
    }
    
    @IBAction func eyeBtnActn(_ sender: UIButton) {
        if eyeBtnCheck == false{
               self.passwordField.isSecureTextEntry = false
            self.loginEyeBtn.setImage(UIImage(named: "visible"), for: .normal)
            self.eyeBtnCheck = true
               }else{
            self.eyeBtnCheck = false
             self.loginEyeBtn.setImage(UIImage(named: "notvisible"), for: .normal)
                   self.passwordField.isSecureTextEntry = true
               }
    }
    
    func viewBinding(){
        emailField.rx.text
            .orEmpty
            .bind(to: viewModel.emailText)
            .disposed(by: bag)
        passwordField.rx.text
            .orEmpty
            .bind(to: viewModel.passwordText)
            .disposed(by: bag)
        signInButton.rx.tap
            .subscribe(onNext: {[weak self] screen in
                if (try!  self!.viewModel.emailText.value()) == "" || (try!  self!.viewModel.passwordText.value() == "") 
                {
                    AppUtils.showToast(message: "PleaseenterEmailNPassKey".localized())
                }
                else if (try!  self!.viewModel.emailText.value() == "")
                {
                    AppUtils.showToast(message: "PleaseenterEmailKey".localized())
                }
                else if (try!  self!.viewModel.passwordText.value() == "")
                {
                    AppUtils.showToast(message: "PleaseenterPassKey".localized())
                }
                    
                else{
                    self?.loginApiCall()
                }
            })
            .disposed(by: self.bag)
    }
    @IBAction func signInButton(_ sender: Any) {
        self.view.endEditing(true)
        //        if (emailField.text == "" || passwordField.text == "")
        //        {
        //            AppUtils.showToast(message: Constant.emailPwdErr)
        //        }else
        //        {
        //            return
        //        }
    }
    @IBAction func checkBoxActn(_ sender: UIButton) {
        sender.transform = CGAffineTransform()
        if self.checkValue == false{
            self.checkValue = true
            sender.isSelected = !sender.isSelected
        }else
        {
            self.checkValue = false
            sender.isSelected = !sender.isSelected
        }
        sender.transform = .identity
    }
    @IBAction func forgetPassword(_ sender: Any) {
        let vc = AppUtils.Controllers.forgetPwdVC.get() as! ForgetPasswordViewController
        self.navigationController?.pushViewController(vc, animated: true)
        return
    }
    @IBAction func signUpButton(_ sender: Any) {
        
        let vc = AppUtils.Controllers.signUpVC.get() as! SignUpViewController
        self.navigationController?.pushViewController(vc, animated: true)
        return
    }
    
    //MARK:- APi
    func loginApiCall(){
        Utils.startLoading(self.view)
        let url:String = Constant.basicApi + "/login"
        let request:[String:Any] = ["email": try!  self.viewModel.emailText.value(),"password":try!  self.viewModel.passwordText.value(),"device":["deviceType":1100,"deviceId":AppUtils.AppDelegate().FCMToken!]]
        Service.sharedInstance.postRequest(Url:url,modalName: LoginModal.self , parameter: request as [String:Any]) { (response, error) in
            DispatchQueue.main.async {
                Utils.stopLoading()
                if let res = response?.Success{
                    if res == 1{
                        let userData = UserDefaults.standard
                        userData.set(response?.payload?.email, forKey: Constant.email)
                        userData.set(response?.payload?.id, forKey: Constant.id)
                        userData.set(response?.payload?.username, forKey: Constant.username)
                        userData.synchronize()
                        guard let userId = response?.payload?.id else{return}
                        
                        AppUtils.AppDelegate().userId = userId
                        //self.removeVCFromStack(numberOFStack: 1)
                        let vc = AppUtils.Controllers.home.get() as! HomeViewController
                        self.navigationController?.pushViewController(vc, animated:true)
                        self.removeVCFromStack(numberOFStack: 2)
                    }else{
                        AppUtils.showToast(message: (response?.Message)!)
                    }
                }}
            
        }
    }
    
}


