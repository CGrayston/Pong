//
//  GameScene.swift
//  Pong
//
//  Created by Christopher Grayston on 5/2/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var ball = SKSpriteNode()
    var enemy = SKSpriteNode()
    var main = SKSpriteNode()
    
    var button = SKSpriteNode()
    var buttonLabel = SKLabelNode()
    
    var enemyLabel = SKLabelNode()
    var mainLabel = SKLabelNode()
    
    var Vix = 10
    var Viy = 10
    
    var score = [0,0]
    
    override func didMove(to view: SKView) {
        
        // Create Button and label
        button = SKSpriteNode(color: SKColor.red, size: CGSize(width: 200, height: 50))
        button.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        
        buttonLabel.text = "Start Game"
        buttonLabel.fontName = "LLPIXEL3.ttf"
        button.position = CGPoint(x:self.frame.midX, y:self.frame.midY + 12.5)
        
        self.addChild(button)
        self.addChild(buttonLabel)
        
        // Create labels
        enemyLabel = self.childNode(withName: "enemyLabel") as! SKLabelNode
        mainLabel = self.childNode(withName: "mainLabel") as! SKLabelNode
        
        // Create Nodes
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        enemy = self.childNode(withName: "enemy") as! SKSpriteNode
        main = self.childNode(withName: "main") as! SKSpriteNode
        
        // Set up ball and paddles
        enemy.position.y = (self.frame.height / 2) -  50
        main.position.y = (-self.frame.height / 2) + 50
        ball.isHidden = true
        
        // Create border
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        border.restitution = 1
        self.physicsBody = border
    }
    
    func startGame() {
        
        
        // Update score labels
        enemyLabel.text = "\(score[1])"
        mainLabel.text = "\(score[0])"
        
        // Start ball's velocity
        let randomVelocityX = Int.random(in: 10...15)
        let randomVelocityY = Int.random(in: 10...15)
        self.Vix = randomVelocityX
        self.Viy = randomVelocityY
        let xSign = Bool.random()
        
        
        // Tied score random y direction
        if score[0] == score[1] {
            xSign ? ball.physicsBody?.applyImpulse(CGVector(dx: Vix, dy: Viy)) : ball.physicsBody?.applyImpulse(CGVector(dx: Vix, dy: -Viy))
        } else if score[0] > score[1] {
            xSign ? ball.physicsBody?.applyImpulse(CGVector(dx: Vix, dy: -Viy)) : ball.physicsBody?.applyImpulse(CGVector(dx: -Vix, dy: -Viy))
        } else {
            xSign ? ball.physicsBody?.applyImpulse(CGVector(dx: Vix, dy: Viy)) : ball.physicsBody?.applyImpulse(CGVector(dx: -Vix, dy: Viy))
        }
        
        // Hide button
        button.isHidden = true
        buttonLabel.isHidden = true
        ball.isHidden = false
    }
    
    func addScore(playerWhoWon: SKSpriteNode) {
        ball.position = CGPoint(x: 0, y: 0)
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        
        if playerWhoWon == main {
            score[0] += 1
            //ball.physicsBody?.applyImpulse(CGVector(dx: Vix, dy: Viy))
            mainLabel.text = "\(score[0])"
        } else if playerWhoWon == enemy {
            score[1] += 1
            //ball.physicsBody?.applyImpulse(CGVector(dx: -Vix, dy: -Viy))
            enemyLabel.text = "\(score[1])"
        }
        
        // Unhide button
        button.isHidden = false
        buttonLabel.isHidden = false
        ball.isHidden = true
        
        enemy.position.x = 0
        main.position.x = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            // Grab location of finger inside of a view
            let location = touch.location(in: self)
            
            if currentGameType == .player2 {
                if location.y > 0 {
                    enemy.run(SKAction.moveTo(x: location.x, duration: 0.2))
                }
                if location.y < 0 {
                    main.run(SKAction.moveTo(x: location.x, duration: 0.2))
                }
            } else {
                main.run(SKAction.moveTo(x: location.x, duration: 0.2))
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            // Grab location of finger inside of a view
            let location = touch.location(in: self)
            
            if currentGameType == .player2 {
                if location.y > 0 {
                    enemy.run(SKAction.moveTo(x: location.x, duration: 0.2))
                }
                if location.y < 0 {
                    main.run(SKAction.moveTo(x: location.x, duration: 0.2))
                }
            } else {
                main.run(SKAction.moveTo(x: location.x, duration: 0.2))
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            // When button is clicked on and not hidden
            if button.contains(location) && !button.isHidden{
                // Start game
                startGame()
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        switch currentGameType {
        case .easy:
            enemy.run(SKAction.moveTo(x: ball.position.x, duration: 1.3))
            break
        case .medium:
            enemy.run(SKAction.moveTo(x: ball.position.x, duration: 1.0))
            break
        case .hard:
            enemy.run(SKAction.moveTo(x: ball.position.x, duration: 0.2))
            break
        case .player2:
            break
        case .unset:
            fatalError("Unset game type on GameScene.swift")
            break
        }
        
        if ball.position.y <= main.position.y - 30 {
            addScore(playerWhoWon: enemy)
        } else if ball.position.y >= enemy.position.y + 30 {
            addScore(playerWhoWon: main)
        }
    }
}
