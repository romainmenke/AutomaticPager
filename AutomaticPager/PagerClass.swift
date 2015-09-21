//
//  PagerClass.swift
//  AutomaticPager
//
//  Created by Romain Menke on 20/09/15.
//  Copyright © 2015 menke dev. All rights reserved.
//

import Foundation

import UIKit

class Pager : UITextView  {
    
    // PUBLIC
    
    var pages : [String] = [] // text as pages
    var chapters : [[String]] = [] // text as pages with chapters
    var delimiters = [".","?",",","!",":",";"] // default punctuation to use for splitting text into sentences
    
    
    // PRIVATE
    
    private var delimiterCount : Int { // went overboard with declarations
        get {
            return delimiters.count
        }
    }
    
    private var boxedContainer : NSTextContainer // constrained text container
    private var boxedLayout : NSLayoutManager // constrained text layout
    
    init(frame: CGRect) {
        
        boxedContainer = NSTextContainer(size: frame.size)
        boxedLayout = NSLayoutManager()
        
        super.init(frame: frame, textContainer: nil)
        
        boxedLayout.addTextContainer(boxedContainer)
        textStorage.addLayoutManager(boxedLayout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setPagesFromTextInChapters(chapters:[String]) {
        
        self.chapters = getPagesFromTextInChapters(chapters)
        self.pages = chapters.flatMap { $0 }
        
    }
    
    func setPagesFromText(string:String) {
        
        self.pages = getPagesFromText(string)
        self.chapters = [self.pages]
        
    }
    
}

// FINDING PAGES

extension Pager {
    
    private func getPageWithString(searchString : String) -> (chapter:Int,page:Int)? {
        
        for chapterID in 0..<chapters.count {
            
            let chapter = chapters[chapterID]
            
            if let pageID = getPageInChapterWithString(searchString, chapter: chapter) {
                
                return (chapter: chapterID, page: pageID)
            }
        }
        return nil
    }
    
    private func getPageInChapterWithString(searchString: String, chapter: [String]) -> Int? {
        
        for pageID in 0..<chapter.count {
            
            let page = chapter[pageID]
            
            if stringIsOnPage(searchString, page: page) {
                return pageID
            }
        }
        return nil
    }
    
    private func stringIsOnPage(searchString : String, page: String) -> Bool {
        
        if page.containsString(searchString) {
            return true
        } else if searchString.containsString(page) {
            return true // rare, nearly impossible case where a page only contains that last half of a string
        } else {
            return false
        }
        
    }
    
    private func getReadRangeOfPage(searchString:String, page:Int, chapter:Int) -> NSRange { // untested
        
        let pageString = chapters[chapter][page] as NSString
        
        let range = pageString.rangeOfString(searchString)
        let rangeEnd = range.length + range.location
        let extendedRange = NSRange(location: 0, length: rangeEnd)
        
        return extendedRange
        
    }
    
}


// CONVER FULL TEXT TO ARRAY BASED ON PUNCTUATION

extension Pager {
    
    func splitString(string: String, delimiter : String) -> [String] {
        
        var splitStrings = string.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: delimiter))
        
        
        for stringID in 0..<(splitStrings.count - 1) {
            splitStrings[stringID] = splitStrings[stringID] + delimiter
        }
        for stringID in 0..<splitStrings.count {
            
            guard splitStrings[stringID].characters.count > 0 && stringID > 0 else {
                continue
            }
            
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
    
    func splitStringIntoSentences(string: String) -> [String] {
        
        var stringArray : [String] = [string]
        
        for delimiterID in 0..<delimiterCount {
            
            let delimiter = delimiters[delimiterID]
            
            var split : [String] = []
            
            for substringID in 0..<stringArray.count {
                
                split += splitString(stringArray[substringID], delimiter: delimiter)
                
            }
            
            stringArray = split
            
        }
        
        return stringArray
    }
}

// SPLIT IN PAGES

extension Pager {
    
    private func getPagesFromTextInChapters(chapters:[String]) -> [[String]] {
        
        var chaptersInPages : [[String]] = []
        
        for i in 0..<chapters.count {
            chaptersInPages.append(getPagesFromText(chapters[i]))
        }
        
        return chaptersInPages
        
    }
    
    private func getPagesFromText(string:String) -> [String] {
        
        text = string // set text
        
        var pages : [String] = []
        
        repeat {
            let seperatedString = seperateStringBasedOnVisibility()
            
            var visibleString = seperatedString.visibleString
            
            if (visibleString as NSString).substringToIndex(2) == "\r" {
                visibleString = (visibleString as NSString).substringFromIndex(2)
            }
            
            pages.append(seperatedString.visibleString)
            text = seperatedString.outOfBoundsString
        } while text.characters.count != 0
        
        return pages
    }
    
}

// DETERMINE WHICH TEXT IS VISIBLE

extension Pager {
    
    private func rangeOfVisibleString() -> NSRange {
        
        return boxedLayout.glyphRangeForTextContainer(boxedContainer)
        
    }
    
    private func visibleText() -> String {
        
        let nsString = text as NSString
        
        let visibleText = nsString.substringWithRange(rangeOfVisibleString())
        
        return String(visibleText)
    }
    
    private func seperateStringBasedOnVisibility() -> (visibleString:String,outOfBoundsString:String) {
        
        let visibleString = visibleText()
        
        var outOfBoundsString = text
        
        let rangeToRemove = outOfBoundsString.rangeOfString(visibleString)
        outOfBoundsString.removeRange(rangeToRemove!)
        
        return (visibleString,outOfBoundsString)
    }
    
}
