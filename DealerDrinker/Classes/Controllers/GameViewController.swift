//
//  GameViewController.swift
//  DealerDrinker
//
//  Created by Benjamin CANTE on 12/03/2016.
//  Copyright © 2016 com.Nivet. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionCards: UICollectionView!
    var cardsArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionCards.delegate = self
        self.collectionCards.dataSource = self
        
        // Create array of card
        self.fillCardsArrayInit()
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - CollectionView Protocol
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 13 Cards differents => 13 Cells
        return 13
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell: CardCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("cardCell", forIndexPath: indexPath) as! CardCollectionViewCell
        
        cell.imageCard.image = UIImage(named: cardsArray[indexPath.row])
        
        cell.imageCard.alpha = 0.3
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        NSLog("Course cell #\(indexPath.row) selected")
        
    }
    
    func fillCardsArrayInit() {
        let prefixCardName = "Hearts "
        var cardName = ""
        for index in 1...13 {
            if index == 1 {
                // Case ACE
                cardName = prefixCardName + "Ace"
            } else if index == 11 {
                // Case JACK
                cardName = prefixCardName + "Jack"
            } else if index == 12 {
                // Case QUEEN
                cardName = prefixCardName + "Queen"
            } else if index == 13 {
                // Case KING
                cardName = prefixCardName + "king"
            } else {
                // Case Other Card
                cardName = prefixCardName + "\(index)"
            }
            self.cardsArray += [cardName]
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
