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

enum TileSection {
    case Single(ColorTile)
    case Double(ColorTile, ColorTile)
    
    func numberOfItems() -> Int {
        switch self {
        case .Single(_):
            return 1
        case .Double(_, _):
            return 2
        }
    }
    
    func color(of index: Int) -> UIColor? {
        switch self {
        case .Single(let tile) where index == 0:
            return tile.color
        case .Double(let leftTile, _) where index == 0:
            return leftTile.color
        case .Double(_, let rightTile) where index == 1:
            return rightTile.color
        default:
            return nil
        }
    }
    
    static func defaultSetup() -> [TileSection] {
        return [0,1,2,3].map { _ in return TileSection.Double(ColorTile(color: nil), ColorTile(color: nil)) }
    }
    
    func section(with colorTile: ColorTile, on index: Int) -> TileSection? {
        switch self {
        case .Single(let tile) where index == 0 && !tile.isActive():
            return .Single(colorTile)
        case .Double(let leftTile, let rightTile) where index == 0 && !leftTile.isActive():
            return Double(colorTile, rightTile)
        case .Double(let leftTile,  let rightTile) where index == 1 && !rightTile.isActive():
            return Double(leftTile, colorTile)
        default:
            return nil
        }
    }
    
    func isActive(at index: Int) -> Bool {
        switch self {
        case .Single(let tile) where index == 0:
            return tile.isActive()
        case .Double(let leftTile, _) where index == 0:
            return leftTile.isActive()
        case .Double(_, let rightTile) where index == 1:
            return rightTile.isActive()
        default:
            return false
        }
    }
}

class ColorTilesViewController: UICollectionViewController {
    let panRecognizer = UIPanGestureRecognizer()
    var tileSections: [TileSection] = TileSection.defaultSetup()
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
            guard indexPath.section < tileSections.count else { return false }
            return tileSections[indexPath.section].isActive(at: indexPath.item)
        }
        return false
    }
    
    func connect(origin: CGPoint, with destination: CGPoint) {
        if let originIndexPath = collectionView?.indexPathForItemAtPoint(origin),
            let destinationIndexPath = collectionView?.indexPathForItemAtPoint(destination) where originIndexPath.section == destinationIndexPath.section {

            let color = tileSections[originIndexPath.section].color(of: originIndexPath.item)
            tileSections.replaceRange(originIndexPath.section..<originIndexPath.section+1, with: [TileSection.Single(ColorTile(color: color))])

            collectionView?.reloadData()
        }
    }
}

//MARK: UICollectionViewDelegate
extension ColorTilesViewController {
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tileSections[section].numberOfItems()
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return tileSections.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("coloredTile", forIndexPath: indexPath)
        guard indexPath.section < tileSections.count else { return cell }
        
        let tiles = tileSections[indexPath.section]
        
        if let cell = cell as? ColoredTileCell {
            cell.color = tiles.color(of: indexPath.item)
        }
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard indexPath.section < tileSections.count else { return }
        guard let newSection = tileSections[indexPath.section].section(with: ColorTile(color: UIColor.yellowColor()), on: indexPath.item) else { return }
        
        tileSections.replaceRange(indexPath.section..<indexPath.section+1, with: [newSection])


        collectionView.reloadData()
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension ColorTilesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        guard indexPath.section < tileSections.count else { return CGSizeZero }
        let numberOfItemsInRow = CGFloat(tileSections[indexPath.section].numberOfItems())
        let numberOfSections = CGFloat(tileSections.count)
        return CGSize(width: collectionView.frame.width/numberOfItemsInRow, height: collectionView.frame.height/numberOfSections)
    }
}