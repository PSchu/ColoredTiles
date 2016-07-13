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
    
    @IBOutlet weak var buttonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    
    
    lazy var tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissWithoutColor))
    
    init(origin: CGPoint) {
        self.origin = origin
        super.init(nibName: "ColorPickerController", bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        origin = CGPointZero
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(tapRecognizer)
        redButton.backgroundColor = UIColor.ctRedColor()
        blueButton.backgroundColor = UIColor.ctBlueColor()
        greenButton.backgroundColor = UIColor.ctGreenColor()
        yellowButton.backgroundColor = UIColor.ctYellowColor()
        
        [redButton,blueButton,yellowButton,greenButton].forEach { (button) in
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.darkGrayColor().CGColor
            button.layer.cornerRadius = 8
        }
        view.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.5)
    }
    
    func show() {
        guard let originController = delegate?.originViewController() else { return }
        
        originController.addChildViewController(self)
        originController.view.addSubview(self.view)
        self.didMoveToParentViewController(originController)
        self.view.frame = originController.view.frame
        
        view.frame.origin = origin
        view.frame.size = CGSizeZero
        buttonWidthConstraint.constant = 0
        buttonHeightConstraint.constant = 0
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        UIView.animateWithDuration(0.5) {

            self.buttonWidthConstraint.constant = 150
            self.buttonHeightConstraint.constant = 150
            self.view.frame = originController.view.frame
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
            
        }
    }
    
    func dismissWithoutColor() {
        dismiss(with: nil)
    }
    
    func dismiss(with color: UIColor?) {
        self.view.layoutIfNeeded()
        UIView.animateWithDuration(0.5, animations: {
            self.buttonWidthConstraint.constant = 0
            self.buttonHeightConstraint.constant = 0
            self.view.frame.origin = self.origin
            self.view.frame.size = CGSizeZero
            
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
            if let color = color {
                self.delegate?.setColor(of: self.origin, to: color)
            }
            }) { _ in
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
        }
    }
    
    @IBAction func chooseRed(sender: AnyObject) {
        dismiss(with: UIColor.ctRedColor())
    }
    
    @IBAction func chooseBlue(sender: AnyObject) {
        dismiss(with: UIColor.ctBlueColor())
    }
    
    @IBAction func chooseYellow(sender: AnyObject) {
        dismiss(with: UIColor.ctYellowColor())
    }
    
    @IBAction func chooseGreen(sender: AnyObject) {
        dismiss(with: UIColor.ctGreenColor())
    }
}