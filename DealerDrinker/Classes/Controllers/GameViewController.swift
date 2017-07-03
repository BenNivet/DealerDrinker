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
    
    // Players
    var players = [String]()
    var playersDealer = [Int]()
    
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
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        managedContext = appDelegate.managedObjectContext
        
        let defaults = UserDefaults.standard
        defaults.set(1, forKey: isGamingsettings)
        
        self.initGame()
    }
    
    func initGame() {
        self.fillCardsArrayInit()
        self.fillCardsValueInit()
        self.isCardsAvailableInit()
        self.cardsStackInit()
        self.cardInDeckInit()
        self.getNbPlayer()
        self.getDealerInit()
        self.getPlayerInit()
        self.playerNameSetter(idPlayer)
        self.playersDealerInit()
        self.playersInit()
        self.incrementNbDealer()
        
        self.collectionCards.reloadData()

    }
    
    func restartGame() {
        //Reset all value locally
        self.cardsArray = [String]()
        self.cardsValue = [String]()
        self.isCardsAvailable = [Bool]()
        
        // All available cards
        self.cardsInDeck = [String]()
        // cards already choosen
        self.cardsChoosen = [String]()
        
        // Nb stack card (0,1 or 2)
        self.cardsStack = [Int]()
        
        self.nameDealer = ""
        self.namePlayer = ""
        self.idDealer = -1
        self.idPlayer = 1
        self.nbPlayers = -1
        
        // Players
        self.players = [String]()
        self.playersDealer = [Int]()
        
        self.dealerCard = ""
        self.gamerCard = ""
        self.nbRoundGamer = 0
        self.nbDealerWin = 0
        
        // Reset data in DB
        self.resetDBToRestartGame()
        
        self.initGame()
        
        self.collectionCards.reloadData()
    }
    
    func resetDBToRestartGame() {
        // Reset value Players Table
        let fetchRequestPlayers = NSFetchRequest<NSFetchRequestResult>(entityName: "Players")
        fetchRequestPlayers.includesPropertyValues = false
        // Get results
        do {
            if let fetchResultsPlayers = try managedContext.fetch(fetchRequestPlayers) as? [Players] {
                
                for player in fetchResultsPlayers {
                    player.nbCardsFound = 0
                    player.nbDealer = 0
                    player.nbGiven = 0
                    player.nbReceived = 0
                    try player.managedObjectContext?.save()
                }
            }
        } catch let error as NSError  {
            NSLog("Could not save \(error)")
        }
        
        // Reset value Cards Table
        let fetchRequestCards = NSFetchRequest<NSFetchRequestResult>(entityName: "Cards")
        fetchRequestCards.includesPropertyValues = false
        // Get results
        do {
            if let fetchResultsCards = try managedContext.fetch(fetchRequestCards) as? [Cards] {
                for card in fetchResultsCards {
                    card.inDeck = true
                    try card.managedObjectContext?.save()
                }
            }
        } catch let error as NSError  {
            NSLog("Could not save \(error)")
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError  {
            NSLog("Could not save \(error)")
        }
    }
    
    
    func getNbPlayer(){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Stats")
        do {
            let results = try managedContext.fetch(fetchRequest)
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
    
    
    func getDealerInit() {
        self.idDealer = Int(arc4random_uniform(UInt32(nbPlayers)))
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Players")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            let players = results as! [Players]
            self.nameDealer = players[self.idDealer].name
            self.dealerName.text = "Dealer name : \(self.nameDealer)"
            
        } catch {
            let fetchError = error as NSError
            NSLog(fetchError.debugDescription)
        }
    }
    
    func getPlayerInit() {
        if (idPlayer == idDealer){
            idPlayer += 1
            if idPlayer == nbPlayers {
                idPlayer = 0
            }
        }
    }
    
    func playerNameSetter(_ idPlayer : Int){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Players")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            let players = results as! [Players]
            self.namePlayer = players[idPlayer].name
            self.playerName.text = "Player name : \(namePlayer)"
        } catch {
            let fetchError = error as NSError
            NSLog(fetchError.debugDescription)
        }
    }
    
    func namesSetter(){

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Players")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            let players = results as! [Players]
            
            // Set namePlayer
            self.namePlayer = players[idPlayer].name
            self.playerName.text = "Player name : \(namePlayer)"
            
            // Set nameDealer
            self.nameDealer = players[idDealer].name
            self.dealerName.text = "Dealer name : \(nameDealer)"
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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 13 Cards differents => 13 Cells
        return cardsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: CardCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! CardCollectionViewCell
        
        cell.imageCard.image = UIImage(named: cardsArray[indexPath.row])
        
        cell.imageCard.alpha = 1
        
        if (cardsStack[indexPath.row] == 0) {
            cell.imageCard.alpha = 0.3
        } else if cardsStack[indexPath.row] == 4 {
            cell.imageCard.image = UIImage(named: "Back")
        }
        
        if (!isCardsAvailable[indexPath.row]) {
            cell.imageCard.alpha = 1
            cell.imageCard.image = UIImage(named: "Back")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NSLog("\(#function) BEGIN")
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

                // Alert
                self.displaySipsAlert(false, nbSips: 5)
                
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
        
                // Alert
                self.displaySipsAlert(false, nbSips: 3)
                
            } else {
                // TODO The dealer win
                self.nbDealerWin += 1
                let nbSips = abs(dealerCardNumber - gamerCardNumber)

                // Alert
                self.displaySipsAlert(true, nbSips: nbSips)

            }
        }
        NSLog("\(#function) END")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        let widthScreen = UIScreen.main.bounds.size.width
        // Screen Size
        if (widthScreen == 736){
            return CGSize(width: 92, height: 136)
        } else if (widthScreen == 667){
            return CGSize(width: 82, height: 121)
        }else {
            return CGSize(width: 68, height: 100)
        }
        
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
                cardName = prefixCardName + "King"
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
        NSLog("\(#function) BEGIN")
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cards")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            let cards = results as! [Cards]
            for card in cards {
                if card.inDeck {
                    let nameCard = "\(card.color) \(card.value)"
                    self.cardsInDeck += [nameCard]
                    //NSLog("Card in Deck = \(nameCard)")
                } else {
                    let nameCard = "\(card.color) \(card.value)"
                    self.cardsChoosen += [nameCard]
                    //NSLog("Card already chosen = \(nameCard)")
                }

                /*if card.value == "8" {
                    let nameCard = "\(card.color) \(card.value)"
                    self.cardsInDeck += [nameCard]
                }*/
            }
        } catch {
            let fetchError = error as NSError
            NSLog(fetchError.debugDescription)
        }
        NSLog("\(#function) END")
    }
    
    func drawCard() {
        NSLog("\(#function) BEGIN")
        // Method to draw à card when the gamer click on à card
        let index = Int(arc4random_uniform(UInt32(self.cardsInDeck.count)))
        //NSLog("Index choosen = \(index)")
        
        let drawedCard = self.cardsInDeck[index]
        //NSLog("Card choosen = \(drawedCard)")
        
        self.dealerCard = drawedCard
        
        NSLog("\(#function) END")
        
    }
    
    func compareCards (_ dealerCardNumber : Int, gamerCardNumber : Int) -> Int {
        // Return 0 if equal, -1 if it's minus, +1 if it's plus
        
        if (gamerCardNumber < dealerCardNumber){
            return -1
        } else if (gamerCardNumber == dealerCardNumber){
            return 0
        } else {
            return 1
        }
    }
    
    func disableCardSecondRound(_ index: Int, way: Bool) {
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
    
    
    func convertCardToNumber (_ card: String) -> Int {
        
        let cardArraySplit = card.characters.split{$0 == " "}.map(String.init)
        
        if !cardArraySplit.isEmpty {
            return matchingCardToNumber(cardArraySplit[cardArraySplit.count - 1])
        } else {
            return -1
        }
    }
    
    func getStringCardValue(_ card: String) -> String {
        var value = ""
        let cardArraySplit = card.characters.split{$0 == " "}.map(String.init)
        
        if !cardArraySplit.isEmpty {
            value = cardArraySplit[cardArraySplit.count - 1]
        }
        return value
    }
    
    func matchingCardToNumber (_ value: String) -> Int {
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
    
    func displaySipsAlert (_ isDealerWin : Bool, nbSips : Int) {
        NSLog("\(#function) BEGIN")
        
        var titleAlert = ""
        var descriptionAlert = ""
        let buttonLabel = "Drinked"
        
        var sips = "sips"
        if nbSips == 1 {
            sips = "sip"
        }
        
        if (isDealerWin) {
            titleAlert = "\(self.nameDealer) wins !"
            descriptionAlert = "\(self.namePlayer) has to drink \(nbSips) \(sips) !"
        }else{
            titleAlert = "\(self.namePlayer) wins !"
            descriptionAlert = "\(self.nameDealer) has to drink \(nbSips) \(sips) !"
        }
        
        if #available(iOS 8.0, *) {
            let alertController = UIAlertController(title: titleAlert, message: descriptionAlert, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: buttonLabel, style: UIAlertActionStyle.default,handler: { (action: UIAlertAction!) in
                
                // TODO Update sips drinked locally and in DB
                
                self.endRound()
            }))
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            // TODO Add Label
            // reset card available
            self.resetCardAvailable()
        }
        
        NSLog("\(#function) END")
    }
    
    func playersDealerInit() {
        for i in 1...self.nbPlayers {
            if i == idDealer {
                self.playersDealer += [1]
            }else{
                self.playersDealer += [0]
            }
        }
    }
    
    func playersInit() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Players")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            let players = results as! [Players]
            for player in players {
                self.players += [player.name]
            }
        } catch {
            let fetchError = error as NSError
            NSLog(fetchError.debugDescription)
        }
    }
    
    func determineDealerPotential() -> (nbDealerPotentiel: Int, dealerPotentielArray: [Int]){
        //Recuperation du nb deal min
        var nbDealerMin = 0
        for i in 0...playersDealer.count - 1 {
            if i == 0 {
                nbDealerMin = playersDealer[i]
            } else {
                if (playersDealer[i] < nbDealerMin) {
                    nbDealerMin = playersDealer[i]
                }
            }
        }
        
        var nbDealerPotentiel = 0
        var dealerPotentielArray = [Int]()
        
        for i in 0...playersDealer.count - 1 {
            if (nbDealerMin == playersDealer[i]){
                nbDealerPotentiel += 1
                dealerPotentielArray += [i]
            }
        }
        
        return (nbDealerPotentiel, dealerPotentielArray)
        
    }
    
    func findDealer(){
        // Get dealer
        var nbDealerPotentiel = 0
        var dealerPotentielArray = [Int]()
        
        (nbDealerPotentiel, dealerPotentielArray) = self.determineDealerPotential()
        
        let index = Int(arc4random_uniform(UInt32(nbDealerPotentiel)))
        
        self.idDealer = dealerPotentielArray[index]
        
        // Set the number of wins to 0
        self.nbDealerWin = 0
    }
    
    func findPlayer() {
        idPlayer += 1
        if idPlayer == nbPlayers {
            idPlayer = 0
        }
        if (idPlayer == idDealer){
            idPlayer += 1
            if idPlayer == nbPlayers {
                idPlayer = 0
            }
        }
        
        NSLog("IdPlayer = \(idPlayer)")
    }
    
    func endRound() {
        // MAJ Cards HMI
        self.changeCardsHMI()
        
        // MAJ Cards Datas
        self.updateCardsAfterRound()
        
        if self.cardsInDeck.isEmpty {
            self.displayEndGameAlert()
        } else {
            if (self.nbDealerWin == 3) {
                // The dealer must change
                self.incrementNbDealer()
                self.findDealer()
                self.findPlayer()
                self.namesSetter()
            } else {
                self.findPlayer()
                self.namesSetter()
            }
        }
    }
    
    func incrementNbDealer() {
        // Update the number of the deal locally
        self.playersDealer[idDealer] += 1
        
        // Update the number of the deal in DB
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Players")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            let players = results as! [Players]
            let player = players[idDealer]
            player.nbDealer += 1
            
            try player.managedObjectContext?.save()
            // Save
            try managedContext.save()
        } catch {
            let fetchError = error as NSError
            NSLog(fetchError.debugDescription)
        }
    }
    
    func updateCardsAfterRound() {
        // Find index of card drawed at the end of the round
        let index = self.convertCardToNumber(self.dealerCard) - 1
        
        // Update cards stack
        self.cardsStack[index] += 1
        
        // Update cards array
        for i in 0...(self.cardsInDeck.count - 1) {
            if self.cardsInDeck[i] == self.dealerCard {
                // Remove the card in deck array
                self.cardsInDeck.remove(at: i)
                
                // Add the card in cards choosen array
                self.cardsChoosen += [self.dealerCard]
                
                // Exit of the loop
                break
            }
        }
        
        // Update cards in DB
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cards")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            let cards = results as! [Cards]
            for card in cards {
                let nameCard = "\(card.color) \(card.value)"
                if nameCard == self.dealerCard {
                    card.inDeck = false
                    try card.managedObjectContext?.save()
                    break
                }
            }
        } catch {
            let fetchError = error as NSError
            NSLog(fetchError.debugDescription)
        }
        
    }
    
    func changeCardsHMI() {
        self.resetCardAvailable()
        
        // Find index of card drawed at the end of the round
        let index = convertCardToNumber(self.dealerCard) - 1
        
        // Change card in field
        self.cardsArray[index] = self.dealerCard
        self.cardsValue[index] = self.getStringCardValue(self.dealerCard)
        
    }
    
    func displayBackAlert() {
        let titleAlert = "Exit ?"
        let buttonLabel = "OK"
        
        if #available(iOS 8.0, *) {
            let alertController = UIAlertController(title: titleAlert, message: nil, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: buttonLabel, style: UIAlertActionStyle.default,handler: { (action: UIAlertAction!) in
                
                // Change controller
                NSLog("GVC - Back to home")
                
                // Go to Home Controller
                self.performSegue(withIdentifier: backToHomeFromGameSegue, sender: nil)
                
            }))
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            // Go to Home Controller
            self.performSegue(withIdentifier: backToHomeFromGameSegue, sender: nil)
        }
    }
    
    func displayEndGameAlert() {
        let titleAlert = "Finish !"
        let descriptionAlert = "The game is over !"
        let buttonLabel = "OK"
        
        if #available(iOS 8.0, *) {
            let alertController = UIAlertController(title: titleAlert, message: descriptionAlert, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: buttonLabel, style: UIAlertActionStyle.default,handler: { (action: UIAlertAction!) in
                
                // Change controller
                NSLog("GVC - The game is finished")
                
                // Restart game
                self.restartGame()
                
                // Go to statsController
                self.performSegue(withIdentifier: finishedGameSegue, sender: nil)
                
            }))
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            // Go to statsController
            self.performSegue(withIdentifier: finishedGameSegue, sender: nil)
        }
    }
    
    // MARK: - Navigation
    @IBAction func backToHome(_ sender: Any) {
        displayBackAlert()
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == finishedGameSegue {
            // TODO pass data to finished game page
            
        }
    }
    
}
