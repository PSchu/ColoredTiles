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
        view.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.5)
        
        setupButtons()
    }
    
    func setupButtons() {
        redButton.backgroundColor = UIColor.ctRedColor()
        blueButton.backgroundColor = UIColor.ctBlueColor()
        greenButton.backgroundColor = UIColor.ctGreenColor()
        yellowButton.backgroundColor = UIColor.ctYellowColor()
        
        [redButton,blueButton,yellowButton,greenButton].forEach { (button) in
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.darkGrayColor().CGColor
            button.layer.cornerRadius = 75
        }
    }
    
    
    func show() {
        guard let originController = delegate?.originViewController() else { return }
        
        installView(to: originController)
        animateAppear(to: originController.view.frame)
    }
    
    func installView(to originController: UIViewController) {
        originController.addChildViewController(self)
        originController.view.addSubview(self.view)
        self.view.frame = originController.view.frame
        self.didMoveToParentViewController(originController)
    }
    
    func animateAppear(to frame: CGRect) {
        [redButton,blueButton,yellowButton,greenButton].forEach { button in
            button.layer.transform = CATransform3DMakeScale(0, 0, 0)
        }
        UIView.animateWithDuration(0.5) {
            [self.redButton,self.blueButton,self.yellowButton,self.greenButton].forEach { button in
                button.layer.transform = CATransform3DMakeScale(1, 1, 1)
            }
        }
    }
    
    func dismissWithoutColor() {
        dismiss(with: nil)
    }
    
    func dismiss(with color: UIColor?) {
        UIView.animateWithDuration(0.5, animations: {
            [self.redButton,self.blueButton,self.yellowButton,self.greenButton].forEach { button in
                button.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
            }
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