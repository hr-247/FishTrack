//
//  LoginViewModal.swift
//  TrackApp
//
//  Created by shubham tyagi on 09/01/20.
//  Copyright © 2020 Sanganan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


final class LoginViewModal {
    private let disposeBag     = DisposeBag()
    public  let emailText      = BehaviorSubject<String>(value:"")
    public  let passwordText   = BehaviorSubject<String>(value:"")
    public  let loginBtn       = PublishSubject<Void>()
    private  typealias apiData = () -> ()
    
    init(){
        // let input = Observable.combineLatest(emailText, passwordText)
        
        emailText.asObservable()
            .subscribe(onNext:{[weak self] string in
            //    print("rxSwift:\(string)")
            })
            .disposed(by:disposeBag)
        passwordText.asObservable()
            .subscribe(onNext:{[weak self] string in
            //    print("rxSwiftpassword:\(string)")
            })
            .disposed(by:disposeBag)
        loginBtn.asObservable().do(onNext: { _ in
         //   print("hii")
        })
        
    }
    
}
