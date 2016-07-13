//
//  ColorPicker.swift
//  ColorTiles
//
//  Created by Peter Schumacher on 13.07.16.
//  Copyright © 2016 Peter Schumacher. All rights reserved.
//

import UIKit

protocol ColorPickerDelegate: class {
    func setColor(of point: CGPoint, to color: UIColor)
    func originViewController() -> UIViewController
}

class ColorPickerController : UIViewController {
    let origin: CGPoint
    weak var delegate: ColorPickerDelegate?
    
    lazy var tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismiss))
    
    init(origin: CGPoint) {
        self.origin = origin
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        origin = CGPointZero
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(tapRecognizer)
        view.backgroundColor = UIColor.brownColor()
        view.alpha = 0.5
    }
    
    func show() {
        guard let originController = delegate?.originViewController() else { return }
        
        view.frame = CGRectMake(origin.x, origin.y, 0, 0)
        UIView.animateWithDuration(0.5) {
            originController.addChildViewController(self)
            originController.view.addSubview(self.view)
            self.didMoveToParentViewController(originController)
            self.view.frame = originController.view.frame
        }
    }
    
    func dismiss() {
        UIView.animateWithDuration(0.5, animations: { 
            self.view.frame = CGRectMake(self.origin.x, self.origin.y, 0, 0)
            self.delegate?.setColor(of: self.origin, to: UIColor.redColor())
            }) { _ in
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
        }
    }
}