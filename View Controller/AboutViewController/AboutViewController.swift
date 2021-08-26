//
//  AboutViewController.swift
//  TrackApp
//
//  Created by sanganan on 11/7/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//

import UIKit


class AboutViewController: UIViewController,UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.commonNavigationBar(title: "AboutKey".localized(), controller: AppUtils.Controllers.aboutVC, badgeCount: "0")
//        let textView = UITextView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
//        textView.textAlignment = .center
//        textView.textColor = .white
//   //     textView.backgroundColor = Constant.Color.backGroundColor
//        textView.text = "Yoga (Sanskrit:योग;Aboutthissoundpronunciation)isagroupofphysicalmentalandspiritualpracticesordisciplineswhichoriginatedinancientIndiaYogaisoneofthesixorthodoxschoolsofHinduphilosophicaltraditionsThereisabroadvarietyofyogaschoolspraticesandgoalsinHinduismBuddhismandJainismTheterm\"yoga\"intheWesternworldoftendenotesamodernformofHathayogayogaasexercisecosistinglargelyoftheposturescalledasanasTheoriginsofyogahavebeenspeculatedtodatebacktopre-VedicIndiantraditionsitismentionedntheRigvedabutmostlikelydevelopedaroundthesixthandfifthcenturiesBCEinancientIndia'sasceticandśramaṇamovementsThechronologyoearliesttextsdescribingyoga-practicesisunclearvaryinglycreditedtoUpanishadsTheYogaSutrasofPatanjalidatefromthefirsthalfofth1stmillenniumCEandgainedprominenceintheWestinthe20thcenturyHathayogatextsemergedsometimesbetweenthe9thand11thcenturywithoriinsintantraYogagurusfromIndialaterintroducedyogatotheWestfollowingthesuccessofSwamiVivekanandainthelate19thandearly20thcentrywithhisadaptationofyogatraditionexcludingasanasOutsideIndiaithasdevelopedintoaposture-basedphysicalfitnessstress-reliefanrelaxationtechniqueYogainIndiantraditionshoweverismorethanphysicalexerciseithasameditativeandspiritualcoreOneofthesixmajororthodoxschoolsofHinduismisalsocalledYogawhichhasitsownepistemologdmetaphysicsandiscloselyrelatedtoHinduSamkhyaphilosophyTheimpactofposturalyogaonphysicalandmentalhealthhasbeenatopicofsysteticstudieswithevidencethatregularyogapracticeyieldsbenefitsforlowbackpainandstressOnDecember12016yogawaslistedbyUNESCOasanintangibleculturalheritageKey".localized()
//        textView.font = UIFont(name: "Helvetica Neue", size: 16.0)
//        self.view.addSubview(textView)
//
//        if UIDevice().userInterfaceIdiom == .phone {
//            switch UIScreen.main.nativeBounds.height {
//            case 1136:
//                let textView = UITextView(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.size.width), height: Int(UIScreen.main.bounds.size.height) ))
//
//            case 1334:
//                let textView = UITextView(frame: CGRect(x: 0, y: 10, width: Int(UIScreen.main.bounds.size.width), height: Int(UIScreen.main.bounds.size.height) ))
//
//
//            case 1920, 2208:
//                let textView = UITextView(frame: CGRect(x: 0, y: 20, width: Int(UIScreen.main.bounds.size.width)-70, height: Int(UIScreen.main.bounds.size.height) ))
//
//
//            case 2436:
//                let textView = UITextView(frame: CGRect(x: 0, y: 30, width: Int(UIScreen.main.bounds.size.width), height: Int(UIScreen.main.bounds.size.height) ))
//
//
//            case 2688:
//                let textView = UITextView(frame: CGRect(x: 0, y: 40, width: Int(UIScreen.main.bounds.size.width), height: Int(UIScreen.main.bounds.size.height) ))
//
//            case 1792:
//                let textView = UITextView(frame: CGRect(x: 0, y: 50, width: Int(UIScreen.main.bounds.size.width), height: Int(UIScreen.main.bounds.size.height) ))
//
//
//            default:
//                print("Unknown")
//            }
//        }

//          let myWebView:UIWebView = UIWebView(frame: CGRect(x: 0, y: 10, width: self.view.frame.width, height: self.view.frame.height))
                webView.delegate = self
                self.view.addSubview(webView)
                let url = URL (string: "http://fishtrackapp.com/faq");
                let request = URLRequest(url: url! as URL);
                webView.loadRequest(request);


            }

            func webViewDidStartLoad(_ webView: UIWebView) {
                Utils.startLoading(self.view)
             //   print("web view start loading")
            }

            func webViewDidFinishLoad(_ webView: UIWebView) {
                Utils.stopLoading()
           //     print("web view load completely")
            }

            func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
                Utils.stopLoading()
           //     print("web view loading fail : ",error.localizedDescription)
            }
        }
        

