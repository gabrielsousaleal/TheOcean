//
//  GameScene.swift
//  TheOcean
//
//  Created by Gabriel Sousa on 02/02/20.
//  Copyright © 2020 Gabriel Sousa. All rights reserved.
//

import SpriteKit
import GameplayKit
import AudioToolbox
import AVKit

class GameScene: SKScene {
    
    //****************************************************************
    //MARK: Objects
    //****************************************************************
    
    var turtle: Turtle!
    
    //****************************************************************
    //MARK: Variables
    //****************************************************************
    
    var timer: Timer?
    
    //****************************************************************
    //MARK: Game Settings
    //****************************************************************
    
    var enemiesFrequency: Double = 0.6
    var enemiesSpeed: Double = 1.6
    
    //****************************************************************
    //MARK: Colision Categories
    //****************************************************************
    
    let turtleCategory: UInt32 = 0x1 << 1
    let enemyCategory: UInt32 = 0x1 << 2
    let foodCategory: UInt32 = 0x1 << 3
    
    //****************************************************************
    //MARK: Life Cicle
    //****************************************************************
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        createTurtle()
        
        addGestures()
        
        callEnemies()
    }
    
    //****************************************************************
    //MARK: Create Objects
    //****************************************************************
    
    func createTurtle() {
        let node = SKSpriteNode(color: .black, size: CGSize(width: 64, height: 64))
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.categoryBitMask = turtleCategory
        node.physicsBody?.collisionBitMask = turtleCategory
        
        turtle = Turtle(node: node, superView: view!)
        
        addChild(turtle.node!)
    }
    
    @objc func createEnemy() {
        
        let node = SKSpriteNode(color: .red, size: CGSize(width: 32, height: 32))
        node.position.y = CGFloat(StaticValues.maxY)
        var nodeXPosition = 0
        
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody!.affectedByGravity = false
        node.physicsBody?.categoryBitMask = enemyCategory
        node.physicsBody?.contactTestBitMask =  turtleCategory
        
        let randomX = arc4random_uniform(3)
        
        switch randomX {
        case 0:
            nodeXPosition = StaticValues.rigthX
        case 1:
            nodeXPosition = StaticValues.leftX
        case 2:
            nodeXPosition = StaticValues.midleX
        default:
            print("default")
        }
        
        node.position.x = CGFloat(nodeXPosition)
        
        addChild(node)
        
        node.run(SKAction.moveTo(y: CGFloat(StaticValues.minY), duration: enemiesSpeed)) {
            node.removeFromParent()
        }
    }
    
    func callEnemies(){
        
        timer = Timer.init()
        
        timer = Timer.scheduledTimer(timeInterval: enemiesFrequency, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        
    }
    
    //****************************************************************
    //MARK: Gesture Functions
    //****************************************************************
    
    func addGestures() {
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(detectGesture))
        swipeUp.direction = .up
        swipeUp.name = "swipeUp"
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(detectGesture))
        swipeLeft.direction = .left
        swipeLeft.name = "swipeLeft"
        
        let swipeRigth = UISwipeGestureRecognizer(target: self, action: #selector(detectGesture))
        swipeRigth.direction = .right
        swipeRigth.name = "swipeRigth"
        
        view?.addGestureRecognizer(swipeUp)
        view?.addGestureRecognizer(swipeLeft)
        view?.addGestureRecognizer(swipeRigth)
    }
    
    @objc func detectGesture(sender: UIGestureRecognizer) {
        switch sender.name {
        case "swipeUp":
            print(1)
        case "swipeLeft":
            turtle.moveLeft()
        case "swipeRigth":
            turtle.moveRigth()
        default:
            print(4)
        }
    }
    
}

//****************************************************************
//MARK: Physics Delegate
//****************************************************************

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        
        let bodyA = contact.bodyA.categoryBitMask
        let bodyB = contact.bodyB.categoryBitMask
                
        if (bodyB == turtleCategory && bodyA == enemyCategory){
            
            if contact.bodyA.node!.parent == nil {return}
            contact.bodyA.node?.removeFromParent()
            //            decLife()
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        
        if (bodyB == enemyCategory && bodyA == turtleCategory){
            
            if contact.bodyB.node!.parent == nil {return}
            contact.bodyB.node?.removeFromParent()
            //            decLife()
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        
    }
}
