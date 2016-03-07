//
//  RGSpaceObject.swift
//  Eclipse
//
//  Created by Razvan-Gabriel Geangu on 27/12/2015.
//  Copyright © 2015 CHO. All rights reserved.
//

import Foundation
import SpriteKit

class RGSpaceObject: SKShapeNode {
    
    init(size: CGSize) {
        super.init()
        let path = CGPathCreateWithEllipseInRect(CGRect(x: 0, y: 0, width: size.width, height: size.height), nil)
        self.path = path
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}