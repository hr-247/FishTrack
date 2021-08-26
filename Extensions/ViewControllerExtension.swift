//
//  ViewControllerExtension.swift
//  TrackApp
//
//  Created by sanganan on 12/23/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
extension UITextField{
    @IBInspectable  var roundCornerTF: CGFloat
        {
        get{
            return self.frame.width/2
        }
        set{
            layer.cornerRadius = newValue
        }
    }
}
extension UIView{
    @IBInspectable var roundCorner : CGFloat{
        get {
            return self.frame.width/2
        }
        set{
            layer.cornerRadius = newValue
    }
}
    @IBInspectable var borderWidth : CGFloat{
           get {
            return self.frame.width
           }
           set{
               layer.borderWidth = newValue
       }
}
     @IBInspectable var borderColor : UIColor{
               get {
                return self.borderColor
               }
               set{
                layer.borderColor = newValue.cgColor
           }
    }
}

extension UITextField {
    @IBInspectable var cornerRadius: CGFloat {
        set{
            layer.cornerRadius = newValue
        }
        get{
            return layer.cornerRadius
        }
    }
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
//    @IBInspectable  var paddingLeft : CGFloat   {
//        
//        //iDTextOutlet.leftViewMode = .always
//        get {
//            
//            return self.leftView?.frame.width ?? 5.0
//        }
//        set {
//            let view =  UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: self.frame.height))
//            self.leftView = view
//            self.leftViewMode = .always
//            
//        }
//    }
}


