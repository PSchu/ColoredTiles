//
//  Onboarder.swift
//  ColorTiles
//
//  Created by Peter Schumacher on 14.07.16.
//  Copyright © 2016 Peter Schumacher. All rights reserved.
//

import Foundation

protocol OnboarderDelegate: class {
    var tileSections: [TileSection] { get }
}

class Onboarder {
    weak var delegate: OnboarderDelegate?
    
    func hasChoosenColor() -> Bool {
        return delegate?.tileSections.contains({ (section) -> Bool in
            switch section {
            case .Single(let tile):
                return tile.color != nil
            case .Double(let leftTile, let rightTile):
                return leftTile.color != nil || rightTile.color != nil
            }
        }) ?? false
    }
    
    func hasCombinedTiles() -> Bool {
        return delegate?.tileSections.contains({ (section) -> Bool in
            switch section {
            case .Single(_):
                return false
            case .Double(_, _):
                return true
            }
        }) ?? false
    }
}