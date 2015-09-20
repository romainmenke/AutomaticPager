//
//  CollectionViewCell.swift
//  AutomaticPager
//
//  Created by Romain Menke on 20/09/15.
//  Copyright © 2015 menke dev. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    var textView : UITextView!
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        
        textView = UITextView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        textView.bounds = textView.frame
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textView.scrollEnabled = false
        textView.selectable = false
        textView.editable = false
        self.contentView.addSubview(textView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}