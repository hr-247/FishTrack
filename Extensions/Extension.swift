//
//  Extension.swift
//  TrackApp
//
//  Created by shubham tyagi on 12/12/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//

import UIKit

    extension Date {
        var millisecondsSince1970:Int64 {
            return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
        }

        init(milliseconds:Int64) {
            self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
        }
    }

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
DispatchQueue.main.async {
           let path = UIBezierPath(roundedRect: self.bounds,
                                   byRoundingCorners: corners,
                                   cornerRadii: CGSize(width: radius, height: radius))
           let maskLayer = CAShapeLayer()
           maskLayer.frame = self.bounds
           maskLayer.path = path.cgPath
           self.layer.mask = maskLayer
       }
    }
    func setGradientBackground(colorTop: UIColor, colorBottom: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorBottom.cgColor, colorTop.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = bounds

       layer.insertSublayer(gradientLayer, at: 0)
    }
}

//MARK:- Localized String
extension String {
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        
        
        
        let path = Bundle.main.path(forResource: "nl", ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: tableName, bundle: bundle!, value: "\(self)", comment: "")
        
        
        
        
        
        
        
       // return NSLocalizedString(self, tableName: tableName, value: "\(self)", comment: "")
    }
}
extension UITextField
{
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
