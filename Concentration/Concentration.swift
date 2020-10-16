//
//  Concentration.swift
//  Concentration
//
//  Created by Michael Kennecke on 8/19/18.
//  Copyright © 2018 Michael Kennecke. All rights reserved.
//

import Foundation

struct Concentration
{
    var unshuffled = Array<Card>()
    private(set) var cards = Array<Card>()
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            let faceUpCardIndices = cards.indices.filter { cards[$0].isFaceUp }
            return faceUpCardIndices.count == 1 ? faceUpCardIndices.first : nil 
            
//            var foundIndex: Int?
//            for index in cards.indices {
//                if cards[index].isFaceUp {
//                    if foundIndex == nil {
//                        foundIndex = index
//                    } else {
//                        return nil
//                    }
//                }
//            }
//            return foundIndex
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    mutating func chooseCard(at index: Int)
    {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
        if !cards[index].isMatched
        {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index
            {
                if cards[matchIndex] == cards[index]
                {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
            }
            else
            {
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int)
    {
        assert(numberOfPairsOfCards > 0, "Concentration.init(at: \(numberOfPairsOfCards)): you must have at least one pair of cards")

        for _ in 1...numberOfPairsOfCards
        {
            let card = Card()
            unshuffled.append(card)
            unshuffled.append(card)
        }
        
        //shuffle the cards
        for _ in 0...(unshuffled.count-1)
        {
            let randomIndex = Int(arc4random_uniform(UInt32(unshuffled.count)))
            cards.append(unshuffled[randomIndex])
            unshuffled.remove(at: randomIndex)
        }
    }
    
}
