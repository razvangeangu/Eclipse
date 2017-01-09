//
//  RGBorder.swift
//  Eclipse
//
//  Created by Razvan-Gabriel Geangu on 27/12/2015.
//  Copyright (c) 2015 CHO. All rights reserved.
//

import Foundation
import SpriteKit

class RGBorder: SKSpriteNode {
    
    let NUMBER_OF_SEGMENTS = 20
    let COLOR_ONE = UIColor.white
    let COLOR_TWO = UIColor.gray
    
    init(size: CGSize){
        super.init(texture: nil, color: UIColor.brown, size: CGSize(width: size.width*2, height: size.height))
        anchorPoint = CGPoint(x: 0, y: 0.5)
        
        for i in 0 ..< NUMBER_OF_SEGMENTS {
            var segmentColor: UIColor!
            if i%2 == 0 {
                segmentColor = COLOR_ONE
            } else {
                segmentColor = COLOR_TWO
            }
            
            let segment = SKSpriteNode(color: segmentColor, size: CGSize(width: self.size.width / CGFloat(NUMBER_OF_SEGMENTS), height: self.size.height))
            segment.anchorPoint = CGPoint(x: 0.0, y: 0.5)
            segment.position = CGPoint(x: CGFloat(i)*segment.size.width, y: 0)
            addChild(segment)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func start() {
        
        let moveLeft = SKAction.moveBy(x: -frame.size.width/2, y: 0, duration: 1.0)
        let resetPosition = SKAction.moveTo(x: 0, duration: 0)
        let moveSequence = SKAction.sequence([moveLeft, resetPosition])
        
        run(SKAction.repeatForever(moveSequence))
    }
    
}
