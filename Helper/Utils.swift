//
//  Utils.swift
//  TrackApp
//
//  Created by saurav sinha on 25/11/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import DKPhotoGallery

class Utils: NSObject,CLLocationManagerDelegate {
    static var sharedInstance = Utils()
    
    static var progressView : MBProgressHUD?
    
    var locationManager: CLLocationManager!
    
    //MARK:- MBPROGRESSHUd
    static func startLoading(_ view : UIView)
    {
        progressView = MBProgressHUD.showAdded(to: view, animated: true);
        progressView?.animationType = .zoomIn
        progressView?.areDefaultMotionEffectsEnabled = true
        progressView?.isUserInteractionEnabled = false
        view.isUserInteractionEnabled = true
        }
    static func startLoadingWithText(_ strText: String, view : UIView)
    {
        progressView = MBProgressHUD.showAdded(to: view, animated: true);
        progressView?.label.text = strText;
        progressView?.isUserInteractionEnabled = false
        
    }
    
    static func changeLoadingWithText(_ strText: String)
    {
        progressView?.label.text = strText;
    }
    
    static func stopLoading()
    {
        if self.progressView != nil
        {
            self.progressView!.hide(animated: true);
        }
    }
    // Location Manager helper stuff
    func initLocationManager() {
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    // Location Manager Delegate stuff
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("errorOfLocation:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
        else if status == .denied{
            
        }
        else if status == .notDetermined{
          
        }
        else if status == .restricted{
          
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.first != nil {
            //            print("location:\(locations.first?.coordinate.latitude)\(locations.first?.coordinate.longitude)")
            let userData = UserDefaults.standard
            userData.set(Double((locations.first?.coordinate.latitude)!), forKey: Constant.latitude)
            userData.set(Double((locations.first?.coordinate.longitude)!), forKey: Constant.longitude)
        }
        locationManager.stopUpdatingLocation();
    }
    
    static func Authoris(vc:UIViewController){
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                let alertController = UIAlertController(title: "LocationPermissionRequiredKey".localized(), message: "PleaseenablelocationpermissionsinsettingsKey".localized(), preferredStyle: UIAlertController.Style.alert)
                
                let okAction = UIAlertAction(title: "SettingsKey".localized(), style: .default, handler: {(cAlertAction) in
                    //Redirect to Settings app
                    UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
                })
                
                let cancelAction = UIAlertAction(title: "CancelKey".localized(), style: UIAlertAction.Style.cancel)
                alertController.addAction(cancelAction)
                
                alertController.addAction(okAction)
                
                vc.present(alertController, animated: true, completion: nil)
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            @unknown default:
                break
            }
        } else {
            print("Location services are not enabled")
        }
    }
}
extension Utils
{
    
    static func imageTapped(index : Int, imageUrls : [URL], con : UIViewController)
    {
  
    let gallery = DKPhotoGallery()
    gallery.singleTapMode = .dismiss
        
    var items = [DKPhotoGalleryItem]()
    for url in imageUrls
    {
        let item = DKPhotoGalleryItem(imageURL: url)
        items.append(item)

        }
        
    gallery.items = items
  //  gallery.presentingFromImageView = self.imageView
    gallery.presentationIndex = index

//    gallery.finishedBlock = { dismissIndex, dismissItem in
//        if item == dismissItem {
//            return imageView
//        } else {
//            return nil
//        }
//    }

    con.present(photoGallery: gallery)
    }
    
}
