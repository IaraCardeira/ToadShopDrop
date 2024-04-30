//
//  GameViewController.swift
//  ToadApp(Skateboard)
//
//  Created by Iara cardeira on 28/02/2024.
//

import UIKit
import SpriteKit
import GameplayKit
class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the view
        if let view = self.view as! SKView? {
            
        // Create the scene
            // let scene = GameScene(size: view.bounds.size)
            let scene = GameScene(size: CGSize(width: 1336, height: 1024))
            
        // Set the scale mode to scale to fill the view window
            scene.scaleMode = .aspectFill
            
        // Set the background color
            scene.backgroundColor = UIColor(red: 0/255,
                                            green: 180/255,
                                            blue: 250/255,
                                            alpha: 1.0)
            
        // Present the scene
            view.presentScene(scene)
           
        // Set the view options
            view.ignoresSiblingOrder = false
            view.showsPhysics = true
            view.showsFPS = true
            view.showsNodeCount = true
    
        }
    }
        
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



