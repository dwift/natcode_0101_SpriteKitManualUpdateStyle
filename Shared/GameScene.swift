//
//  GameScene.swift
//  natcode_0101_SpriteKitCrossPlatform
//
//  Created by Carlyn Maw on 7/8/17.
//  Copyright © 2017 carlynorama. No rights reserved.
//

import SpriteKit
#if os(watchOS)
    import WatchKit
    // SKColor typealias does not seem to be exposed on watchOS SpriteKit
    typealias SKColor = UIColor
#endif

class GameScene: SKScene {
    
    
    fileprivate var stage : SKShapeNode?
    fileprivate var ball : SKShapeNode?

    
    class func newGameScene() -> GameScene {
        // Load 'GameScene.sks' as an SKScene.
        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            print("Failed to load GameScene.sks")
            abort()
        }
        
        // Set the scale mode to scale to fit the window
        //scene.scaleMode = .resizeFill
        return scene
    }
    
    func setUpScene() {
        // Get label node from scene and store it for use later
        //self.stage = self.childNode(withName: "//stage") as? SKShapeNode
        let s = (self.size.width + self.size.height) * 0.33
        self.stage = SKShapeNode.init(rectOf: CGSize.init(width: s, height: s), cornerRadius: s * 0.015)
        self.stage?.strokeColor = SKColor(colorLiteralRed: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        self.stage?.fillColor = SKColor.white
        self.addChild(stage!)
        
        if let stage = self.stage {
            stage.alpha = 0.0
            stage.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.ball = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.5)
        
//        if let spinnyNode = self.ball {
//            spinnyNode.lineWidth = 4.0
//            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
//            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
//                                              SKAction.fadeOut(withDuration: 0.5),
//                                              SKAction.removeFromParent()]))
//            
//            #if os(watchOS)
//                // For watch we just periodically create one of these and let it spin
//                // For other platforms we let user touch/mouse events create these
//                spinnyNode.position = CGPoint(x: 0.0, y: 0.0)
//                spinnyNode.strokeColor = SKColor.red
//                self.run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 2.0),
//                                                                   SKAction.run({
//                                                                       let n = spinnyNode.copy() as! SKShapeNode
//                                                                       self.addChild(n)
//                                                                   })])))
//            #endif
//        }
    }
    
    #if os(watchOS)
    override func sceneDidLoad() {
        self.setUpScene()
    }
    #else
    override func didMove(to view: SKView) {
        self.setUpScene()
    }
    #endif

//    func makeSpinny(at pos: CGPoint, color: SKColor) {
//        if let spinny = self.ball?.copy() as! SKShapeNode? {
//            spinny.position = pos
//            spinny.strokeColor = color
//            self.addChild(spinny)
//        }
//    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

#if os(iOS) || os(tvOS)
// Touch-based event handling
extension GameScene {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let stage = self.stage {
//            stage.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
    
//        for t in touches {
//            self.makeSpinny(at: t.location(in: self), color: SKColor.green)
//        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches {
//            self.makeSpinny(at: t.location(in: self), color: SKColor.blue)
//        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches {
//            self.makeSpinny(at: t.location(in: self), color: SKColor.red)
//        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches {
//            self.makeSpinny(at: t.location(in: self), color: SKColor.red)
//        }
    }
    
   
}
#endif

#if os(OSX)
// Mouse-based event handling
extension GameScene {

    override func mouseDown(with event: NSEvent) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        self.makeSpinny(at: event.location(in: self), color: SKColor.green)
    }
    
    override func mouseDragged(with event: NSEvent) {
        self.makeSpinny(at: event.location(in: self), color: SKColor.blue)
    }
    
    override func mouseUp(with event: NSEvent) {
        self.makeSpinny(at: event.location(in: self), color: SKColor.red)
    }

}
#endif

