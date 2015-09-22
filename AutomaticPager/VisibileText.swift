//
//  VisibileText.swift
//  AutomaticPager
//
//  Created by Romain Menke on 21/09/15.
//  Copyright © 2015 menke dev. All rights reserved.
//

import UIKit


// DETERMINE WHICH TEXT IS VISIBLE

protocol VisibleText {
    
    var text : String! { get set }
    var boxedContainer : NSTextContainer { get }
    var boxedLayout : NSLayoutManager { get }
    
}

extension VisibleText {
    
    func rangeOfVisibleString() -> NSRange {
        
        return boxedLayout.glyphRangeForTextContainer(boxedContainer)
        
    }
    
    func visibleText() -> String {
        
        let nsString = text as NSString
        
        let visibleText = nsString.substringWithRange(rangeOfVisibleString())
        
        return String(visibleText)
    }
    
    func seperateStringBasedOnVisibility() -> (visibleString:String,outOfBoundsString:String) {
        
        let visibleString = visibleText()
        
        var outOfBoundsString = text
        
        let rangeToRemove = outOfBoundsString.rangeOfString(visibleString)
        outOfBoundsString.removeRange(rangeToRemove!)
        
        return (visibleString,outOfBoundsString)
    }
    
    func seperateStringBasedOnVisibility(array:[String]) -> (visibleString:[String],outOfBoundsString:[String]) {
        
        let currentVisibleText = visibleText()
        
        let startIndex : Int = 0
        var endIndex : Int = 0
        
        var unShownText = array
        var currentTextArray = array
        
        while currentVisibleText.containsString(array[endIndex]) {
            
            if endIndex == (array.count - 1) {
                break
            }
            endIndex += 1
            
        }
        
        if endIndex == (array.count - 1) {
            return (array,[])
        } else {
            currentTextArray.removeRange(Range(start: (endIndex + 1), end: (array.count)))
            
            unShownText.removeRange(Range(start: startIndex, end: endIndex))
            
            return (currentTextArray,unShownText)
        }
    }

    
}