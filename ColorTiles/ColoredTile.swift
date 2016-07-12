//
//  ColoerdTile.swift
//  ColorTiles
//
//  Created by Peter Schumacher on 12.07.16.
//  Copyright © 2016 Peter Schumacher. All rights reserved.
//

import UIKit

class ColoredTile: UICollectionViewCell {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.contentView.backgroundColor = UIColor.yellowColor()
        self.contentView.layer.borderColor = UIColor.darkGrayColor().CGColor
        self.contentView.layer.borderWidth = 1
    }

}