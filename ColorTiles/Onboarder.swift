//
//  Onboarder.swift
//  ColorTiles
//
//  Created by Peter Schumacher on 14.07.16.
//  Copyright © 2016 Peter Schumacher. All rights reserved.
//

import Foundation
import UIKit

protocol OnboarderDelegate: class {
    var tileSections: [TileSection] { get }
    var collectionView: UICollectionView? { get }
}

class Onboarder {
    weak var delegate: OnboarderDelegate?
    
    private func hasChoosenColor() -> Bool {
        return delegate?.tileSections.contains({ (section) -> Bool in
            return section.isActive(at: 0) || section.isActive(at: 1)
        }) ?? false
    }
    
    private func hasCombinedTiles() -> Bool {
        return delegate?.tileSections.contains({ (section) -> Bool in
            switch section {
            case .Single(_):
                return true
            case .Double(_, _):
                return false
            }
        }) ?? false
    }
    
    func showOnboardingAnimation() {
        if !hasChoosenColor() {
            showTapOnTileAnimation()
        } else if !hasCombinedTiles() {
            showCombineTilesAnimation()
        }
    }
    
    private func showTapOnTileAnimation() {
        let hand = UIImageView(image: UIImage(named: "Hand")!)
        guard let startPoint = delegate?.collectionView?.cellForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 1))?.contentView.center else { return }
        delegate?.collectionView?.addSubview(hand)
        hand.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        hand.center = startPoint
        hand.alpha = 0
        
        UIView.animateWithDuration(0.5, animations: { 
            hand.alpha = 1
            }) { (_) in
                UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.Autoreverse, animations: {
                    hand.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5)
                    }, completion: { _ in
                        UIView.animateWithDuration(0.5, animations: { 
                            hand.alpha = 0
                            }, completion: { (_) in
                                hand.removeFromSuperview()
                        })
                })
        }
        
        print("Show Tap Animation")
    }
    
    private func animationRoute() -> (CGPoint, CGPoint)? {
        if let (sectionIndex, activeSection) = delegate?.tileSections.enumerate().filter({ (index, section) -> Bool in
            return section.isActive(at: 0) || section.isActive(at: 1)
        }).first {
            let itemIndex = activeSection.isActive(at: 0) ? 0 : 1
            if let originCell = delegate?.collectionView?.cellForItemAtIndexPath(NSIndexPath(forItem: itemIndex, inSection: sectionIndex)) {
                let distance: CGFloat = itemIndex == 0 ? originCell.frame.size.width : -originCell.frame.size.width
                return (originCell.center, CGPoint(x: originCell.center.x + distance, y: originCell.center.y))
            }
        }
        
        return nil
    }
    
    private func showCombineTilesAnimation() {
        let hand = UIImageView(image: UIImage(named: "Hand")!)
        guard let (startPoint, endPoint) = animationRoute() else { return }
        delegate?.collectionView?.addSubview(hand)
        hand.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        hand.center = startPoint
        hand.alpha = 0
        
        
        UIView.animateWithDuration(0.5, animations: {
            hand.alpha = 1
        }) { (_) in
            UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions() , animations: {
                hand.center = endPoint
                hand.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5)
                }, completion: { _ in
                    UIView.animateWithDuration(0.5, animations: {
                        hand.alpha = 0
                        }, completion: { (_) in
                            hand.removeFromSuperview()
                    })
            })
        }
        print("Show Combine Animation")
    }
}