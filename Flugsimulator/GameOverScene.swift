//
//  GameOverScene.swift
//  Flugsimulator
//
//  Created by Mohamedsadiq on 04.02.21.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    let restartLabel = SKLabelNode(fontNamed: "theboldfont")

    
    override func didMove(to view: SKView){
        // this attribute should change to the Distance
        
        let background = SKSpriteNode(imageNamed: "background")
        background.size = CGSize(width: self.frame.maxX, height: self.frame.maxY)
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        
        let gameOverLabel = SKLabelNode(fontNamed: "theboldfont")
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 200
        gameOverLabel.fontColor = SKColor.black
        gameOverLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.7)
        gameOverLabel.zPosition = 1
        self.addChild(gameOverLabel)
        
        let scoreLabel = SKLabelNode(fontNamed: "theboldfont")
        let y = Double(round(1000 * distance)/1000)
//        var b:String = String(format: "%0.2f",distance)
        scoreLabel.text = "Score: \(y)"
        scoreLabel.fontSize = 125
        scoreLabel.fontColor = SKColor.black
        scoreLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.55)
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
        
        UserConfig.saveUserScore(currentScore: distance);

        let highScoreLabel = SKLabelNode(fontNamed: "theboldfont")
            
        highScoreLabel.text = "High Scores: "
        highScoreLabel.fontSize = 110
        highScoreLabel.fontColor = SKColor.black
        highScoreLabel.zPosition = 1
        highScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.45)
        self.addChild(highScoreLabel)
        
        let scoresLabel = SKLabelNode(fontNamed: "theboldfont")
        scoresLabel.text = "\(UserConfig.getUserScores())"
        scoresLabel.fontSize = 60
        scoresLabel.fontColor = SKColor.black
        scoresLabel.zPosition = 1
        scoresLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.38)
        self.addChild(scoresLabel)
        
        restartLabel.text = "RESTART"
        restartLabel.fontSize = 90
        restartLabel.fontColor = SKColor.black
        restartLabel.zPosition = 1
        restartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.3)
        self.addChild(restartLabel)
        
    }
    
    
    // Restarn Label is working now as a Button
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            
            if restartLabel.contains(pointOfTouch) {
                
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.3)
                self.view!.presentScene(sceneToMoveTo,transition: myTransition)
            }
            
        }
        
    }
}
