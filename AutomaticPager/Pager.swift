//
//  PagerClass.swift
//  AutomaticPager
//
//  Created by Romain Menke on 20/09/15.
//  Copyright © 2015 menke dev. All rights reserved.
//

import Foundation

import UIKit

// REMINDER :
//    String => Sentence
//   [String] => Page
//  [[String]] => Chapter
// [[[String]]] => Document

class Pager : UITextView {
    
    // PUBLIC
    
    var pages : [[String]] = [] // text as pages
    var chapters : [[[String]]] = [] // text as pages with chapters
    var delimiters : [String] = [".","?",",","!",":",";"] // default punctuation to use for splitting text into sentences
    
    
    // PRIVATE
    
    internal var boxedContainer : NSTextContainer // constrained text container
    internal var boxedLayout : NSLayoutManager // constrained text layout
    
    var chaptersInSentences : [[[String]]] = []
    var pagesInSentences : [[String]] = []
    
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
    
}


// BASE

extension Pager {
    
    func setPagesFromText(chapters chapters_I:[String]) {
        
        let chaptersInSenteces = splitChaptersIntoSentences(chapters_I)
        chapters = getPagesFromTextInChapters(chapters: chaptersInSenteces)
        pages = chapters.flatMap { $0 }
        
    }

    
    func setPagesFromText(chaptersInSentences chapters_I:[[String]]) {
        
        chapters = getPagesFromTextInChapters(chapters: chapters_I)
        pages = chapters.flatMap { $0 }
        
    }
    
}




// SPLIT IN PAGES


extension Pager {

    
    private func getPagesFromTextInChapters(chapters chapters_I:[[String]]) -> [[[String]]] {
        
        var chaptersInPages : [[[String]]] = []
        
        for i in 0..<chapters_I.count {
            chaptersInPages.append(getPagesFromText(pages: chapters_I[i]))
        }
        
        return chaptersInPages
        
    }
    
    private func getPagesFromText(pages string_I:[String]) -> [[String]] {
        
        var tempString = string_I
        
        text = string_I.reduce("") { $0 + $1 } // set text
        
        var pages : [[String]] = []
        
        repeat {
            let seperatedString = seperateStringBasedOnVisibility(tempString)
            tempString = seperatedString.outOfBoundsString
            var visibleString = seperatedString.visibleString
            
            if (visibleString[0] as NSString).substringToIndex(2) == "\r" {
                visibleString[0] = (visibleString[0] as NSString).substringFromIndex(2)
            }
            
            pages.append(seperatedString.visibleString)
            text = seperatedString.outOfBoundsString.reduce("") { $0 + $1 }
        } while text.characters.count != 0
        
        return pages
    }
    
    private func buildPageSentences(visibleText visibleText_I: String, fullText: [String]) -> [String] {
        
        var visibleSentences : [String] = []
        var sentenceCounter : Int = 0
        
        while visibleText_I.containsString(fullText[sentenceCounter]) {
            
            visibleSentences.append(fullText[sentenceCounter])
            sentenceCounter += 1
            
        }
        
        return visibleSentences
    }
    
}




// ADD PAGER TRAITS

extension Pager: SentenceBuilder, VisibleText {
    
}
