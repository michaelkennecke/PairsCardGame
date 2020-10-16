//
//  ViewController.swift
//  Concentration
//
//  Created by Michael Kennecke on 8/15/18.
//  Copyright © 2018 Michael Kennecke. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{

    private lazy var game: Concentration! = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        get {
            return (cardButtons.count + 1) / 2
        }
    }
    
    private(set) var flipCount: Int = 0 {
        didSet
        {
            flipCountLabel.text = "Flips: \(flipCount)"
        } 
    }
    
    var buttonColor: UIColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)

    @IBOutlet private weak var flipCountLabel: UILabel!
 
    @IBOutlet private var cardButtons: [UIButton]!
 
    @IBOutlet private weak var newGameButton: UIButton!
    
    @IBAction private func touchCard(_ sender: UIButton)
    {
        flipCount += 1
        if let cardNumber = cardButtons.index(of: sender)
        {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
        else
        {
            print("chosen card was not in cardButtons")
        }
        
    }
    
    private func updateViewFromModel()
    {
        for index in cardButtons.indices
        {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp
            {
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            }
            else
            {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : buttonColor
            }
        }
    }
    
    //In this case Array<String> is not necessary
    private var emojiChoices: Array<String> = ["👻", "🎃", "🧙🏿‍♂️", "🧛🏻‍♂️", "🕷", "🧟‍♀️", "🍬", "🔮"]
    
    private var emoji = [Card:String]()
    
    private func emoji(for card: Card) -> String
    {
        if emoji[card] == nil
        {
            if emojiChoices.count > 0
            {
                emoji[card] = emojiChoices.remove(at: emojiChoices.count.arc4random)
            }
        }
        return emoji[card] ?? "?"
    }
    
    @IBAction private func startNewGame()
    {
        flipCount = 0
        game = nil
        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
        changeTheme()
    }
    
    private func changeTheme()
    {
        print(colors.count)
        let randomIndex = Int(arc4random_uniform(UInt32(colors.count)))
    
        for (kind, theme) in themes
        {
            if kind == randomIndex
            {
                emojiChoices = theme
                break
            }
        }
        for i in 0...colors.count-1
        {
            if i == randomIndex
            {
                for index in cardButtons.indices{
                    let button = cardButtons[index]
                    button.setTitle("", for: UIControlState.normal)
                    button.backgroundColor = colors[i]
                }
                newGameButton.backgroundColor = colors[i]
                buttonColor = colors[i]
                break
            }
        }
    }
    
    private var colors: [UIColor] = [#colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1), #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)]
    
    private var themes: [Int: [String]] =
    [
        0: ["👻", "🎃", "🧙🏿‍♂️", "🧛🏻‍♂️", "🕷", "🧟‍♀️", "🍬", "🔮"],
        1: ["🐘", "🦒", "🐊", "🦈", "🐒", "🐅", "🐳", "🦓"]
    ]
    
}

extension Int {
    var arc4random: Int {
        if self > 0 {
             return  Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
        
    }
}

