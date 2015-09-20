//
//  PagesAsExtension.swift
//  AutomaticPager
//
//  Created by Romain Menke on 20/09/15.
//  Copyright © 2015 menke dev. All rights reserved.
//

import UIKit

protocol Pages {
    
    mutating func getPagesFromTextInChapters(chapters: [String]) -> [[String]]
    
    mutating func getPagesFromText(string : String) -> [String]
    
    var bounds : CGRect { get }
    var textStorage : NSTextStorage { get }
    var text : String! { get set }
    
}

extension Pages {
    
    mutating func getPagesFromTextInChapters(chapters:[String]) -> [[String]] {
        
        var chaptersInPages : [[String]] = []
        
        for i in 0..<chapters.count {
            chaptersInPages.append(getPagesFromText(chapters[i]))
        }
        
        return chaptersInPages
        
    }
    
    mutating func getPagesFromText(string:String) -> [String] {
        
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
    
    private mutating func visibleText() -> String {
        
        let nsString = text as NSString
        
        let visibleText = nsString.substringWithRange(rangeOfVisibleString())
        
        return String(visibleText)
    }
    
    private mutating func seperateStringBasedOnVisibility() -> (currentStrings:String,nextStrings:String) {
        
        let currentVisibleText = visibleText()
        
        var invisibleText = text
        
        let rangeToRemove = invisibleText.rangeOfString(currentVisibleText)
        invisibleText.removeRange(rangeToRemove!)
        
        return (currentVisibleText,invisibleText)
    }
    
}

extension UITextView : Pages {
    
}