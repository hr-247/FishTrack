//
//  LocationViewController.swift
//  TrackApp
//
//  Created by saurav sinha on 04/11/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//
import UIKit
import GooglePlaces
import GoogleMaps
import CoreLocation


class LocationViewController: UIViewController {
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var locationView: UIView!
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var placesClient: GMSPlacesClient!
    var locationArr:[Double] = [Double]()
    var place:String = ""
    var requestBtn = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placesClient = GMSPlacesClient.shared()
        self.commonNavigationBar(title: "LocationKey".localized(), controller: AppUtils.Controllers.locationVC, badgeCount: "0")
    //    self.view.backgroundColor = Constant.Color.backGroundColor

        var currentLocation: CLLocation!
        var locManager = CLLocationManager()
        
        let user = UserDefaults.standard
        
        let lat = (user.double(forKey: Constant.latitude))
        let long = (user.double(forKey: Constant.longitude))
        
        
        if lat != 0 && long != 0 {
                   let location = CLLocation.init(latitude: lat, longitude: long)
                   self.getPlace(for: location) { (placemark) in
                       if let placeM = placemark
                       {
                           if let local = placeM.locality
                           {
                               self.place = local

                           }
                       }
                   }
               }
        
        currentLocation = locManager.location
         
        self.locationArr.append(lat)
        self.locationArr.append(long)
        self.googleMap(lat: lat , long: long)
    }
    
    
    func getPlace(for location: CLLocation,
                        completion: @escaping (CLPlacemark?) -> Void) {
              
              let geocoder = CLGeocoder()
              geocoder.reverseGeocodeLocation(location) { placemarks, error in
                  
                  guard error == nil else {
                      print("*** Error in \(#function): \(error!.localizedDescription)")
                      completion(nil)
                      return
                  }
                  
                  guard let placemark = placemarks?[0] else {
                      print("*** Error in \(#function): placemark is nil")
                      completion(nil)
                      return
                  }
                  
                  completion(placemark)
              }
          }
    
    
    override func viewWillAppear(_ animated: Bool) {
       self.checkStatus()
    }
    
    func googleMap(lat:Double,long:Double)
    {
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 16.0)
        
        //let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        let mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height:  UIScreen.main.bounds.height - 100), camera: camera)
        view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        
        let markerImage = UIImage(named: "location_icon")!
        
        //creating a marker view
        let markerView = UIImageView(image: markerImage)
        markerView.tintColor = UIColor.black
        
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        marker.iconView = markerView
        //marker.title = "Sydney"
        //marker.snippet = "Australia"
        
        marker.map = mapView
        mapView.selectedMarker = marker // to put a callout bubble
        //
        resultsViewController = GMSAutocompleteResultsViewController.init()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        //let textfield:UITextField = UITextField(frame: CGRect(x: <#T##CGFloat#>, y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>))
        var height = AppUtils.heightOfStatAndNavibar(view : self)
        let subView = UIView(frame: CGRect(x: 0, y: height, width: 350.0, height: 45.0))
        let button : UIButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 100, y: UIScreen.main.bounds.height - 100, width: 80, height: 80))
        button.isUserInteractionEnabled = true
        button.setImage(UIImage(named: "next_icon.png"), for: .normal)
        button.addTarget(self, action: #selector(okButton), for: .touchUpInside )
//        self.requestBtn  = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 100, y: UIScreen.main.bounds.height - 200, width: 80, height: 80))
//        requestBtn.isUserInteractionEnabled = true
//        requestBtn.setImage(UIImage(named: "RequestLocation.png"), for: .normal)
//        requestBtn.addTarget(self, action: #selector(permission), for: .touchUpInside )
//        requestBtn.layer.cornerRadius = 30
        mapView.gestureRecognizers?.removeAll()
        // subView.addSubview(button)
        subView.addSubview((searchController?.searchBar)!)
        mapView.addSubview(subView)
        mapView.insertSubview(button, aboveSubview: mapView)
        mapView.insertSubview(requestBtn, aboveSubview: mapView)

        
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        navigationController?.navigationBar.isTranslucent = true
        searchController?.hidesNavigationBarDuringPresentation = true
        
        
        // This makes the view area include the nav bar even though it is opaque.
        // Adjust the view placement down.
        self.extendedLayoutIncludesOpaqueBars = false
        self.edgesForExtendedLayout = .top
    }
    @objc func okButton(){
        
        if self.place.count == 0 {
                   
            AppUtils.showToast(message: "WearenotabletofetchyourcurrentlocationPleasechoosealocationKey".localized())
                   return
               }
        let vc:PlacesViewController = AppUtils.Controllers.placesVC.get() as! PlacesViewController
        vc.loc = self.locationArr
        vc.locationName = self.place
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func checkStatus(){
        // initialise a pop up for using later
        let alertController = UIAlertController(title: "", message: "PleasegotoSettingsandturnonthepermissionsKey".localized(), preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "SettingsKey".localized(), style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                       return
                   }
                   if UIApplication.shared.canOpenURL(settingsUrl) {
                       UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
                    }
               }
        let cancelAction = UIAlertAction(title: "CancelKey".localized(), style: .default, handler: nil)
               alertController.addAction(cancelAction)
               alertController.addAction(settingsAction)

               // check the permission status
               switch(CLLocationManager.authorizationStatus()) {
                   case .authorizedAlways, .authorizedWhenInUse:
                       print("Authorize.")
                       Utils.sharedInstance.initLocationManager()
                       //self.requestBtn.isHidden = true
                       // get the user location
                   case .notDetermined, .restricted, .denied:
                       // redirect the users to settings
                   // self.requestBtn.isHidden = false
                       self.present(alertController, animated: true, completion: nil)
               @unknown default:
                print("")
            }
            
        }

    @objc func permission(){
        self.checkStatus()
        
}
}

extension LocationViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        
        var centre = place.coordinate as CLLocationCoordinate2D
        var getLat: CLLocationDegrees = centre.latitude
        var getLon: CLLocationDegrees = centre.longitude
        self.googleMap(lat: getLat, long: getLon)
        self.locationArr.append(getLat)
        self.locationArr.append(getLon)
        self.place = place.name!
        self.searchController?.searchBar.text = place.name!
        print("Place address: \(place.formattedAddress),\(place.name)")
        print("Place attributions: \(place.attributions)")
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
