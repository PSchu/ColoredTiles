//
//  ViewController.swift
//  ColorTiles
//
//  Created by Peter Schumacher on 12.07.16.
//  Copyright © 2016 Peter Schumacher. All rights reserved.
//

import UIKit


class ColorTilesViewController: UICollectionViewController {
    let panRecognizer = UIPanGestureRecognizer()
    var tileSections: [TileSection] = TileSection.defaultSetup()
    var idleTimer: NSTimer?
    var onboarder: Onboarder = Onboarder()
    
    static let maxIdleTime: NSTimeInterval = 5
    
    var colorPicker: ColorPickerController? {
        didSet {
            colorPicker?.delegate = self
        }
    }
    private var origin: CGPoint?
    
    @IBOutlet weak var connector: ConnecterView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onboarder.delegate = self
        connector.delegate = self
        collectionView?.addGestureRecognizer(panRecognizer)
        connector.panRecognizer = panRecognizer
        resetIdleTimer()
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
    
    func resetIdleTimer() {
        if idleTimer == nil {
            idleTimer = NSTimer.scheduledTimerWithTimeInterval(ColorTilesViewController.maxIdleTime, target: self, selector: #selector(idleTimerExeded), userInfo: nil, repeats: false)
        } else if fabs(Double(idleTimer?.fireDate.timeIntervalSinceNow ?? 0)) < ColorTilesViewController.maxIdleTime-1 {
            idleTimer?.fireDate = NSDate(timeIntervalSinceNow: ColorTilesViewController.maxIdleTime)
        }
    }
    
    func idleTimerExeded() {
        idleTimer = nil
        onboarder.showOnboardingAnimation()
        resetIdleTimer()
    }
    
    override func nextResponder() -> UIResponder? {
        resetIdleTimer()
        return super.nextResponder()
    }
}

extension ColorTilesViewController: OnboarderDelegate {}

//MARK: ColorPickerDelegate
extension ColorTilesViewController: ColorPickerDelegate {
    func setColor(of point: CGPoint, to color: UIColor) {
        guard let indexPath = collectionView?.indexPathForItemAtPoint(point) else { return }
        guard let newSection = tileSections[indexPath.section].section(with: ColorTile(color: color), on: indexPath.item) else { return }
        
        tileSections.replaceRange(indexPath.section..<indexPath.section+1, with: [newSection])
        
        collectionView?.reloadItemsAtIndexPaths([indexPath])
    }
    
    func originViewController() -> UIViewController {
        return self
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

            collectionView?.reloadSections(NSIndexSet(index: originIndexPath.section))
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
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) {
            let origin = cell.contentView.convertPoint(cell.contentView.center, toView: collectionView)
            colorPicker = ColorPickerController(origin: origin)
            colorPicker?.show()
        }
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