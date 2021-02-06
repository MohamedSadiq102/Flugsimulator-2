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
//        distance = 0.0
//        let backgroundImage = UIImageView(image: UIImage(named: "background"))
//        backgroundImage.frame = self.frame
//        self.view?.addSubview(backgroundImage)
        
        
        
        let background = SKSpriteNode(imageNamed: "background")
        background.size = CGSize(width: self.frame.maxX, height: self.frame.maxY)
//        background.size = self.size
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
        var b:String = String(format: "%0.2f",distance)
        scoreLabel.text = "Score: \(b)"
        scoreLabel.fontSize = 125
        scoreLabel.fontColor = SKColor.black
        scoreLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.55)
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
        
        var array: Array<Double> = Array(repeating: 0, count: 10)

//
        let defaults = UserDefaults.standard
        //var arr = defaults.array(forKey: "highScoreSaved")
       // defaults.set(array, forKey: "highScoreSaved")

        if var arr = defaults.array(forKey: "highScoreSaved") as? [String] {
            if let firstValue = Double(arr[arr.count - 1]) {
                if distance > firstValue {
                    
                    arr[arr.count - 1] = b
        //            array.append(distance)
                    arr = arr.sorted().reversed()
                    
                    defaults.set(arr, forKey: "highScoreSaved")


                    
                }
                
                
                
            }
            
            let highScoreLabel = SKLabelNode(fontNamed: "theboldfont")
    //        var n:String = String(format: "%0.2f",highScoreNumber)
            
            highScoreLabel.text = "High Score: \n \(arr)"
            highScoreLabel.fontSize = 40
            highScoreLabel.fontColor = SKColor.black
            highScoreLabel.zPosition = 1
            highScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.45)
            self.addChild(highScoreLabel)


        } else {
            defaults.setValue(Array(repeating: "0.0", count: 10), forKey: "highScoreSaved")
            
            let highScoreLabel = SKLabelNode(fontNamed: "theboldfont")
            highScoreLabel.text = "High Score: \n \(b)"
            highScoreLabel.fontSize = 40
            highScoreLabel.fontColor = SKColor.black
            highScoreLabel.zPosition = 1
            highScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.45)
            self.addChild(highScoreLabel)

            
        }
//
//        if distance > arr[0] {
//            arr[0] = distance
////            array.append(distance)
//            arr = arr.sorted()
//            defaults.set(arr, forKey: "highScoreSaved")
//        }

        

//        var array2: Array<Double> = insertionSort(array)
        
        
//        let defaults = UserDefaults()
//        var highScoreNumber = defaults.double(forKey: "highScoreSaved")
//
//        if distance > highScoreNumber {
//            highScoreNumber = distance
//            defaults.set(highScoreNumber, forKey: "highScoreSaved")
//        }
        
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
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo,transition: myTransition)
            }
            
        }
        
    }
}
