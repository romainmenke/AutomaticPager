//
//  PagerClass.swift
//  AutomaticPager
//
//  Created by Romain Menke on 20/09/15.
//  Copyright © 2015 menke dev. All rights reserved.
//

import Foundation

import UIKit

class Pager : UITextView {
    
    // PUBLIC
    
    var pages : [String] = [] // text as pages
    var chapters : [[String]] = [] // text as pages with chapters
    var delimiters : [String] = [".","?",",","!",":",";"] // default punctuation to use for splitting text into sentences
    
    
    // PRIVATE
    
    internal var boxedContainer : NSTextContainer // constrained text container
    internal var boxedLayout : NSLayoutManager // constrained text layout
    
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
    
    func setPagesFromTextInChapters(chapters:[String]) {
        
        self.chapters = getPagesFromTextInChapters(chapters)
        self.pages = chapters.flatMap { $0 }
        
    }
    
    func setPagesFromText(string:String) {
        
        self.pages = getPagesFromText(string)
        self.chapters = [self.pages]
        
    }
    
}


// BRIDGE FROM STRING TO [STRING]

extension Pager {
    
    
    
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




// ADD PAGER TRAITS

extension Pager: PageFinder, SentenceBuilder, VisibleText {
    
}
