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
    
    var pages : [String] = []
    var chapters : [[String]] = []
    
    
    func setPagesFromTextInChapters(chapters:[String]) {
        
        self.chapters = getPagesFromTextInChapters(chapters)
        self.pages = chapters.flatMap { $0 }
        
    }
    
    func setPagesFromText(string:String) {
        
        self.pages = getPagesFromText(string)
        self.chapters = [self.pages]
        
    }
    
    
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
            
            var visibleString = seperatedString.currentStrings
            
            if (visibleString as NSString).substringToIndex(2) == "\r" {
                visibleString = (visibleString as NSString).substringFromIndex(2)
            }
            
            pages.append(seperatedString.currentStrings)
            text = seperatedString.nextStrings
        } while text.characters.count != 0
        
        return pages
    }
    
    private func rangeOfVisibleString() -> NSRange {
        
        let container = NSTextContainer(size: bounds.size)
        let layout = NSLayoutManager()
        layout.addTextContainer(container)
        textStorage.addLayoutManager(layout)
        
        return layout.glyphRangeForTextContainer(container)
        
    }
    
    private func visibleText() -> String {
        
        let nsString = text as NSString
        
        let visibleText = nsString.substringWithRange(rangeOfVisibleString())
        
        return String(visibleText)
    }
    
    private func seperateStringBasedOnVisibility() -> (currentStrings:String,nextStrings:String) {
        
        let currentVisibleText = visibleText()
        
        var invisibleText = text
        
        let rangeToRemove = invisibleText.rangeOfString(currentVisibleText)
        invisibleText.removeRange(rangeToRemove!)
        
        return (currentVisibleText,invisibleText)
    }
    
}
