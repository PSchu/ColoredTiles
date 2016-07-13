//
//  ConecterView.swift
//  ColorTiles
//
//  Created by Peter Schumacher on 12.07.16.
//  Copyright © 2016 Peter Schumacher. All rights reserved.
//

import UIKit

protocol ConnecterDelegate: class {
    func shouldStartConnecting(from origin: CGPoint) -> Bool
    func connect(origin: CGPoint, with destination: CGPoint)
}

class ConnecterView: UIImageView {
    weak var panRecognizer: UIPanGestureRecognizer? {
        didSet {
            guard let panRecognizer = self.panRecognizer else { return }
            panRecognizer.addTarget(self, action: #selector(handlePan))
        }
    }
    private var origin: CGPoint?
    weak var delegate: ConnecterDelegate?
    
    func handlePan(recognizer: UIPanGestureRecognizer) {
        let location = recognizer.locationInView(self)
        
        switch(recognizer.state) {
        case .Began:
            origin = nil
            guard delegate?.shouldStartConnecting(from: location) == true else { return }
            origin = location
            
        case .Changed:
            guard let origin = origin else { return }
            UIGraphicsBeginImageContext(frame.size);
            let currentContext = UIGraphicsGetCurrentContext();
            CGContextSetLineWidth(currentContext, 20.0);
            CGContextSetStrokeColorWithColor(currentContext, UIColor.blueColor().CGColor);
            CGContextMoveToPoint(currentContext, origin.x, origin.y);
            CGContextAddLineToPoint(currentContext, location.x, origin.y)
            CGContextSetLineCap(currentContext, .Round)
            CGContextSetBlendMode(UIGraphicsGetCurrentContext(), .Normal)
            CGContextStrokePath(currentContext)
            
            image = UIGraphicsGetImageFromCurrentImageContext();
            alpha = 1
            UIGraphicsEndImageContext()
            
        case .Ended:
            guard let origin = origin else { return }
            image = nil
            delegate?.connect(origin, with: CGPoint(x: location.x, y: origin.y))
            
        default:
            image = nil
        }
    }
}