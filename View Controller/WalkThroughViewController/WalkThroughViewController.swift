//
//  WalkThroughViewController.swift
//  TrackApp
//
//  Created by sanganan on 11/4/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//

import UIKit


class WalkThroughViewController: UIViewController,UIScrollViewDelegate {
    
    @IBOutlet weak var btmConst: NSLayoutConstraint!
    
    @IBOutlet weak var scrView: UIScrollView!
    
    //   @IBOutlet var trackLabel: UILabel!
    
    @IBOutlet weak var pCTNxtBtn: NSLayoutConstraint!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var nextButton: UIButton!
    
  
    
    var arrImags = ["bg_inside","bg2","bg3"]
    lazy var textArr = ["TrackyourperformanceKey".localized(),"ViewyourstatisticsKey".localized(),"ShareyourperformancewithfriendsKey".localized()]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nav()
   
        self.btmConst.constant = (UIScreen.main.bounds.height - (0.97*UIScreen.main.bounds.height))
         self.pCTNxtBtn.constant = (UIScreen.main.bounds.height - (0.997*UIScreen.main.bounds.height))
    }
    func nav(){
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    override func viewDidLayoutSubviews() {
        self.loadScrollView()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    func loadScrollView() {
        let pageCount = arrImags.count
        scrView.delegate = self
        scrView.backgroundColor = UIColor.clear
        scrView.isPagingEnabled = true
        pageControl.numberOfPages = pageCount
        pageControl.currentPage = 0
        
        for i in (0..<pageCount) {
            
            let imageView = UIImageView()
            imageView.frame = CGRect(x: i*Int(self.view.frame.width), y: 0 , width:
                Int(self.view.frame.size.width) , height: Int(self.view.frame.height))
            
            imageView.image = UIImage(named: arrImags[i])
            let lbl = UILabel(frame: CGRect(x: 0, y:self.view.frame.height * (0.64), width:self.view.frame.width, height: 60))
            lbl.text = textArr[i]
            lbl.textColor = .white
            lbl.font = UIFont.systemFont(ofSize: 18.0)
            lbl.textAlignment = .center
            
            imageView.addSubview(lbl)
            self.scrView.addSubview(imageView)
            self.view.bringSubviewToFront(nextButton)
        }
        
        let width1 = (Float(arrImags.count) * Float(self.view.frame.size.width))
        scrView.contentSize = CGSize(width: CGFloat(width1), height: self.view.frame.size.height)
        self.scrView.contentSize.height = 1.0 // disable vertical scroll
        self.view.insertSubview(scrView, at: 0)
        self.pageControl.addTarget(self, action: #selector(self.pageChanged(sender:)), for: UIControl.Event.valueChanged)
        self.view.addSubview(pageControl)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width: CGFloat = scrollView.frame.size.width
        let page: Int = Int((scrollView.contentOffset.x + (0.5 * width)) / width)
        let  pagenumber = Int(page)
        self.pageControl.currentPage = pagenumber;
        
    }
    @objc func pageChanged(sender:AnyObject)
    {
        let xVal = CGFloat(pageControl.currentPage) * scrView.frame.size.width
        scrView.setContentOffset(CGPoint(x: xVal, y: 0), animated: true)
        
    }
    
    @IBAction func nextButton(_ sender: Any) {
        let vc = AppUtils.Controllers.loginVC.get() as! LoginViewController
        self.navigationController?.pushViewController(vc, animated: true)
        return
        
    }
    
}
