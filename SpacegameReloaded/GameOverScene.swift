//
//  GameOverScene.swift
//  SpacegameReloaded
//
//  Created by Bilal Qaiser on 22/02/2018.
//  Copyright © 2018 Bilal Qaiser. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    let won:Bool
    
    init(size: CGSize, won: Bool) {
        self.won = won
        super.init(size: size)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        if (won) {
            let myLabel = SKLabelNode(fontNamed:"Chalkduster")
            myLabel.text = "You Win!"
            myLabel.fontSize = 50
            myLabel.position = CGPoint(x: size.width * 0.5, y: size.height * 0.65)
            
            let myLabel2 = SKLabelNode(fontNamed:"Chalkduster")
            myLabel2.text = "Created by:"
            myLabel2.fontSize = 30
            myLabel2.position = CGPoint(x: size.width * 0.5, y: size.height * 0.35)
            
            let myLabel3 = SKLabelNode(fontNamed:"Chalkduster")
            myLabel3.text = "Bilal Qaiser"
            myLabel3.fontSize = 30
            myLabel3.position = CGPoint(x: size.width * 0.5, y: size.height * 0.30)

            
            self.addChild(myLabel)
            self.addChild(myLabel2)
            self.addChild(myLabel3)

        } else {
            let myLabel = SKLabelNode(fontNamed:"Chalkduster")
            myLabel.text = "You Lose!"
            myLabel.fontSize = 50
            myLabel.position = CGPoint(x: size.width * 0.5, y: size.height * 0.65)
            
            let myLabel2 = SKLabelNode(fontNamed:"Chalkduster")
            myLabel2.text = "Created by:"
            myLabel2.fontSize = 30
            myLabel2.position = CGPoint(x: size.width * 0.5, y: size.height * 0.35)
            
            let myLabel3 = SKLabelNode(fontNamed:"Chalkduster")
            myLabel3.text = "Bilal Qaiser"
            myLabel3.fontSize = 30
            myLabel3.position = CGPoint(x: size.width * 0.5, y: size.height * 0.30)
            
            
            self.addChild(myLabel)
            self.addChild(myLabel2)
            self.addChild(myLabel3)
        }
        

        
        // More here...
        let wait = SKAction.wait(forDuration: 3.0)
        let block = SKAction.run {
            let myScene = GameScene(size: self.size)
            myScene.scaleMode = self.scaleMode
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            self.view?.presentScene(myScene, transition: reveal)
        }
        self.run(SKAction.sequence([wait, block]))
        
    }
    
}



