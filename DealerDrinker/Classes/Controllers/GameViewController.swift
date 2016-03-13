//
//  GameViewController.swift
//  DealerDrinker
//
//  Created by Benjamin CANTE on 12/03/2016.
//  Copyright © 2016 com.Nivet. All rights reserved.
//

import UIKit
import CoreData

class GameViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var dealerName: UILabel!
    @IBOutlet weak var playerName: UILabel!
    
    
    
    @IBOutlet weak var collectionCards: UICollectionView!
    var cardsArray = [String]()
    var cardsValue = [String]()
    var isInDeck = [Bool]()
    
    var nameDealer : String = ""
    var namePlayer :String = ""
    var idDealer : Int = -1
    var idPlayer : Int = 1
    var nbPlayers : Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionCards.delegate = self
        self.collectionCards.dataSource = self
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(1, forKey: "isGaming")
        
        // Create array of card
        self.fillCardsArrayInit()
        self.fillCardsValueInit()
        self.isInDeckInit()
        self.cardIsInDeck()
        self.getNbPlayer()
        self.getDealer()
        self.playerNameSetter(idPlayer)
        
        
    }
    
    func getNbPlayer(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Stats")
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let stats = results as! [Stats]
            for stat in stats{
                nbPlayers = Int(stat.nbPlayers)
                NSLog("NbPlayer = \(nbPlayers)")
            }
        } catch {
            let fetchError = error as NSError
            NSLog(fetchError.debugDescription)
        }
    }
    
    
    func getDealer() {
        idDealer = Int(arc4random_uniform(UInt32(nbPlayers - 1)))
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Players")
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let players = results as! [Players]
            dealerName.text = "Dealer name : \(players[idDealer].name)"
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        //TODO changer la valeur du champ nbdealer dans la base pour pondérer plus tard !
        
    }
    
    func getPlayer() {
        if (idPlayer == idDealer){
            idPlayer += 1 % (nbPlayers - 1)
        }
    }
    
    func playerNameSetter(idPlayer : Int){
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Players")
        
        //3
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let players = results as! [Players]
            playerName.text = "Player name : \(players[idPlayer].name)"
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    
    func isInDeckInit(){
        for i in 1...13{
            isInDeck += [true]
        }
    }
    
    func cardIsInDeck() {
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Cards")
        
        //3
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let cards = results as! [Cards]
            for card in cards{
                if (card.value == "ace"){
                    if (card.inDeck == false){
                        isInDeck[0] = false
                    }
                }
                if (card.value == "2"){
                    if (card.inDeck == false){
                        isInDeck[1] = false
                    }
                }
                if (card.value == "3"){
                    if (card.inDeck == false){
                        isInDeck[2] = false
                    }
                }
                if (card.value == "4"){
                    if (card.inDeck == false){
                        isInDeck[3] = false
                    }
                }
                if (card.value == "5"){
                    if (card.inDeck == false){
                        isInDeck[4] = false
                    }
                }
                if (card.value == "6"){
                    if (card.inDeck == false){
                        isInDeck[5] = false
                    }
                }
                if (card.value == "7"){
                    if (card.inDeck == false){
                        isInDeck[6] = false
                    }
                }
                if (card.value == "8"){
                    if (card.inDeck == false){
                        isInDeck[7] = false
                    }
                }
                if (card.value == "9"){
                    if (card.inDeck == false){
                        isInDeck[8] = false
                    }
                }
                if (card.value == "10"){
                    if (card.inDeck == false){
                        isInDeck[9] = false
                    }
                }
                if (card.value == "jack"){
                    if (card.inDeck == false){
                        isInDeck[10] = false
                    }
                }
                if (card.value == "queen"){
                    if (card.inDeck == false){
                        isInDeck[11] = false
                    }
                }
                if (card.value == "king"){
                    if (card.inDeck == false){
                        isInDeck[12] = false
                    }
                }
                
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
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
        
        if (isInDeck[indexPath.row]==true){
            cell.imageCard.alpha = 0.3
            
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        NSLog("Card cell #\(indexPath.row) selected")
        
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
    
    func fillCardsValueInit() {
        var cardName = ""
        for index in 1...13 {
            if index == 1 {
                // Case ACE
                cardName = "ace"
            } else if index == 11 {
                // Case JACK
                cardName = "jack"
            } else if index == 12 {
                // Case QUEEN
                cardName =  "queen"
            } else if index == 13 {
                // Case KING
                cardName =  "king"
            } else {
                // Case Other Card
                cardName = "\(index)"
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
