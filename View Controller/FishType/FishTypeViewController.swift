//
//  FishTypeViewController.swift
//  TrackApp
//
//  Created by Ankit  Jain on 20/02/20.
//  Copyright © 2020 Sanganan. All rights reserved.
//

import UIKit

protocol FishTypeDelegate {
    func fishesSelected(fishesIds : [String], fishesName :[String])
}

class FishTypeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var fishModal = FishTypeModal()
    var fishArray = [Fish]()
    var tempFishArray = [Fish]()
    var selectedFishIds = [String]()
    var selectedFishNames = [String]()

    var delegate : FishTypeDelegate?
    
    
    
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var searchTxtFld: UITextField!
    @IBOutlet weak var searchView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUI()
        self.getFishDataFromServer()
        // Do any additional setup after loading the view.
    }

    
    func setUI()
    {
        self.searchView.backgroundColor = Constant.Color.navColor
      //  self.searchTxtFld.placeholder = "SearchKey".localized()
        self.tblView.register(UINib(nibName: "FishTypeCell", bundle: nil), forCellReuseIdentifier: "FishTypeCell")
          self.tblView.estimatedRowHeight = 50
          self.tblView.tableFooterView = UIView.init(frame: .zero)
        self.commonNavigationBar(title: "FishKey".localized(), controller: AppUtils.Controllers.fishType, badgeCount: "0")
      //    self.view.backgroundColor = Constant.Color.backGroundColor
        NotificationCenter.default.addObserver(self, selector: #selector(addFishTapped(_:)), name: NSNotification.Name(rawValue:"AddFish"), object: nil)
        
        self.searchTxtFld.placeholder = "SearchKey".localized()
        self.searchTxtFld.placeHolderColor = UIColor.white
        
        let viw = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 35))
        self.searchTxtFld.leftViewMode = .always
        self.searchTxtFld.leftView = viw
        
    }
    
    @objc func addFishTapped(_ notifi: NSNotification)
    {
        if selectedFishIds.count == 0 {
            AppUtils.showToast(message: "Track_017".localized())
            return
        }
        self.delegate?.fishesSelected(fishesIds: selectedFishIds, fishesName: selectedFishNames)
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - API

    func getFishDataFromServer()
    {
        Utils.startLoading(self.view)
        let url : String = "\(Constant.basicApi)/allFishList"
        Service.sharedInstance.getRequest(Url: url, modalName: FishTypeModal.self, completion:{
            (response,Error) in
            DispatchQueue.main.async {
                Utils.stopLoading()
                if response?.Success == 1
                {
                    if let array = response?.Fishes
                    {
                        self.fishArray = array
                        self.tempFishArray = array
                    }
                    self.tblView.reloadData()
                }
            }
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK:- TABLE VIEW
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fishArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : FishTypeCell = tableView.dequeueReusableCell(withIdentifier: "FishTypeCell", for: indexPath) as! FishTypeCell
        
        cell.lbl.text = fishArray[indexPath.row].fishName!
     //   cell.contentView.backgroundColor = Constant.Color.backGroundColor
        if selectedFishIds.contains(fishArray[indexPath.row]._id!) {
            cell.tickImgView.isHidden = false
        }else
        {
            cell.tickImgView.isHidden = true
        }

        return cell
    }
    //MARK:- TABLEVIEW DIDSELECT ROWAT
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedFishIds.contains(fishArray[indexPath.row]._id!) {
           // remove
            selectedFishIds.removeAll { (idStr) -> Bool in
                return idStr == fishArray[indexPath.row]._id!
            }
            selectedFishNames.removeAll { (name) -> Bool in
                           return name == fishArray[indexPath.row].fishName!
            }
            
        }else
        {
            selectedFishIds.append(fishArray[indexPath.row]._id!)
            selectedFishNames.append(fishArray[indexPath.row].fishName!)
        }
        
        tableView.reloadData()
        
    }
}

extension FishTypeViewController : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
            with: string)
            //updatedText = updatedText.trimmingCharacters(in: .whitespacesAndNewlines)
                  if updatedText != ""
                  {
                    fishArray = tempFishArray.filter({ (fish) -> Bool in
                        return fish.fishName?.range(of: updatedText, options: .caseInsensitive, range: nil, locale: nil) != nil
                        //rangeOfString(updatedText, options: .CaseInsensitiveSearch) != nil
                        
                    })
                    
                   
//
//                    let resultPredicate = NSPredicate(format: "fishName contains[c] %@", updatedText)
//
//                    fishArray = tempFishArray.filter{ resultPredicate.evaluate(with: $0) }
                    
                    self.tblView.reloadData()

                    
                    
                    
                  }else{
                      self.fishArray = tempFishArray
                      self.tblView.reloadData()                  }
                   
               }else
               {
                   self.fishArray = tempFishArray
                self.tblView.reloadData()
               }
        return true
    }
}
