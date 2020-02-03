//
//  Turtle.swift
//  TheOcean
//
//  Created by Gabriel Sousa on 02/02/20.
//  Copyright © 2020 Gabriel Sousa. All rights reserved.
//

import SpriteKit

enum TurtlePosition {
    case left
    case rigth
    case midle
}

class Turtle {
    
    public var node: SKSpriteNode?
    public var superView: SKView?
    public var position: TurtlePosition? {
        didSet {
            setPosition()
        }
    }
    
    public init(node: SKSpriteNode, superView: SKView) {
        self.node = node
        self.node?.position.y = -350
        self.superView = superView
        position = .midle
    }
    
    func setPosition() {
        var x = 0
        switch position {
        case .midle:
            x = StaticValues.midleX
        case .rigth:
            x = StaticValues.rigthX
        case .left:
            x = StaticValues.leftX
        default:
            return
        }
        
        let action = SKAction.moveTo(x: CGFloat(x), duration: 0.15)
        node?.run(action)
    }
    
    func moveRigth() {
        switch position {
        case .left:
            position = .midle
        case .midle:
            position = .rigth
        default:
            print("default")
        }
    }
    
    func moveLeft() {
        switch position {
        case .rigth:
            position = .midle
        case .midle:
            position = .left
        default:
            print("default")
        }
    }
}
