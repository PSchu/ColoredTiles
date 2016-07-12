//
//  ConecterView.swift
//  ColorTiles
//
//  Created by Peter Schumacher on 12.07.16.
//  Copyright © 2016 Peter Schumacher. All rights reserved.
//

import UIKit

class ConnecterView: UIImageView {
    lazy var panRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
    private var origin: CGPoint?
    private var destination: CGPoint?
    
    init() {
        super.init(frame: CGRectZero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        addGestureRecognizer(panRecognizer)
        userInteractionEnabled = true
    }
    
    func handlePan(recognizer: UIPanGestureRecognizer) {
        let location = recognizer.locationInView(self)
        
        switch(recognizer.state) {
        case .Began:
            origin = location
            
        case .Changed:
            guard let origin = origin else { return }
            UIGraphicsBeginImageContext(frame.size);
            let currentContext = UIGraphicsGetCurrentContext();
            CGContextSetLineWidth(currentContext, 20.0);
            CGContextSetStrokeColorWithColor(currentContext, UIColor.blueColor().CGColor);
            CGContextMoveToPoint(currentContext, origin.x, origin.y);
            CGContextAddLineToPoint(currentContext, location.x, location.y)
            CGContextSetLineCap(currentContext, .Round)
            CGContextSetBlendMode(UIGraphicsGetCurrentContext(), .Normal)
            CGContextStrokePath(currentContext)
            
            image = UIGraphicsGetImageFromCurrentImageContext();
            alpha = 1
            UIGraphicsEndImageContext()
            
        case .Ended:
            image = nil
            destination = location
            print("From \(origin) to \(destination))")
            
        default:
            image = nil
        }
    }
}
