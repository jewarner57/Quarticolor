//
//  GameScene.swift
//  ColorSwarm
//
//  Created by Jonathan Warner on 2/13/16.
//  Copyright (c) 2016 TeedethGaming. All rights reserved.
//

import SpriteKit
import AVFoundation

var background = SKSpriteNode(imageNamed: "ColorSwarmBackGround3.png")
var randomBlock = 0
var blockTimer = Timer()
var randomBlockX:CGFloat = 0
var start = CGPoint(x: 0, y: 0)
var end = CGPoint(x: 0, y: 0)
var fallBlock = block()
var containsStart = false

var stage = 1 //current level of difficulty

var nodesToCheck: [block] = []
var stage1Positions: [CGFloat] = []
var stage2Positions: [CGFloat] = []
var stage3Positions: [CGFloat] = []

//var colorHideInterval:Int = 5//Int(arc4random_uniform(15)+10)

var i:Int = 0
var objSelect:SKSpriteNode = block()
var removedAt:Int = 0;
var restartButton = SKSpriteNode(imageNamed: "Restart.png")
var fallBlockHitArea = SKSpriteNode()
var gameInProgress:Bool = false
var secondTimer = Timer()
var secondsPast:Int = 0
var speedCounter:Int = 2
var gameSpeed:Double = 7.0
var gameSpawn:Double = 2

var whoosh = SKAction.playSoundFileNamed("Whoosh",
     waitForCompletion: false)

var soarAudio = URL(fileURLWithPath: Bundle.main.path(forResource: "soar", ofType: "mp3")!)
var audioPlayer = AVAudioPlayer()

let blankBack = SKSpriteNode(imageNamed: "blankBackground") // background to cover up the colors when colorHideInterval is reached

//HighScore and score vars
var currentScore = 0
var HighScore = 0

var HighScoreLabel = UILabel(frame: CGRect(x:0, y: 0, width: 200, height: 80))
var scoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 80))

//ad vars
var firstGameStarted = false;
var roundCounter = 0;


class block: SKSpriteNode
{
    var vertPos:Int = 0 //starting from the top it's the position of the color cell so 1 for red 2 for blue ect
    var arrayVal:Int = 0
    var shapeColor:Int = 0
    var goalPositionBottom:CGFloat = 0
    var goalPositionTop:CGFloat = 0
    
    func addColor(_ ShapeColor:Int)
    {
        shapeColor = ShapeColor // 1, 2, 3, 4, 5, 6 1 = red, 2 = blue, 3 = yellow, green = 4 // 5 = purple, 6 = orange
        
        if(stage == 1) {
            
            if(shapeColor%2 == 0) {
                
                goalPositionTop = stage1Positions[0]
                goalPositionBottom = stage1Positions[1]
                
            }
            else if(shapeColor%2 == 1) {
                
                goalPositionBottom = stage1Positions[2]
                goalPositionTop = stage1Positions[3]
            }
            
            

            
        }
        //level two - adds orange and purple colors
        else if(stage == 2) {
            
            if(shapeColor == 5 || shapeColor == 6) {
                
                goalPositionBottom = stage2Positions[2]
                goalPositionTop = stage2Positions[3]
                
            }
            else if(shapeColor%2 == 0) {

                goalPositionTop = stage2Positions[0]
                goalPositionBottom = stage2Positions[1]
                
            }
            else if(shapeColor%2 == 1) {
                
                goalPositionBottom = stage2Positions[4]
                goalPositionTop = stage2Positions[5]
                
            }
        }
        //level three adds lightblue and lightgreen
            
        //stage3Positions = [self.size.height / 4, 0, self.size.height / 4, (self.size.height/4)*2,(self.size.height / 4)*2 , (self.size.height / 4)*3, (self.size.height / 4)*3, self.size.height]
            
            // 1, 2, 3, 4, 5, 6 1 = red, 2 = blue, 3 = yellow, green = 4 // 5 = purple, 6 = orange 7 = lightblue 8 = lightgreen
            
            
        else if(stage == 3) {
            
            if(shapeColor == 7 || shapeColor == 8) {
                
                goalPositionBottom = stage3Positions[2]
                goalPositionTop = stage3Positions[3]
                
            }
            else if(shapeColor == 5 || shapeColor == 6) {
                
                goalPositionBottom = stage3Positions[4]
                goalPositionTop = stage3Positions[5]
                
            }
            else if(shapeColor%2 == 0) {
                
                goalPositionTop = stage3Positions[0]
                goalPositionBottom = stage3Positions[1]
                
            }
            else if(shapeColor%2 == 1) {
                
                goalPositionBottom = stage3Positions[6]
                goalPositionTop = stage3Positions[7]
                
            }
            
        }
        
    }
    
    func goalPosBottom() -> CGFloat {
        
        return goalPositionBottom
        
    }
    func goalPosTop() -> CGFloat {
        
        return goalPositionTop
        
    }
    
    
    func getColor() -> Int {
        
        return shapeColor
        
    }
    
    func getArrayVal() -> Int
    {
        
        return arrayVal
        
        
    }
    
    func setArrayIndex(_ value:Int)
    {
        
        arrayVal = value
        
    }
    func shiftArray(_ removed:Int)
    {
        if (arrayVal > removed) {
        arrayVal -= 1
        }
    }
}

class GameScene: SKScene {
    
    func updateScore(_ fallBlock:block) {
    
        fallBlock.removeFromParent()
        currentScore += 1
        scoreLabel.text = String(currentScore)
        nodesToCheck.remove(at: fallBlock.arrayVal)
        removedAt = fallBlock.arrayVal
        
        
        for fallBlock in nodesToCheck
        {
            fallBlock.shiftArray(removedAt)
        }
    
        if(currentScore > 19 && stage < 2) {
            
            background.texture = SKTexture(imageNamed: "ColorSwarmBackGroundStage2.png")
            stage = 2
        }
        if(currentScore > 49 && stage < 3) {
            
            background.texture = SKTexture(imageNamed: "ColorSwarmBackGroundStage3.png")
            stage = 3
        }
        
    }
    
    func createScene()
    {
        roundCounter+=1;
        firstGameStarted = true;
        
        audioPlayer.play()
        
        background.texture = SKTexture(imageNamed: "ColorSwarmBackGroundStage1.png")
        
        HighScoreLabel.removeFromSuperview()
        
        gameSpeed = 6.0
        gameSpawn = 2.0
        
        secondsPast = 0
        nodesToCheck.removeAll()
        gameInProgress = true
        currentScore = 0
        scoreLabel.text = String(currentScore)
        scoreLabel.font = UIFont.systemFont(ofSize: 100)
        scoreLabel.textAlignment = NSTextAlignment.center
        scoreLabel.textColor = UIColor(red:26/255,
            green:26/255,
            blue: 26/255,
            alpha:0.7)
        scoreLabel.center = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        
        self.view?.addSubview(scoreLabel)
        
        blockTimer = Timer.scheduledTimer(timeInterval: gameSpawn, target: self, selector: #selector(GameScene.spawnBlock), userInfo: nil, repeats: true)
        secondTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameScene.timerTick), userInfo: nil, repeats: true)
        
        
        background.size.width = self.size.width
        background.size.height = self.size.height
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        
        
    }
    
    //end the game and reset the scene to the menu
    func gameOver() {
        
        if(firstGameStarted == true && roundCounter % 3 == 0) {
            NotificationCenter.default.post(name: Notification.Name("showAd") as NSNotification.Name, object: nil)
        }
        
        stage = 1
        
            audioPlayer.stop()
            audioPlayer.currentTime = 0
        
        
        
        background.texture = SKTexture(imageNamed: "GameOver.png")
        
        //Load high score and set HighScoreLabel's value to it
        
        let HighscoreDefault = UserDefaults.standard
        
        if (HighscoreDefault.value(forKey: "HighScore") != nil)  {
            
            HighScore = HighscoreDefault.value(forKey: "HighScore") as! NSInteger!
            
        }
        else {
            
            HighScoreLabel.text = String(format: "HighScore: %i", 0)
            HighScore = 0
            
            
        }
        /* Setup your scene here */
        
        scoreLabel.text = String(currentScore)
        scoreLabel.font = UIFont.systemFont(ofSize: 95)
        scoreLabel.textAlignment = NSTextAlignment.center
        scoreLabel.textColor = UIColor(red:26/255,
            green:26/255,
            blue: 26/255,
            alpha:0.7)
        
        scoreLabel.center = CGPoint(x: self.size.width / 2, y: self.size.height / 2.0)
        
        
        HighScoreLabel.center = CGPoint(x: self.size.width / 2, y: self.size.height / 1.65)
        HighScoreLabel.textAlignment = NSTextAlignment.center
        HighScoreLabel.textColor = UIColor(red:26/255,
            green:26/255,
            blue: 26/255,
            alpha:0.7)
        HighScoreLabel.font = UIFont.systemFont(ofSize: 25)
        
        if (currentScore > HighScore) {
            let HighscoreDefault = UserDefaults.standard
            
            
        
            HighscoreDefault.setValue(currentScore, forKey: "HighScore")
            HighScoreLabel.text = String(format:"HighScore: %i", currentScore)
        }
        else {
            
            HighScoreLabel.text = String(format: "HighScore: %i", HighScore)
            
        }
        
        
        blockTimer.invalidate()
        secondTimer.invalidate()
        self.removeAllChildren()
        self.removeAllActions()
        restartButton.position = CGPoint(x: self.size.width / 2, y: self.size.height / 5)
        restartButton.size.width = 100
        restartButton.size.height = 100
        restartButton.zPosition = 11
        self.addChild(restartButton)
        
        
        
        background.texture = SKTexture(imageNamed: "GameOver2.png")
        background.size.width = self.size.width
        background.size.height = self.size.height
        background.position.x = self.size.width / 2
        background.position.y = self.size.height / 2
        self.addChild(background)
        
        
        
        self.view?.addSubview(HighScoreLabel)
        
    }
    //end of game over function
    
    //detect a finger flick on square objects
    func flickMove(_ object:SKSpriteNode)
    {
           let flickAction = SKAction.moveBy(x: ((end.x-end.x / 2) - (start.x-start.x / 2)) * 4, y: (end.y - start.y) * 4, duration: 1.0)
        
        object.removeAllActions()
        object.run(SKAction.repeatForever(flickAction))
        containsStart = false
        object.run(whoosh)
        
        
        
        object.run(SKAction.sequence([SKAction.scale(by: 0, duration: 2.5), SKAction(scoreMinusOne(object))]))
        
    }
    
    func scoreMinusOne(_ object:SKSpriteNode) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            
            if(!(object.position.x < 13 || object.position.x > self.size.width-13) && gameInProgress == true) {
                
                if(currentScore > 0) {
                    currentScore -= 1
                }
                
                object.removeFromParent()
                
                scoreLabel.text = String(currentScore)
                
            }
            else {
                object.removeFromParent()
            }
        })
    }
    
    func spawnBlock()
    {
        
        
        
        
        if(stage == 1) {
            randomBlock = Int(arc4random_uniform(4) + 1)
        }
        else if(stage == 2) {
            randomBlock = Int(arc4random_uniform(6) + 1)
        }
        else if(stage == 3) {
            randomBlock = Int(arc4random_uniform(8) + 1)
        }
        randomBlockX = CGFloat(arc4random_uniform(UInt32(self.size.width - 100)) + 50 )
        
        fallBlockHitArea = SKSpriteNode()
        fallBlockHitArea.size.height = 60
        fallBlockHitArea.size.width = 60
        
        
        
        fallBlock = block(imageNamed: String(format: "block%i" ,randomBlock, ".png"))
        
        
        fallBlock.name = String(nodesToCheck.count)
        fallBlock.addColor(randomBlock) // 1, 2, 3, 4 1=red 2=blue 3=yellow green=4
        fallBlock.size.width = 30
        fallBlock.size.height = 30
        fallBlock.position = CGPoint(x: randomBlockX, y: self.size.height)
        fallBlock.zPosition = 1
        self.addChild(fallBlock)
        nodesToCheck.append(fallBlock)
        
        fallBlock.setArrayIndex(nodesToCheck.count - 1)
        
        fallBlock.addChild(fallBlockHitArea)
        
        let screenSize = UIScreen.main.bounds
        let height = screenSize.height
        
        let fallAction = SKAction.moveBy(x: 0, y: -(height+fallBlock.size.height), duration: gameSpeed)
        
        fallBlock.run(fallAction, withKey: "fallAction")
            
        
        
        
    }
    
    func timerTick() {
    
        
        secondsPast+=1
        
        
        
        /*if(secondsPast > colorHideInterval) {
            
           
           colorHideInterval += Int(arc4random_uniform(15)+10)
            
            blankBack.size.height = self.size.height
            blankBack.size.width = self.size.width
            
            blankBack.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
            
            blankBack.alpha = 0
            blankBack.zPosition = 0.5
           
            self.addChild(blankBack)
            
            blankBack.runAction(SKAction.sequence([SKAction.fadeInWithDuration(2), SKAction.fadeOutWithDuration(2), SKAction.fadeInWithDuration(1), SKAction.fadeOutWithDuration(3), SKAction.removeFromParent()]))
            
        }*/
        
        
        if (secondsPast > speedCounter) {
            speedCounter += 3
            
            
            if (gameSpeed > 2.5) {
                gameSpeed -= 0.1
                
            }
            
            
            if(gameSpawn > 0.9) {
                gameSpawn -= 0.1
                
                blockTimer.invalidate()
                
                blockTimer = Timer.scheduledTimer(timeInterval: gameSpawn, target: self, selector: #selector(GameScene.spawnBlock), userInfo: nil, repeats: true)
            }
        }
        
    
    }
   
    
    
    override func didMove(to view: SKView) {
    
        //create the starting scene Function

        NotificationCenter.default.post(name: Notification.Name("loadAd") as NSNotification.Name, object: nil)
        
        stage1Positions = [self.size.height / 2, 0, self.size.height / 2, self.size.height]
        
        stage2Positions = [self.size.height / 3, 0, self.size.height / 3, (self.size.height/3)*2,(self.size.height / 3)*2 , self.size.height]
        
        stage3Positions = [self.size.height / 4, 0, self.size.height / 4, (self.size.height/4)*2,(self.size.height / 4)*2 , (self.size.height / 4)*3, (self.size.height / 4)*3, self.size.height]
        
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soarAudio)
        } catch {
            print("No sound found by URL:\(soarAudio)")
        }
        audioPlayer.prepareToPlay()
        
        gameOver()
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.location(in: self)
            
            
                start = location
            
            
                    if (restartButton.contains(location) && gameInProgress == false)
                    {
                        
                        createScene()
                        restartButton.removeFromParent()
                
                    }
                    for fallBlock in nodesToCheck
                    {
                    
                        if (fallBlock.contains(location))
                        {
                    
                            containsStart = true
                            objSelect = fallBlock
                    
                        }
                        
                    }
            
            }
        
            
        
        
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        
            //called when touches end/////////
        
        for touch in touches
        {
            let location = touch.location(in: self)
            
            
            end = location
            
         
            
        }
        
        
        for fallBlock in nodesToCheck
        {
            

            
            if (containsStart == true && fallBlock == objSelect)
            {
                
                flickMove(objSelect)
                containsStart = false
                
            }
            
        }
        
        
        
        
        
    }
    
   
    override func update(_ currentTime: TimeInterval)
    {
        /* Called before each frame is rendered */
        
        
        if(gameInProgress == true)
        {
            
            for fallBlock in nodesToCheck
            {
            
            
            
            if fallBlock.position.y < 0
            
            {
                fallBlock.removeFromParent()
                gameOver()
                gameInProgress = false
                nodesToCheck.remove(at: fallBlock.arrayVal)

                
                let removedAt:Int = fallBlock.arrayVal
                
                for fallBlock in nodesToCheck
                {
                    fallBlock.shiftArray(removedAt)
                }
                
                
                
                
            }
                
            
            if fallBlock.position.x < 11
                    
            {
                
                
                
                if((fallBlock.getColor()==1 || fallBlock.getColor() == 2 || fallBlock.getColor() == 5 || fallBlock.getColor() == 7) && (fallBlock.position.y > fallBlock.goalPositionBottom && fallBlock.position.y < fallBlock.goalPositionTop)) {
                    
                    updateScore(fallBlock)
                    
                }
                else
                {
                    fallBlock.removeFromParent()
                    gameOver()
                    gameInProgress = false
                }

            }
            else if fallBlock.position.x > self.size.width - 11
            {
                if((fallBlock.getColor() == 3 || fallBlock.getColor() == 4 || fallBlock.getColor() == 6 || fallBlock.getColor() == 8) && (fallBlock.position.y > fallBlock.goalPositionBottom && fallBlock.position.y < fallBlock.goalPositionTop)) {
                    
                    updateScore(fallBlock)
                    
                }
                else
                {
                    
                    fallBlock.removeFromParent()
                    gameOver()
                    gameInProgress = false
                }

            }
        }
            
        }
        
    }
    
}
