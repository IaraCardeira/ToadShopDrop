//
//  Collectible.swift
//  ToadApp(Skateboard)
//
//  Created by Iara cardeira on 21/03/2024.
//

import Foundation
import SpriteKit

// This enum lets you add different types of collectibles
enum CollectibleType: String {
    
    case none
    case gloop
}


class Collectible: SKSpriteNode {
    
    // MARK: - PROPERTIES
    private var collectibleType: CollectibleType = .none
    
    // MARK: - INIT
    init(collectibleType: CollectibleType) {
   
        var texture: SKTexture!
    self.collectibleType = collectibleType
    
        // Set the texture based on the type
        switch self.collectibleType {
        case .gloop:
            texture = SKTexture(imageNamed: "coCrossaint")
        case .none:
            break
            
        }
    // Call to super.init
    super.init(texture: texture, color: SKColor.clear, size: texture.size())
        
        
        
        
        let randomDouble = Double.random(in: 0...1)
        if (randomDouble < 0.20) {
            texture = SKTexture(imageNamed: "coCrossaint")
        } else if (randomDouble < 0.40){
            texture = SKTexture(imageNamed: "coFlower")
        } else if (randomDouble < 0.60){
            texture = SKTexture(imageNamed: "coCornCrosissant")
        } else if (randomDouble < 0.80){
            texture = SKTexture(imageNamed: "coIcedBun")
        } else if (randomDouble > 1){
            texture = SKTexture(imageNamed: "coJaffaCake")
        }else {
            texture = SKTexture(imageNamed: "coLoveCake")
        }
        
        
        // Set up collectible
        self.name = "co_\(collectibleType)"
        self.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        self.zPosition = Layer.collectible.rawValue
        
        // Add physics body
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size,
                                         center: CGPoint(x: 0.0, y: -self.size.height/2))
        self.physicsBody?.affectedByGravity = false
        
        // Set up physics categories for contacts
        self.physicsBody?.categoryBitMask = PhysicsCategory.collectible
        self.physicsBody?.contactTestBitMask = PhysicsCategory.player
        | PhysicsCategory.foreground
        self.physicsBody?.collisionBitMask = PhysicsCategory.none
        
    }
    
    // Required init
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - FUNCTIONS
    
    func drop(dropSpeed: TimeInterval, floorLevel: CGFloat) {
        
        let pos = CGPoint(x: position.x, y: 115)
        let scaleX = SKAction.scaleX(to: 1.0, duration: 1.0)
        let scaleY = SKAction.scaleY(to: 1.0, duration: 1.0)
        _ = SKAction.group([scaleX, scaleY])
        let appear = SKAction.fadeAlpha(to: 1.0, duration: 0.25)
        let moveAction = SKAction.move(to: pos, duration: dropSpeed)
        let actionSequence = SKAction.sequence([appear, moveAction])
        
        // Shrink first, then run fall action
        
        // self.scale(to: CGSize(width: 0.25, height: 1.0))
        self.run(actionSequence, withKey: "drop")
    }
    
    // Handle Contacts
    func collected() {
        let removeFromParent = SKAction.removeFromParent()
        self.run(removeFromParent)
    }
    
    func missed() {
        let removeFromParent = SKAction.removeFromParent()
        self.run(removeFromParent)
    }
    
    
}
