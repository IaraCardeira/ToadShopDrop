//
//  GameScene.swift
//  ToadApp(Skateboard)
//
//  Created by Iara cardeira on 28/02/2024.

// TO DO LIST

//draw asset for Die(lose) node / Sad Toad
//Draw assets for Game over page - Angry harrison / Sad Toad /
//Draw individual assets for Launch page*
//Research games that use haptics effectively
//record phrases by Harrison* - Give them a script - Add emotion
//Remove bounding boxes from all nodes
//figure what to do with remaining pastries
//Code in timer to before starting game?



import SpriteKit
import GameplayKit
class GameScene: SKScene {
    
    
    
    
    let player = Player()
    let playerSpeed: CGFloat = 1.0

    // Player movement
    var movingPlayer = false
    var lastPosition: CGPoint?
   
    var level: Int = 1 {
        didSet {
            levelLabel.text = "Level: \(level)"
        }
    }
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var playingLevel = false
    
 // var level: Int = 1
    var numberOfDrops: Int = 10
    var dropsExpected = 10
    var dropsCollected = 0
    var dropSpeed: CGFloat = 1.0
    var minDropSpeed: CGFloat = 0.19 // (fastest drop)
    var maxDropSpeed: CGFloat = 1.0 // (slowest drop)
    
    // Labels
    var scoreLabel: SKLabelNode = SKLabelNode()
    var levelLabel: SKLabelNode = SKLabelNode()
    
    override func didMove(to view: SKView) {
        
        // Set up the physics world contact delegate
        physicsWorld.contactDelegate = self
        
        // Set up background
        let background = SKSpriteNode(imageNamed: "Background 4")
        background.anchorPoint = CGPoint(x: -0.90, y: 0.0)
        background.zPosition = Layer.background.rawValue
        background.size = CGSize (width: 480, height: frame.maxY)
        
        addChild(background)
        
        // Set up foreground
        let foreground = SKSpriteNode(imageNamed: "Foreground 3")
        foreground.anchorPoint = CGPoint(x: 0.9, y: 0)
        foreground.zPosition = Layer.foreground.rawValue
        foreground.position = CGPoint(x: 0, y: 0)
        
        // Add physics body
        foreground.physicsBody = SKPhysicsBody(edgeLoopFrom: foreground.frame)
        foreground.physicsBody?.affectedByGravity = false
        
        addChild(foreground)
        
        // Set up physics categories for contacts
        foreground.physicsBody?.categoryBitMask = PhysicsCategory.foreground
        foreground.physicsBody?.contactTestBitMask = PhysicsCategory.collectible
        foreground.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        // Set up User Interface
        setupLabels()
        
        
        // Set up player
        player.setupConstraints(floor: foreground.frame.maxY)
        player.position = CGPoint(x: size.width/2, y: foreground.frame.maxY)
        addChild(player)
        player.walk()
        
        // Set up game
       // spawnMultipleGloops()
        
        
    }
    
    
    
    func spawnMultipleGloops() {
    
        // Start player walk animation
        player.walk()
        
        // Reset the level and score
        if gameInProgress == false {
            score = 0
            level = 1
        }
        
    // Set number of drops based on the level
        switch level {
        case 1, 2, 3, 4, 5:
        numberOfDrops = level * 10
        case 6:
        numberOfDrops = 75
        case 7:
        numberOfDrops = 100
        case 8:
        numberOfDrops = 150
        default:
        numberOfDrops = 150
        }
        
        // Reset and update the collected and expected drop count
        dropsCollected = 0
        dropsExpected = numberOfDrops
        
    // Set up drop speed
        dropSpeed = 1 / (CGFloat(level) +
                         (CGFloat(level) / CGFloat(numberOfDrops)))
        
        if dropSpeed < minDropSpeed {
            dropSpeed = minDropSpeed
        } else if dropSpeed > maxDropSpeed {
            dropSpeed = maxDropSpeed
        }
        
    // Set up repeating action
        let wait = SKAction.wait(forDuration: TimeInterval(dropSpeed))
        let spawn = SKAction.run { [unowned self] in self.spawnGloop() }
        let sequence = SKAction.sequence([wait, spawn])
        let repeatAction = SKAction.repeat(sequence, count: numberOfDrops)
        
    // Run action
        run(repeatAction, withKey: "gloop")
        
        // Update game states
        gameInProgress = true
     
        playingLevel = true
        
    }
    
   
    
    func setupLabels() {
        /* SCORE LABEL */
        scoreLabel.name = "score"
        //.fontName = "RebellionSquad"
        //.fontName = "Impact"

        scoreLabel.fontName = "MightySouly"

        scoreLabel.fontColor = .yellow
        scoreLabel.fontSize = 47.0
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.verticalAlignmentMode = .center
        scoreLabel.zPosition = Layer.ui.rawValue
        scoreLabel.position = CGPoint(x: frame.midX - 0, y: viewTop() - 130
        )
      
        // Set the text and add the label node to scene
        scoreLabel.text = "Score :  0"
        addChild(scoreLabel)
        
        /* LEVEL LABEL */
        levelLabel.name = "level"
        levelLabel.fontName = "MightySouly"
        levelLabel.fontColor = .yellow
        levelLabel.fontSize = 30.0
        levelLabel.horizontalAlignmentMode = .center
        levelLabel.verticalAlignmentMode = .center
        levelLabel.zPosition = Layer.ui.rawValue
        levelLabel.position = CGPoint(x: frame.midX - 0, y: viewTop() - 90)
    
       
        // Set the text and add the label node to scene
        levelLabel.text = "Level: \(level)"
        addChild(levelLabel)
    }
    
    
    // MARK: - GAME FUNCTIONS
    /* ####################################################################### */
    /* GAME FUNCTIONS START HERE */
    /* ####################################################################### */
    
    func spawnGloop() {
        let collectible = Collectible(collectibleType: CollectibleType.gloop)
        
    // set random position
        _ = collectible.size.width * 2
        let dropRange = SKRange(lowerLimit: 495,
                              upperLimit: 810)
        
        let randomX = CGFloat.random(in:
                                        dropRange.lowerLimit...dropRange.upperLimit)
        collectible.position = CGPoint(x: randomX ,
                                       y: player.position.y * 6)
        
        addChild(collectible)
        collectible.drop(dropSpeed: TimeInterval(1.0),
                         floorLevel: player.frame.midY)
        }
    
    
    func checkForRemainingDrops() {
        if dropsCollected == dropsExpected {
            nextLevel()
        }
    }
    
    // Player PASSED level
    func nextLevel() {
        let wait = SKAction.wait(forDuration: 2.25)
        run(wait, completion:{[unowned self] in self.level += 1
            self.spawnMultipleGloops()})
    }
    
    
    // Player FAILED level
    func gameOver() {
       
        // Update game states
        gameInProgress = false
        
        // Start player die animation
        player.die()
        
        // Remove repeatable action on main scene
        removeAction(forKey: "gloop")
        // Loop through child nodes and stop actions on collectibles
        enumerateChildNodes(withName: "//co_*") {
            (node, stop) in
            // Stop and remove drops
            node.removeAction(forKey: "drop") // remove action
            node.physicsBody = nil // remove body so no collisions occur
        }
        
        // Reset game
        resetPlayerPosition()
        popRemainingDrops()
        
        
    }
    
    func resetPlayerPosition() {
        let resetPoint = CGPoint(x: frame.midX, y: player.position.y)
        let distance = hypot(resetPoint.x-player.position.x, 0)
        let calculatedSpeed = TimeInterval(distance / (playerSpeed * 2)) / 255
        if player.position.x > frame.midX {
            player.moveToPosition(pos: resetPoint, direction: "L",
                                  speed: calculatedSpeed)
        } else {
            player.moveToPosition(pos: resetPoint, direction: "R",
                                  speed: calculatedSpeed)
        }
    }
        
    func popRemainingDrops() {
        var i = 0
        enumerateChildNodes(withName: "//co_*") {
            (node, stop) in
            // Pop remaining drops in sequence
            let initialWait = SKAction.wait(forDuration: 1.0)
            let wait = SKAction.wait(forDuration: TimeInterval(0.15 * CGFloat(i)))
            let removeFromParent = SKAction.removeFromParent()
            let actionSequence = SKAction.sequence([initialWait, wait,
                                                    removeFromParent])
            node.run(actionSequence)
            i += 1
        }
    }
    
    // Game states
    var gameInProgress = false
    
    
// MARK: - TOUCH HANDLING
    
/* ####################################################################### */
/* TOUCH HANDLERS STARTS HERE */
/* ####################################################################### */
    
    
    func touchDown(atPoint pos: CGPoint) {
        
        if gameInProgress == false {
        spawnMultipleGloops()
        return
        }
        
        let touchedNode = atPoint(pos)
        if touchedNode.name == "player" {
            movingPlayer = true
        }
    }
    
    func touchMoved(toPoint pos: CGPoint) {
        if movingPlayer == true {
            
        // Clamp position
            let newPos = CGPoint(x: pos.x, y: player.position.y)
            player.position = newPos
            
        // Check last position; if empty set it
            let recordedPosition = lastPosition ?? player.position
            if recordedPosition.x > newPos.x {
                player.xScale = abs(player.xScale)
        //Ensure positive Xscale
            } else {
                player.xScale =  -abs(player.xScale)
            }
            
            //(Weronica helped me with this fix :) - turns out we just needed to move -abs(player.xScale) into the else statement)
            
    // Save last known position
            lastPosition = newPos
        }
    }
    
    
    func touchUp(atPoint pos: CGPoint) {
        movingPlayer = false
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self))
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    override func touchesCancelled(_ touches: Set<UITouch>,
                                   with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
}


// MARK: - COLLISION DETECTION
/* ####################################################################### */
/* COLLISION DETECTION METHODS START HERE */
/* ####################################################################### */
extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        // Check collision bodies
        let collision = contact.bodyA.categoryBitMask |
        contact.bodyB.categoryBitMask
        
        // Did the [PLAYER] collide with the [COLLECTIBLE]?
        if collision == PhysicsCategory.player | PhysicsCategory.collectible {
            print("player hit collectible")
            
        // Find out which body is attached to the collectible node
            let body = contact.bodyA.categoryBitMask == PhysicsCategory.collectible ?
            contact.bodyA.node :
            contact.bodyB.node
            
            // Verify the object is a collectible
            if let sprite = body as? Collectible {
            sprite.collected()
            dropsCollected += 1
            score += level
            checkForRemainingDrops()
            }
        }
        
        // Or did the [COLLECTIBLE] collide with the [FOREGROUND]?
        if collision == PhysicsCategory.foreground | PhysicsCategory.collectible {
            print("collectible hit foreground")
            
        // Find out which body is attached to the collectible node
            let body = contact.bodyA.categoryBitMask == PhysicsCategory.collectible ?
            contact.bodyA.node :
            contact.bodyB.node
        
        // Verify the object is a collectible
            if let sprite = body as? Collectible {
                sprite.missed()
                gameOver()
            }
        }
    }
}
