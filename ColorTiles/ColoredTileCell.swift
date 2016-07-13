//
//  ColoerdTile.swift
//  ColorTiles
//
//  Created by Peter Schumacher on 12.07.16.
//  Copyright © 2016 Peter Schumacher. All rights reserved.
//

import UIKit

class ColoredTileCell: UICollectionViewCell {
    var color: UIColor? {
        didSet {
            self.contentView.backgroundColor = color != nil ? color : UIColor.lightGrayColor()
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView.backgroundColor = UIColor.lightGrayColor()
        contentView.layer.borderColor = UIColor.darkGrayColor().CGColor
        contentView.layer.borderWidth = 1
    }

}