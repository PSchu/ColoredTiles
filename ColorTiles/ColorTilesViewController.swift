//
//  ViewController.swift
//  ColorTiles
//
//  Created by Peter Schumacher on 12.07.16.
//  Copyright © 2016 Peter Schumacher. All rights reserved.
//

import UIKit

struct ColorTile {
    let color: UIColor?
    
    static func defaultTiles() -> [ColorTile] {
        return [0,1,2,3,4,5,6,7].map { _ in return ColorTile(color: nil)}
    }
    
    func isActive() -> Bool {
        return color != nil
    }
}

class ColorTilesViewController: UICollectionViewController {
    let panRecognizer = UIPanGestureRecognizer()
    var tiles: [ColorTile] = ColorTile.defaultTiles()
    private var origin: CGPoint?
    
    @IBOutlet weak var connector: ConnecterView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connector.delegate = self
        collectionView?.addGestureRecognizer(panRecognizer)
        connector.panRecognizer = panRecognizer
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

//MARK: ConnecterDelegate
extension ColorTilesViewController: ConnecterDelegate {
    func shouldStartConnecting(from origin: CGPoint) -> Bool {
        if let indexPath = collectionView?.indexPathForItemAtPoint(origin) {
            guard indexPath.item < tiles.count else { return false }
            return tiles[indexPath.item].isActive()
        }
        return false
    }
    
    func connect(origin: CGPoint, with destination: CGPoint) {
        if let originIndexPath = collectionView?.indexPathForItemAtPoint(origin),
            let destinationIndexPath = collectionView?.indexPathForItemAtPoint(destination) {
            
            tiles.replaceRange(destinationIndexPath.item..<destinationIndexPath.item+1, with: [tiles[originIndexPath.item]])
            collectionView?.reloadData()
        }
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
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard indexPath.item < tiles.count else { return }
        let tile = tiles[indexPath.item]
        if tile.isActive() {
            tiles.replaceRange(indexPath.item..<indexPath.item+1, with: [ColorTile(color: nil)])
        } else {
            tiles.replaceRange(indexPath.item..<indexPath.item+1, with: [ColorTile(color: UIColor.yellowColor())])
        }
        collectionView.reloadData()
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension ColorTilesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        guard indexPath.item < tiles.count else { return CGSizeZero }
        return CGSize(width: collectionView.frame.width/2, height: collectionView.frame.height/4)
    }
}