//
//  ViewController.swift
//  AutomaticPager
//
//  Created by Romain Menke on 20/09/15.
//  Copyright © 2015 menke dev. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    
    var collectionView: UICollectionView!
    var layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    var pageManager : Pager!
    var font = UIFont(name: "TimesNewRomanPSMT", size: 14)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let height = (self.view.bounds.height / 3 * 2)
        
        var frame = self.view.frame
        frame.size.height = height
        
        pageManager = Pager(frame: frame)
        pageManager.font = font
        pageManager.setPagesFromText(lorem)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        let margin = self.view.bounds.height / 6
        
        let height = (self.view.bounds.height / 3 * 2) + margin
        
        
        collectionView = UICollectionView(frame: CGRect(x: 0.0, y: margin, width: self.view.bounds.width, height: height), collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.pagingEnabled = true
        collectionView.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionView)
        
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        layout.estimatedItemSize = CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        
        layout.prepareLayout()
        collectionView.reloadData()
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return pageManager.chapters.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageManager.chapters[section].count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.width, height: self.collectionView.frame.height)
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as? CollectionViewCell else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
            return cell
        }
        
        cell.textView.font = font
        cell.textView.text = pageManager.chapters[indexPath.section][indexPath.row]
        
        return cell
    }
}