//
//  GameScene.swift
//  Flugsimulator
//
//  Created by Mohamedsadiq on 07.01.21.
//

import SpriteKit

var distance = 0.0

class GameScene:  SKScene, SKPhysicsContactDelegate {
    
    var counter = 0
    var counterTime = Timer()
    var counterStartValue = 120
    var literCapacity = 80.0
    
    var cloudCrash = 0

    var levelNumber = 0

    let timeLabel = SKLabelNode(fontNamed: "theboldfont")
    
    
    let distanceLabel = SKLabelNode(fontNamed: "theboldfont")

    
    let player = SKSpriteNode(imageNamed: "airplane")

    let tapToStartLabel = SKLabelNode(fontNamed: "the bold font")
    
    // 0 -> before a Game, 1 -> During a Game, 2 -> After the Game
    enum gameState {
        case PreGame
        case inGame
        case afterGame
    }
    
    var currentGameState = gameState.PreGame
    
    struct PhysicsCategories {
        static let None : UInt32 = 0
        static let Player : UInt32 = 0b1  //binary for 1 -> 0b1
//        static let Bullet : UInt32 = 0b10, 0b100  // 2
        static let Cloud  : UInt32 = 0b10   //binary for 4  player & bullet
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    var gameArea: CGRect
    
    override init(size: CGSize) {
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)

        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    override func didMove(to view: SKView){
//        cloudCrash = 0
        distance = 0.0
        
        self.physicsWorld.contactDelegate = self

        for i in 0...1 {
        
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.frame.size
        background.anchorPoint = CGPoint(x: 0.5, y: 0)
        // when the i = 0, the foto will be buttom of the screen, when 1 at the up of the screen
        background.position = CGPoint(x: self.size.width/2, y: self.size.height*CGFloat(i))
        background.zPosition = 0
        background.name = "Background"
        self.addChild(background)
            
        }
        player.setScale(0.05)
        player.position = CGPoint(x: self.size.width/2, y: 0 - player.size.height)
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.categoryBitMask = PhysicsCategories.Player
        player.physicsBody!.collisionBitMask = PhysicsCategories.None
        player.physicsBody!.contactTestBitMask = PhysicsCategories.Cloud
        self.addChild(player)

 
        timeLabel.text = "Time: \(counterStartValue)"
        timeLabel.fontSize = 70
        timeLabel.fontColor = SKColor.black
        timeLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        timeLabel.position = CGPoint(x: self.size.width*0.09, y: self.size.height + timeLabel.frame.size.height)
        timeLabel.zPosition = 100 // label will be safely always be on top of everything
        self.addChild(timeLabel)
        counter = counterStartValue
        
        
        distanceLabel.text = "Route: 0"
        distanceLabel.fontSize = 70
        distanceLabel.fontColor = SKColor.black
        distanceLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        distanceLabel.position = CGPoint(x: self.size.width*0.9, y: self.size.height*0.9 + distanceLabel.frame.size.height)
        distanceLabel.zPosition = 100
        self.addChild(distanceLabel)
        
        let moveOnToScreenAction = SKAction.moveTo(y: self.size.height*0.9, duration: 0.3)
        timeLabel.run(moveOnToScreenAction)
        distanceLabel.run(moveOnToScreenAction)
        
        tapToStartLabel.text = "Tap To Begin"
        tapToStartLabel.fontSize = 100
        tapToStartLabel.fontColor = SKColor.black
        tapToStartLabel.zPosition = 1
        tapToStartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        tapToStartLabel.alpha = 0 // 1 is normal, 0 is completely seepho , 0.5 is half see "hidden"
        self.addChild(tapToStartLabel)
                
        
        let fadeInAction = SKAction.fadeIn(withDuration: 0.5)
        tapToStartLabel.run(fadeInAction)
        
//        startNewLevel()
       
    }
    
    func startCounter() {
        counterTime = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(decrementCounter), userInfo: nil, repeats: true)
    }
    
    @objc func decrementCounter() {
        counter -= 1
        timeLabel.text = "Time: \(counter)"
        literCapacity -= 0.6667
        
        if counter < 1 || cloudCrash >= 3 {
            
            counterTime.invalidate()
        }
        if literCapacity <= 0 || cloudCrash >= 3 || counter < 1 {
            runGameOver()
        }
        
        if cloudCrash == 0 {
            distance += 0.24
//            var b:String = String(format: "%0.2f",distance)
            let y = Double(round(1000 * distance)/1000)
            distanceLabel.text = "Route: \(y)"
            print(y)
        }
        if cloudCrash == 1 {
            distance += 0.18
//            var b:String = String(format: "%0.2f",distance)
            let y = Double(round(1000 * distance)/1000)
            distanceLabel.text = "Route: \(y)"
            print(y)
        }
        if cloudCrash == 2 {
            distance += 0.12
//            var b:String = String(format: "%0.2f",distance.rounded())
            let y = Double(round(1000 * distance)/1000)
            distanceLabel.text = "Route: \(y)"
            print(y)
        }
        
    }
    
    
    func runGameOver() {
        
        currentGameState = gameState.afterGame
        
        self.removeAllActions()
        
        // this generate us a list of all objects with the reference name Cloud
        self.enumerateChildNodes(withName: "Cloud"){
            cloud, stop in
            
            cloud.removeAllActions()
        }
        
        let changeSceneAction = SKAction.run(changeScene)
        let waitToChangeScene = SKAction.wait(forDuration: 1)
        let changeSceneSquence = SKAction.sequence([waitToChangeScene, changeSceneAction])
        self.run(changeSceneSquence)
        
    }
    
    func changeScene(){

        let sceneToMoveTo = GameOverScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
        
        
    }
    
    // to store the time of the last frame,
    // to compare that with how much time is passed
    var lastUpdateTime: TimeInterval = 0
    var deltaFrameTime: TimeInterval = 0
    // the amount of the movement per second
    var amountToMovePerSecond: CGFloat = 600.0
    
    
    // will start at everyGame loop
    override func update(_ currentTime: TimeInterval) {
        
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime
        }else{
            deltaFrameTime = currentTime - lastUpdateTime
            lastUpdateTime = currentTime
        }
        // store how much we have to move each of our backgrounds
        let amountToMoveBackground = amountToMovePerSecond * CGFloat(deltaFrameTime)
        
        self.enumerateChildNodes(withName: "Background"){
            background, stop in
            if self.currentGameState == gameState.inGame{
            // how much we have to move our Background by
            background.position.y -= amountToMoveBackground
            }
            
            // background.position.y the ancher
            // if the first backgrounf less than second then move it
            if background.position.y < -self.size.height{
                background.position.y += self.size.height*2
            }
        }
    }
    
    
    
    func spwanCloud()  {
        
        let radomXStart = random(min: gameArea.minX, max: gameArea.maxX)
//        let randomXEnd  = random(min: gameArea.minX, max: gameArea.maxX)
        
        let startPoint = CGPoint(x: radomXStart, y: self.size.height * 1.2)
        let endPoint   = CGPoint(x: radomXStart, y: -self.size.height * 0.2)

        let cloud = SKSpriteNode(imageNamed: "cloud")
        cloud.name = "Cloud"
        cloud.setScale(0.7)
        cloud.position = startPoint
        cloud.zPosition = 1
        cloud.physicsBody = SKPhysicsBody(rectangleOf: cloud.size)
        cloud.physicsBody!.affectedByGravity = false
//         take the physicsbody of the enemy and put it in the PhysicsCategories.Enemy
        cloud.physicsBody!.categoryBitMask = PhysicsCategories.Cloud
//         we don't need the enemy phsicsbody to collise with anything
        cloud.physicsBody!.collisionBitMask = PhysicsCategories.None
//         ther are  or hits only with physicsabody of player
        cloud.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        
        self.addChild(cloud)
        
        let moveCloud = SKAction.move(to: endPoint, duration: 1.5)
        let deleteCloud = SKAction.removeFromParent()
        let cloudSequence = SKAction.sequence([moveCloud, deleteCloud])
        
        if currentGameState == gameState.inGame {
            cloud.run(cloudSequence)
            
        }
        
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {

        // player : airplane
        var body1 = SKPhysicsBody()
        // Cloud
        var body2 = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            
            body1 = contact.bodyA
            body2 = contact.bodyB
            
        }else{
            
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Cloud {
            cloudCrash += 1
            print("cloudcrash = \(cloudCrash)")
//            addScore()
            
            // if the player has hit the cloud we can delete the cloud if we want
            // or reduce the speed
            if body2.node != nil {
                body2.node?.removeFromParent()
            }
        }
        
    }
    
    func startNewLevel(){
        
        levelNumber += 1

        if self.action(forKey: "spawningClouds") != nil{
            self.removeAction(forKey: "spawningClouds")
        }

        var levelDuration = TimeInterval()

        switch levelNumber {
        case 1: levelDuration = 1.2
        case 2: levelDuration = 0.8
        case 3: levelDuration = 0.6
        case 4: levelDuration = 0.4
        default:
            levelDuration = 0.2
            print("can't find level info")
        }
        
        let spawn = SKAction.run(spwanCloud)
        let waitToSpawn = SKAction.wait(forDuration: levelDuration)
//        let waitToSpawn = SKAction.wait(forDuration: 0.5)
        let spawnSequence = SKAction.sequence([waitToSpawn, spawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnForever, withKey: "spawningClouds")
        self.run(spawnForever)
        
    }
    
    func startGame(){
        
        // the game status will change from pre to in
        currentGameState = gameState.inGame
        // the label will go after tapping on the screen
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        let deleteAction = SKAction.removeFromParent()
        let deleteSequence = SKAction.sequence([fadeOutAction, deleteAction])
        tapToStartLabel.run(deleteSequence)
        startCounter()
        
        // Ship should move on the bar this means only y axis is affected
        let moveShipOntoScreenAction = SKAction.moveTo(y: self.size.height*0.2, duration: 0.5)
        let startLevelAction = SKAction.run(startNewLevel)
        let startGameSequence = SKAction.sequence([moveShipOntoScreenAction, startLevelAction])
        player.run(startGameSequence)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if currentGameState == gameState.PreGame {
            startGame()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches {
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            
            let amountDragged = pointOfTouch.x - previousPointOfTouch.x
            
            if currentGameState == gameState.inGame {
                player.position.x += amountDragged
            }
  
            
            if player.position.x > gameArea.maxX { //- player.size.width/2 {
                player.position.x = gameArea.maxX  //- player.size.width/2
            }

            if player.position.x < gameArea.minX {//+ player.size.width/2  {
//            if player.position.x < CGRectEdge(gameArea){
                player.position.x = gameArea.minX  //+ player.size.width/2
            }
        }
    }
}



