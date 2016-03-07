//
//  RGSpaceObjectsGeneration.swift
//  Eclipse
//
//  Created by Razvan-Gabriel Geangu on 19/12/2015.
//  Copyright © 2015 CHO. All rights reserved.
//

import Foundation
import SpriteKit

class RGSpaceObjectsGeneration: SKSpriteNode {
    
    let SPACE_OBJECT_WIDTH: CGFloat = 55.0
    let SPACE_OBJECT_HEIGHT: CGFloat = 55.0
    
    var generationTimer: NSTimer!
    
    func populate(num: Int) {
        for var i = 0; i < num; i++ {
            let spaceobject = RGSpaceObject(size: CGSize(width: SPACE_OBJECT_WIDTH, height: SPACE_OBJECT_HEIGHT))
            let x = CGFloat(arc4random_uniform(UInt32(size.width))) - size.width/2
            let y = CGFloat(arc4random_uniform(UInt32(size.height))) - size.height/2
            spaceobject.position = CGPointMake(x, y)
            spaceobject.zPosition = -1
            addChild(spaceobject)
        }
    }
    
    func startGeneratingWithSpawnTime(seconds: NSTimeInterval) {
        generationTimer = NSTimer.scheduledTimerWithTimeInterval(seconds, target: self, selector: "generateSpaceObject", userInfo: nil, repeats: true)
    }
    
    func generateSpaceObject() {
        let x = size.width/2 + SPACE_OBJECT_WIDTH/2
        let y = CGFloat(arc4random_uniform(UInt32(size.height))) - size.height/2
        let spaceobject = RGSpaceObject(size: CGSizeMake(SPACE_OBJECT_WIDTH, SPACE_OBJECT_HEIGHT))
        spaceobject.position = CGPointMake(x, y)
        spaceobject.zPosition = -1
        addChild(spaceobject)
    }
}