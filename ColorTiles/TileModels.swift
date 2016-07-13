//
//  TileModels.swift
//  ColorTiles
//
//  Created by Peter Schumacher on 13.07.16.
//  Copyright © 2016 Peter Schumacher. All rights reserved.
//

import UIKit

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
        case .Single(let tile) where index == 0 && !tile.isActive():
            return .Single(colorTile)
        case .Double(let leftTile, let rightTile) where index == 0 && !leftTile.isActive():
            return Double(colorTile, rightTile)
        case .Double(let leftTile,  let rightTile) where index == 1 && !rightTile.isActive():
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
