//
//  SentenceBuilder.swift
//  AutomaticPager
//
//  Created by Romain Menke on 21/09/15.
//  Copyright © 2015 menke dev. All rights reserved.
//

import UIKit


// CONVER FULL TEXT TO ARRAY BASED ON PUNCTUATION

protocol SentenceBuilder {
    
    var delimiters : [ String] { get }
    
}

extension SentenceBuilder {
    
    func splitChaptersIntoSentences(chapters: [String]) -> [[String]] {
        
        var chaptersInSentences : [[String]] = []
        
        for i in 0..<chapters.count {
            
            chaptersInSentences.append(splitStringIntoSentences(chapters[i]))
            
        }
        
        return chaptersInSentences
        
    }
    
    func splitStringIntoSentences(string: String) -> [String] {
        
        var stringArray : [String] = [string]
        
        for delimiterID in 0..<delimiters.count {
            
            let delimiter = delimiters[delimiterID]
            var split : [String] = []
            
            for substringID in 0..<stringArray.count {
                split += splitString(stringArray[substringID], delimiter: delimiter)
            }
            
            stringArray = split
        }
        
        return stringArray
    }
    
    func splitString(string: String, delimiter : String) -> [String] {
        
        var splitStrings = string.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: delimiter))
        
        
        for stringID in 0..<(splitStrings.count - 1) {
            splitStrings[stringID] = splitStrings[stringID] + delimiter
        }
        for stringID in 0..<splitStrings.count {
            
            guard splitStrings[stringID].characters.count > 0 && stringID > 0 else {
                continue
            }
            
            // clean up : make sure returns and spaces are at the end of sentences
            
            let firstLetter = (splitStrings[stringID] as NSString).substringToIndex(1)
            
            if firstLetter == " " {
                splitStrings[stringID] = (splitStrings[stringID] as NSString).substringFromIndex(1)
                splitStrings[(stringID - 1)] += " "
            }
            
            let firstTwoLetters = (splitStrings[stringID] as NSString).substringToIndex(2)
            
            if firstTwoLetters == "\r" {
                splitStrings[stringID] = (splitStrings[stringID] as NSString).substringFromIndex(2)
                splitStrings[(stringID - 1)] += " \r"
            }
            
        }
        
        
        return splitStrings
    }
}