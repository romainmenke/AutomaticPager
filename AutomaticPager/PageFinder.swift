//
//  PageFinder.swift
//  AutomaticPager
//
//  Created by Romain Menke on 21/09/15.
//  Copyright © 2015 menke dev. All rights reserved.
//

import UIKit

// FINDING PAGES

protocol PageFinder {
    
    var pages : [[String]] { get }
    var chapters : [[[String]]] { get }
    
}

extension PageFinder {
    
    func getPageWithString(searchString : String) -> (chapter:Int,page:Int)? {
        
        for chapterID in 0..<chapters.count {
            
            let chapter = chapters[chapterID]
            
            if let pageID = getPageInChapterWithString(searchString, chapter: chapter) {
                
                return (chapter: chapterID, page: pageID)
            }
        }
        return nil
    }
    
    func getPageInChapterWithString(searchStrings: [String], chapter: [[String]]) -> Int? {
        
        for pageID in 0..<chapter.count {
            
            let page = chapter[pageID]
            
            if stringIsOnPage(searchString, page: page) {
                return pageID
            }
        }
        return nil
    }
    
    func stringIsOnPage(searchString : String, page: String) -> Bool {
        
        if page.containsString(searchString) {
            return true
        } else if searchString.containsString(page) {
            return true // rare, nearly impossible case where a page only contains that last half of a string
        } else {
            return false
        }
        
    }
    
    func getReadRangeOfPage(searchString:String, page:Int, chapter:Int) -> NSRange { // untested
        
        let pageString = chapters[chapter][page] as NSString
        
        let range = pageString.rangeOfString(searchString)
        let rangeEnd = range.length + range.location
        let extendedRange = NSRange(location: 0, length: rangeEnd)
        
        return extendedRange
        
    }
    
}