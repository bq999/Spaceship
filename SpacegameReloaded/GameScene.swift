//
//  GameScene.swift
//  SpacegameReloaded
//
//  Created by Bilal Qaiser on 22/02/2018.
//  Copyright © 2018 Bilal Qaiser. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var starfield:SKEmitterNode!
    var player:SKSpriteNode!
    var invincible = false
    var gameOver = false

    var scoreLabel:SKLabelNode!
    var score:Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var liveLabel:SKLabelNode!
    var live:Int = 5 {
        didSet {
            liveLabel.text = "Lives: \(live)"
        }
    }
    
    var gameTimer:Timer!
    var gameTimer2:Timer!

    var possibleAliens = ["alien", "alien3"]
    
    let alienCategory:UInt32 = 0x1 << 1
    let photonTorpedoCategory:UInt32 = 0x1 << 0
    
    
    let motionManger = CMMotionManager()
    var xAcceleration:CGFloat = 0

    override func didMove(to view: SKView) {
        
        starfield = SKEmitterNode(fileNamed: "Starfield")
        starfield.position = CGPoint(x: 0, y: 1472)
        starfield.advanceSimulationTime(10)
        self.addChild(starfield)
        
        starfield.zPosition = -1
        
        player = SKSpriteNode(imageNamed: "shuttle")
        player.name = "player"

        player.position = CGPoint(x: self.frame.size.width / 2, y: player.size.height / 2 + 20)
        
        self.addChild(player)
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: 100, y: self.frame.size.height - 60)
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        scoreLabel.fontSize = 30
        scoreLabel.fontColor = UIColor.white
        score = 0
        
        self.addChild(scoreLabel)
        
        
        liveLabel = SKLabelNode(text: "Live: 3")
        liveLabel.position = CGPoint(x: 100, y: self.frame.size.height - 100)
        liveLabel.fontName = "AmericanTypewriter-Bold"
        liveLabel.fontSize = 30
        liveLabel.fontColor = UIColor.white
        live = 5
        
        self.addChild(liveLabel)
        
        
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(addAlien), userInfo: nil, repeats: true)
        
        gameTimer2 = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(addAlien2), userInfo: nil, repeats: true)
        
        motionManger.accelerometerUpdateInterval = 0.2
        motionManger.startAccelerometerUpdates(to: OperationQueue.current!) { (data:CMAccelerometerData?, error:Error?) in
            if let accelerometerData = data {
                let acceleration = accelerometerData.acceleration
                self.xAcceleration = CGFloat(acceleration.x) * 0.75 + self.xAcceleration * 0.25
            }
        }
        
 
        
    }
    
    
    
    func addAlien () {
        possibleAliens = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleAliens) as! [String]
        
        let alien = SKSpriteNode(imageNamed: possibleAliens[0])

        alien.name = "alien"
        let randomAlienPosition = GKRandomDistribution(lowestValue: 0, highestValue: 414)
        let position = CGFloat(randomAlienPosition.nextInt())
        
        alien.position = CGPoint(x: position, y: self.frame.size.height + alien.size.height)
        
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
        alien.physicsBody?.isDynamic = true
        
        alien.physicsBody?.categoryBitMask = alienCategory
        alien.physicsBody?.contactTestBitMask = photonTorpedoCategory
        alien.physicsBody?.collisionBitMask = 0
        
        self.addChild(alien)
        
        let animationDuration:TimeInterval = 6
        
        var actionArray = [SKAction]()
        
        
        actionArray.append(SKAction.move(to: CGPoint(x: position, y: -alien.size.height), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        
        alien.run(SKAction.sequence(actionArray))
        
    
    }
    
    
    func addAlien2 () {

        
        let alien2 = SKSpriteNode(imageNamed: "alien2")
        
        alien2.name = "alien2"
        let randomAlienPosition = GKRandomDistribution(lowestValue: 0, highestValue: 414)
        let position = CGFloat(randomAlienPosition.nextInt())
        
        alien2.position = CGPoint(x: position, y: self.frame.size.height + alien2.size.height)
        
      
        self.addChild(alien2)
        
        let animationDuration:TimeInterval = 6
        
        var actionArray = [SKAction]()
        
        
        actionArray.append(SKAction.move(to: CGPoint(x: position, y: -alien2.size.height), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        
        alien2.run(SKAction.sequence(actionArray))
        
        
    }
    
    
    
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        fireTorpedo()
    }
    
    
    func fireTorpedo() {
        self.run(SKAction.playSoundFileNamed("torpedo.mp3", waitForCompletion: false))
        
        let torpedoNode = SKSpriteNode(imageNamed: "torpedo")
        torpedoNode.position = player.position
        torpedoNode.position.y += 5
        
        torpedoNode.physicsBody = SKPhysicsBody(circleOfRadius: torpedoNode.size.width / 2)
        torpedoNode.physicsBody?.isDynamic = true
        
        torpedoNode.physicsBody?.categoryBitMask = photonTorpedoCategory
        torpedoNode.physicsBody?.contactTestBitMask = alienCategory
        torpedoNode.physicsBody?.collisionBitMask = 0
        torpedoNode.physicsBody?.usesPreciseCollisionDetection = true
        
        self.addChild(torpedoNode)
        
        let animationDuration:TimeInterval = 0.3
        
        
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: player.position.x, y: self.frame.size.height + 10), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        
        torpedoNode.run(SKAction.sequence(actionArray))
        
        
        
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody:SKPhysicsBody
        var secondBody:SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if (firstBody.categoryBitMask & photonTorpedoCategory) != 0 && (secondBody.categoryBitMask & alienCategory) != 0 {
           torpedoDidCollideWithAlien(torpedoNode: firstBody.node as! SKSpriteNode, alienNode: secondBody.node as! SKSpriteNode)
        }
        
    }
    
    
    func torpedoDidCollideWithAlien (torpedoNode:SKSpriteNode, alienNode:SKSpriteNode) {
    
        let explosion = SKEmitterNode(fileNamed: "Explosion")!
        explosion.position = alienNode.position
        self.addChild(explosion)
        
        self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
        
        torpedoNode.removeFromParent()
        alienNode.removeFromParent()
        
        
        self.run(SKAction.wait(forDuration: 2)) { 
            explosion.removeFromParent()
        }
        
        score += 5
        
        
    }
    
    override func didSimulatePhysics() {
        
        player.position.x += xAcceleration * 50
        
        if player.position.x < -20 {
            player.position = CGPoint(x: self.size.width + 20, y: player.position.y)
        }else if player.position.x > self.size.width + 20 {
            player.position = CGPoint(x: -20, y: player.position.y)
        }
        
    }
    
    
    func shipHit(enemy: SKSpriteNode) {
        invincible = true
        enemy.name = "player"
        
        let blinkTimes = 10.0
        let duration = 3.0
        let blinkAction = SKAction.customAction(withDuration: duration) { node, elapsedTime in
            let slice = duration / blinkTimes
            let remainder = Double(elapsedTime).truncatingRemainder(
                dividingBy: slice)
            node.isHidden = remainder > slice / 2
        }
        
        
        let setHidden = SKAction.run() { [weak self] in
            enemy.isHidden = false
            self?.invincible = false
        }
        enemy.run(SKAction.sequence([blinkAction, setHidden]))
        live -= 1
        
    }
    
    
    func checkCollisions() {
        
        if invincible {
            return
        }
        
        var hitEnemies: [SKSpriteNode] = []
        enumerateChildNodes(withName: "player") { node, _ in
            let ship = node as! SKSpriteNode
            
            self.enumerateChildNodes(withName: "alien") { node, _ in
                let alien = node as! SKSpriteNode
                
                if alien.frame.intersects(ship.frame) {
                    hitEnemies.append(ship)
                }
            }
        }
        
        
        enumerateChildNodes(withName: "player") { node, _ in
            let ship = node as! SKSpriteNode
            
            self.enumerateChildNodes(withName: "alien2") { node, _ in
                let alien = node as! SKSpriteNode
                
                if alien.frame.intersects(ship.frame) {
                    hitEnemies.append(ship)
                }
            }
        }
        
        
        
        for enemy in hitEnemies {
            shipHit(enemy: enemy)
        }
    }
    
    override func didEvaluateActions() {
        checkCollisions()
    }
    
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if live == 0 {
            gameOver = true
            print("You lose!")
            // backgroundMusicPlayer.stop()
            
            let gameOverScene = GameOverScene(size: size, won: false)
            gameOverScene.scaleMode = scaleMode
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            view?.presentScene(gameOverScene, transition: reveal)
        }
        
        if  score == 250 {
            gameOver = true
            print("You win!")
           // backgroundMusicPlayer.stop()
            
            let gameOverScene = GameOverScene(size: size, won: true)
            gameOverScene.scaleMode = scaleMode
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            view?.presentScene(gameOverScene, transition: reveal)
        }
    }
}
