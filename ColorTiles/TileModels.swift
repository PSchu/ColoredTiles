//
//  TileModels.swift
//  ColorTiles
//
//  Created by Peter Schumacher on 13.07.16.
//  Copyright © 2016 Peter Schumacher. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    static func ctRedColor() -> UIColor {
        return UIColor(netHex: 0xF44336)
    }
    
    static func ctBlueColor() -> UIColor {
        return UIColor(netHex: 0x448AFF)
    }
    
    static func ctGreenColor() ->  UIColor {
        return UIColor(netHex: 0x4CAF50)
    }
    
    static func ctYellowColor() -> UIColor {
        return UIColor(netHex: 0xFFEB3B)
    }
}

struct ColorTile {
    let color: UIColor?
    
    init(color: UIColor? = nil) {
        self.color = color
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
        return [0,1,2,3].map { _ in return TileSection.Double(ColorTile(), ColorTile()) }
    }
    
    func section(with colorTile: ColorTile, on index: Int) -> TileSection? {
        switch self {
        case .Single(_) where index == 0:
            return .Single(colorTile)
        case .Double(_, let rightTile) where index == 0:
            return Double(colorTile, rightTile)
        case .Double(let leftTile, _) where index == 1:
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
