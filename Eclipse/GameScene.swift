//
//  GameScene.swift
//  Eclipse
//
//  Created by Razvan-Gabriel Geangu on 27/12/2015.
//  Copyright © 2015 CHO. All rights reserved.
//

import SpriteKit
import CoreMotion
import AudioToolbox

var border: RGBorder!
var moon: RGSpaceObject!
var sun: RGSpaceObject!
var movementManager = CMMotionManager()
var scoreLabel: SKLabelNode!
var highScoreLabel: SKLabelNode!
var timer = NSTimer()
var score: Int = 0
var highScore = 0
var scoreString = ""
var highScoreString = ""
var gameStarted = false

class GameScene: SKScene {
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        backgroundColor = UIColor.whiteColor()
        
        // Setup border
//        border = RGBorder(size: CGSize(width: view.frame.width, height: 20))
//        border.position = CGPointMake(0, view.frame.size.height/2)
//        addChild(border)
//        border.hidden = true
        
        // Add start label
        let tapToStartLabel = SKLabelNode(text: "Tap to start!")
        tapToStartLabel.name = "tapToStartLabel"
        tapToStartLabel.position = view.center
        tapToStartLabel.fontColor = UIColor.blackColor()
        tapToStartLabel.fontSize = 32
        addChild(tapToStartLabel)
        
        // Add score label
        scoreLabel = SKLabelNode()
        scoreLabel.fontColor = UIColor.blackColor()
        scoreLabel.text = ""
        scoreLabel.fontSize = 32
        scoreLabel.position.x = view.center.x
        scoreLabel.position.y = view.center.y*2 - 40
        addChild(scoreLabel)
        
        // Adding the highScore label
        let highScoreDefault = NSUserDefaults.standardUserDefaults()
        
        if(highScoreDefault.valueForKey("highScore") != nil) {
            highScore = highScoreDefault.valueForKey("highScore") as! NSInteger
        }
        
        let highScoreInitLabel = SKLabelNode(text: NSString(format: "Highscore: %i", highScore) as String)
        highScoreInitLabel.name = "highScoreInitLabel"
        highScoreInitLabel.position.x = view.center.x
        highScoreInitLabel.position.y = view.center.y + 45
        highScoreInitLabel.fontColor = UIColor.blackColor()
        highScoreInitLabel.fontSize = 18
        addChild(highScoreInitLabel)
    }

    // Function to update the score when the game stops
    func updateScore() {
        
        if(score == 0) {
            timer.invalidate() // stop the timer
            stop() // changing to stop view
        } else {
            score -= 1 // correcting the score
        }
        
        scoreString = score > 9 ? "\(score)": "0\(score)" // setting the score string
        scoreLabel.text = "Score: "+scoreString // assigning the scoreString to the label
    }
    
    // Function to start the game
    func start() {
//        border.hidden = false
//        border.start()
        
        // Removing the highScore label from the view
        let highScoreInitLabel = childNodeWithName("highScoreInitLabel")
        highScoreInitLabel?.removeFromParent()
        
        // Changing the background color of the view
        backgroundColor = UIColor.blackColor()
        
        // Removing the Start label from the view
        let tapToStartLabel = childNodeWithName("tapToStartLabel")
        tapToStartLabel?.removeFromParent()
        
        // Moving the score to the top of the view and setting new font style
        scoreLabel.position.x = view!.center.x
        scoreLabel.position.y = view!.center.y*2 - 40
        scoreLabel.fontColor = UIColor.whiteColor()
        
        // Removing Try again label from the view
        let tapToTryAgainLabel = childNodeWithName("tapToTryAgainLabel")
        tapToTryAgainLabel?.removeFromParent()
        
        // Reseting the score to the default value
        score = 1000
        let highScoreLabel = childNodeWithName("highScoreLabel")
        highScoreLabel?.removeFromParent()
        
        // Setup main objects
        makeSun()
        makeMoon()
        
        // Starting the timer with score as a selector
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("updateScore"), userInfo: nil, repeats: true)
        
        // Record data from accelerometer
        movementManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!) { (accelerometerData: CMAccelerometerData?, NSError) -> Void in
            self.updatePos(accelerometerData!.acceleration)
            if(NSError != nil) {
                print("\(NSError)")
            }
            // Check collision and update the score
            self.collisionDetected(moon, b: sun)
            self.updateScore()
        }
    }
    
    // Function to stop the game
    func stop() {
//        border.hidden = true
        gameStarted = false
        backgroundColor = UIColor.whiteColor()
        
        // Stoping the timer and getting data from the sensor
        timer.invalidate()
        movementManager.stopAccelerometerUpdates()
        
        // Removing main objects from the view
        sun.removeFromParent()
        moon.removeFromParent()
        
        // Moving the score label to the center of the view and changing its color
        scoreLabel.position = view!.center
        scoreLabel.fontColor = UIColor.blackColor()
        
        // Adding Try again label to the view and setting its style
        let tapToTryAgainLabel = SKLabelNode(text: "Tap to try again..")
        tapToTryAgainLabel.position.x = view!.center.x
        tapToTryAgainLabel.position.y = view!.center.y - 30
        tapToTryAgainLabel.fontSize = 18
        tapToTryAgainLabel.name = "tapToTryAgainLabel"
        tapToTryAgainLabel.fontColor = UIColor.blackColor()
        addChild(tapToTryAgainLabel)
        
        // Adding Highscore label to the view and setting its style
        let highScoreLabel = SKLabelNode(text: "Highscore: ")
        highScoreLabel.position.x = view!.center.x
        highScoreLabel.position.y = view!.center.y + 40
        highScoreLabel.fontSize = 18
        highScoreLabel.name = "highScoreLabel"
        highScoreLabel.fontColor = UIColor.blackColor()
        
        // Setting the Highscore value
        if(score > highScore) {
            score += 1
            highScore = score
        }
        
        // Synchronizing core data with Highscore
        let highScoreDefault = NSUserDefaults.standardUserDefaults()
        highScoreDefault.setValue(highScore, forKey: "highScore")
        highScoreDefault.synchronize()
        highScoreString = NSString(format: "Highscore: %i", highScore) as String
        highScoreLabel.text = highScoreString
        addChild(highScoreLabel)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // Condition: as long as the game is stoped when touchesBegan the game starts, else nothing happens
        if(!gameStarted) {
            start()
        }
        gameStarted = true
        //border.start()
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func updatePos(acceleration: CMAcceleration) {
        let x: CGFloat = sun.position.x + CGFloat(acceleration.x) * 10
        let y: CGFloat = sun.position.y + CGFloat(acceleration.y) * 10
        let xM: CGFloat = moon.position.x + CGFloat(acceleration.x) * -10
        let yM: CGFloat = moon.position.y + CGFloat(acceleration.y) * -10
        
        // Setting coordinates for the main objects
        sun.position.x = x
        sun.position.y = y
        moon.position.x = xM
        moon.position.y = yM
        
        // Sun's borders
        // Right constraints
        if(sun.position.x > (size.width - 100) && x > 0)
        {
            sun.position.x = size.width - 100;
        }
        
        // Left constraints
        if(sun.position.x < 0 && x < 0)
        {
            sun.position.x = 0;
        }
        
        // Top constraints
        if(sun.position.y > (size.height - 100) && y > 0)
        {
            sun.position.y = size.height - 100;
        }
        
        // Bottom constraints
        if(sun.position.y < 0 && y < 0)
        {
            sun.position.y = 0;
        }
        
        // Moon's borders
        // Right constraints
        if(moon.position.x > (size.width - 90) && -xM < 0)
        {
            moon.position.x = size.width - 90;
        }
        
        // Left constraints
        if(moon.position.x < 0 && -xM > 0)
        {
            moon.position.x = 0;
        }
        
        // Top constraints
        if(moon.position.y > (size.height - 90) && -yM < 0)
        {
            moon.position.y = size.height - 90;
        }
        
        // Bottom constraints
        if(moon.position.y < 0 && -yM > 0)
        {
            moon.position.y = 0;
        }
    }
    
    // Function to create, set and add to the view an object
    func makeSun() {
        let SUN_WIDTH: CGFloat = 100.0
        let SUN_HEIGHT: CGFloat = 100.0
        let x: CGFloat = 0.0
        let y: CGFloat = size.height - SUN_HEIGHT
        
        // Assigning size constraints
        sun = RGSpaceObject(size: CGSize(width: SUN_WIDTH, height: SUN_HEIGHT))
        
        // Setting position
        sun.position = CGPointMake(x, y)
        
        // Setting zPosition under 'moon' object
        sun.zPosition = 1
        
        // Filling with whiteColor
        sun.fillColor = UIColor.whiteColor()
        
        // Adding to the view
        addChild(sun)
    }

    // Function to create, set and add to the view an object
    func makeMoon() {
        let MOON_WIDTH: CGFloat = 90.0
        let MOON_HEIGHT: CGFloat = 90.0
        let x: CGFloat = size.width - MOON_WIDTH
        let y: CGFloat = 0.0
        
        // Assigning size constraints
        moon = RGSpaceObject(size: CGSize(width: MOON_WIDTH, height: MOON_HEIGHT))
        
        // Setting position
        moon.position = CGPointMake(x, y)
        
        // Setting zPosition above 'sun' object
        moon.zPosition = 2
        
        // Filling with blackColor
        moon.fillColor = UIColor.blackColor()
        
        // Setting stroke color to white
        moon.strokeColor = UIColor.whiteColor()
        
        // Adding to the view
        addChild(moon)
    }
    
    // Function to check if two objects are almost in the exact position
    func collisionDetected(a: RGSpaceObject, b: RGSpaceObject) {
        // Vectorial distance in two dimensional (x,y) coordinates system
        if(((pow(abs(a.position.x - b.position.x),2) + pow(abs(a.position.y - b.position.y),2)) < 100)) {
            // Adding vibrate feedback
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
            // Stop the game
            stop()
        }
    }
}
