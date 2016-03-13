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
    var isCardsAvailable = [Bool]()
    
    // All available cards
    var cardsInDeck = [String]()
    // cards already choosen
    var cardsChoosen = [String]()
    
    // Nb stack card (0,1 or 2)
    var cardsStack = [Int]()
    
    var nameDealer : String = ""
    var namePlayer :String = ""
    var idDealer : Int = -1
    var idPlayer : Int = 1
    var nbPlayers : Int = -1
    
    // Card of the dealer (eg. Hearts 9)
    var dealerCard : String = ""
    // Card of the Gamer (eg. 9)
    var gamerCard : String = ""
    // Value of the round (0 when the gamer didn't selected card, and 1 after the first choice)
    var nbRoundGamer : Int = 0
    var nbDealerWin : Int = 0
    
    var managedContext = NSManagedObjectContext()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionCards.delegate = self
        self.collectionCards.dataSource = self
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        managedContext = appDelegate.managedObjectContext
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(1, forKey: "isGaming")
        
        // Create array of card
        self.fillCardsArrayInit()
        self.fillCardsValueInit()
        self.isCardsAvailableInit()
        self.cardsStackInit()
        self.cardInDeckInit()
        self.getNbPlayer()
        self.getDealer()
        self.playerNameSetter(idPlayer)
        
    }
    
    func getNbPlayer(){
        
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
        
        let fetchRequest = NSFetchRequest(entityName: "Players")
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let players = results as! [Players]
            self.nameDealer = players[idDealer].name
            self.dealerName.text = "Dealer name : \(nameDealer)"
        } catch {
            let fetchError = error as NSError
            NSLog(fetchError.debugDescription)
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
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let players = results as! [Players]
            self.namePlayer = players[idPlayer].name
            self.playerName.text = "Player name : \(namePlayer)"
        } catch {
            let fetchError = error as NSError
            NSLog(fetchError.debugDescription)
        }
    }
    
    
    func isCardsAvailableInit(){
        for _ in 1...13 {
            self.isCardsAvailable += [true]
        }
    }
    
    func cardsStackInit() {
        for _ in 1...13 {
            self.cardsStack += [0]
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
        
        cell.imageCard.alpha = 1
        
        if (cardsStack[indexPath.row] == 0) {
            cell.imageCard.alpha = 0.3
        } else if cardsStack[indexPath.row] == 3 {
            cell.imageCard.image = UIImage(named: "Back")
        }
        
        if (!isCardsAvailable[indexPath.row]) {
            cell.imageCard.alpha = 1
            cell.imageCard.image = UIImage(named: "Back")
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        NSLog("\(__FUNCTION__) BEGIN")
        NSLog("GVC - Card cell #\(indexPath.row) selected")
        
        if (nbRoundGamer == 0) {
            // First choice
            nbRoundGamer = 1
            
            // Draw a card
            self.drawCard()
            
            let dealerCardNumber = convertCardToNumber (self.dealerCard)
            NSLog("GVC - DealerCard = \(dealerCardNumber)")
            
            self.gamerCard = self.cardsValue[indexPath.row]
            let gamerCardNumber = convertCardToNumber (self.gamerCard)
            NSLog("GVC - Gamer Card = \(gamerCardNumber)")
            
            // Compare card : dealer card and gamer card
            let compareResult = self.compareCards(dealerCardNumber, gamerCardNumber: gamerCardNumber)
            
            if compareResult == 0 {
                // The gamer win in the first choice
                // TODO win function
                self.nbDealerWin = 0
                self.nbRoundGamer = 0
                
                // Set cardStack
                // Delete card in inDeck array
                // Add card in ChoosenArray
                
                // Alert
                self.displayAlert("\(self.namePlayer) win !", text: "\(self.nameDealer) must drink 5 swallows !")
                
            } else if compareResult == -1 {
                self.disableCardSecondRound(gamerCardNumber - 1, way: false)
            } else if compareResult == 1 {
                self.disableCardSecondRound(gamerCardNumber - 1, way: true)
            }
            
        } else {
            // End game
            nbRoundGamer = 0
            
            let dealerCardNumber = convertCardToNumber (self.dealerCard)
            NSLog("GVC - DealerCard = \(dealerCardNumber)")
            
            self.gamerCard = self.cardsValue[indexPath.row]
            let gamerCardNumber = convertCardToNumber (self.gamerCard)
            NSLog("GVC - Gamer Card = \(gamerCardNumber)")
            
            // Compare card : dealer card and gamer card
            let compareResult = self.compareCards(dealerCardNumber, gamerCardNumber: gamerCardNumber)
            
            if compareResult == 0 {
                // The gamer win in the second choice
                self.nbDealerWin = 0
                // TODO win function
                // Set cardStack
                
                // Alert
                self.displayAlert("\(self.namePlayer) win !", text: "\(self.nameDealer) must drink 3 swallows !")
                
            } else {
                // TODO The dealer win
                self.nbDealerWin += 1
                let nbSwallow = abs(dealerCardNumber - gamerCardNumber)
                var swallows = "swallows"
                
                if (nbSwallow == 1) {
                    swallows = "swallow"
                }
                // Alert
                self.displayAlert("\(self.nameDealer) win !", text: "\(self.namePlayer) must drink \(nbSwallow) \(swallows) !")
            }
        }
        
        
        
        NSLog("\(__FUNCTION__) END")
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
                cardName = "Ace"
            } else if index == 11 {
                // Case JACK
                cardName = "Jack"
            } else if index == 12 {
                // Case QUEEN
                cardName =  "Queen"
            } else if index == 13 {
                // Case KING
                cardName =  "King"
            } else {
                // Case Other Card
                cardName = "\(index)"
            }
            self.cardsValue += [cardName]
        }
        
    }
    
    func cardInDeckInit() {
        NSLog("\(__FUNCTION__) BEGIN")
        let fetchRequest = NSFetchRequest(entityName: "Cards")
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            let cards = results as! [Cards]
            for card in cards {
                let nameCard = "\(card.color) \(card.value)"
                self.cardsInDeck += [nameCard]
                //NSLog("Card in Deck = \(nameCard)")
            }
        } catch {
            let fetchError = error as NSError
            NSLog(fetchError.debugDescription)
        }
        NSLog("\(__FUNCTION__) END")
    }
    
    func drawCard() {
        NSLog("\(__FUNCTION__) BEGIN")
        // Method to draw à card when the gamer click on à card
        let index = arc4random_uniform(UInt32(self.cardsInDeck.count - 1))
        //NSLog("Index choosen = \(index)")
        
        let drawedCard = self.cardsInDeck[Int(index)]
        //NSLog("Card choosen = \(drawedCard)")
        
        // Update Arrays
        self.cardsInDeck.removeAtIndex(Int(index))
        self.cardsChoosen += [drawedCard]
        
        self.dealerCard = drawedCard
        
        NSLog("\(__FUNCTION__) END")
        
    }
    
    func compareCards (dealerCardNumber : Int, gamerCardNumber : Int) -> Int {
        // Return 0 if equal, -1 if it's minus, +1 if it's plus
        
        if (gamerCardNumber < dealerCardNumber){
            return -1
        } else if (gamerCardNumber == dealerCardNumber){
            return 0
        } else {
            return 1
        }
    }
    
    func disableCardSecondRound(index: Int, way: Bool) {
        // Disable card from index, way = false correspond to down and way = true correspond to up
        for i in 0...(isCardsAvailable.count - 1) {
            if way {
                if i >= index {
                    isCardsAvailable[i] = false
                }
            } else {
                if i <= index {
                    isCardsAvailable[i] = false
                }
            }
        }
        
        // Refresh collection
        self.collectionCards.reloadData()
    }
    
    func resetCardAvailable() {
        // Enable all cards
        for i in 0...(isCardsAvailable.count - 1) {
            isCardsAvailable[i] = true
        }
        
        // Refresh collection
        self.collectionCards.reloadData()
        
    }
    
    
    func convertCardToNumber (card: String) -> Int {
        
        let cardArraySplit = card.characters.split{$0 == " "}.map(String.init)
        
        if !cardArraySplit.isEmpty {
            return matchingCardToNumber(cardArraySplit[cardArraySplit.count - 1])
        } else {
            return -1
        }
    }
    
    func matchingCardToNumber (value: String) -> Int {
        if value == "Ace" {
            // Case ACE
            return 1
        } else if value == "Jack" {
            // Case JACK
            return 11
        } else if value == "Queen" {
            // Case QUEEN
            return 12
        } else if value == "King" {
            // Case KING
            return 13
        } else {
            // Case Other Card
            return Int(value)!
        }
        
    }
    
    func displayAlert (title : String, text : String) {
        NSLog("\(__FUNCTION__) BEGIN")
        
        if #available(iOS 8.0, *) {
            let alertController = UIAlertController(title: title, message: text, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Drinked", style: UIAlertActionStyle.Default,handler: { (action: UIAlertAction!) in
                self.resetCardAvailable()
            }))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            // TODO Add Label
            // reset card available
            self.resetCardAvailable()
        }
        
        NSLog("\(__FUNCTION__) END")
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
}
