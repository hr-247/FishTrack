//
//  PartnerViewController.swift
//  TrackApp
//
//  Created by Ankit  Jain on 12/02/20.
//  Copyright © 2020 Sanganan. All rights reserved.
//

import UIKit

protocol PartnerDelegate {
    func emojiSelected(emoji : Emoji)
}

class PartnerViewController: UIViewController {

    var emojiArray = [Emoji]()
    var delegate : PartnerDelegate?
    var selectedEmojiArr = [""]
    
    @IBOutlet weak var collectionVIew: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commonNavigationBar(title: "PartnersKey".localized(), controller: AppUtils.Controllers.partnerVC, badgeCount: "0")
     //   self.view.backgroundColor = Constant.Color.backGroundColor
         collectionVIew.register(UINib(nibName: "EmojiCollectionCell", bundle: nil), forCellWithReuseIdentifier: "EmojiCollectionCell")
        self.getEmojiDataFromServer()
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    // MARK: - GetEmojisFromServer
    func getEmojiDataFromServer()
    {
        Utils.startLoading(self.view)
        let url : String = "\(Constant.basicApi)/getAllEmojis"
        Service.sharedInstance.getRequest(Url: url, modalName: PartnerResponseModal.self, completion:{
            (response,Error) in
            DispatchQueue.main.async {
                Utils.stopLoading()
                if response?.Success == 1
                {
                    if let array = response?.Emojis
                    {
                        self.emojiArray = array
                    }
                    self.collectionVIew.reloadData()
                }
            }
        })
    }

}



extension PartnerViewController : UICollectionViewDataSource,UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.emojiArray.count
    }

       
       // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
       {
        let cell : EmojiCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCollectionCell", for: indexPath) as! EmojiCollectionCell
        
        if let url = URL(string: emojiArray[indexPath.item].emojiUrl!)
        {
            cell.imgView.sd_setImage(with:url, placeholderImage: UIImage(named: "user"))

        }
        
        if selectedEmojiArr.contains(emojiArray[indexPath.item]._id!)
        {
            cell.imgView.alpha = 0.5
        }
        else
        {
            cell.imgView.alpha = 1.0
        }
        
           return cell
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedEmojiArr.contains(emojiArray[indexPath.item]._id!)
        {
            return
        }
        self.delegate?.emojiSelected(emoji: emojiArray[indexPath.item])
        self.navigationController?.popViewController(animated: true)
    }
    
}
