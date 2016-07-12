//
//  ViewController.swift
//  ColorTiles
//
//  Created by Peter Schumacher on 12.07.16.
//  Copyright © 2016 Peter Schumacher. All rights reserved.
//

import UIKit

struct ColorTile {
    let color: UIColor
    
    static func defaultTiles() -> [ColorTile] {
        return [0,1,2,3,4,5,6,7].map { _ in return ColorTile(color: UIColor.lightGrayColor())}
    }
}

class ColorTilesViewController: UICollectionViewController {
    
    var tiles: [ColorTile] = ColorTile.defaultTiles()
    private var originIndexPath: NSIndexPath?
    private var origin: CGPoint?
    
    @IBOutlet weak var connector: ConnecterView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.bringSubviewToFront(connector)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

//MARK: UICollectionViewDelegate
extension ColorTilesViewController {
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tiles.count
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("coloredTile", forIndexPath: indexPath)
        guard indexPath.item < tiles.count else { return cell }
        
        if let cell = cell as? ColoredTileCell {
            cell.color = tiles[indexPath.item].color
        }
        return cell
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension ColorTilesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        guard indexPath.item < tiles.count else { return CGSizeZero }
        return CGSize(width: collectionView.frame.width/2, height: collectionView.frame.height/4)
    }
}