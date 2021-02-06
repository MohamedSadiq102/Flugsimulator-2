//
//  GameViewController.swift
//  Flugsimulator
//
//  Created by Mohamedsadiq on 07.01.21.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    



    override func viewDidLoad() {
        super.viewDidLoad()
//        startGame()


            let scene = GameScene(size: CGSize(width: 1536, height: 2048))
                    
            let view = self.view as! SKView
            view.showsFPS = true
            view.showsNodeCount = true
            view.ignoresSiblingOrder = true
                    
            scene.scaleMode = .aspectFill
//                    
//        scene.size = self.view.bounds.size
            // Present the scene
            view.presentScene(scene)                

    }

//    var startTime = TimeInterval()
//    var timer = Timer()
//    var gameTime:Double = 120
//
//
//    func startGame() {
//
//        let aSelector : Selector = Selector(("updateTime"))
//        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: aSelector, userInfo: nil, repeats: true)
//        startTime = NSDate.timeIntervalSinceReferenceDate
//
//    }
//
//    func updateTime() {
//        let currentTime = NSDate.timeIntervalSinceReferenceDate
//        var elapsedTime = currentTime - startTime
//        let seconds = gameTime-elapsedTime
//        if seconds > 0 {
//            elapsedTime -= TimeInterval(seconds)
////            println("\(Int(seconds))")
//        } else {
//            timer.invalidate()
//        }
//    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
