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
    fileprivate let ballColor = SKColor(colorLiteralRed: 0.270271, green: 0.451499, blue: 0.616321, alpha: 1)
    fileprivate var ballVector:CGVector = CGVector(dx:1.0, dy:3.0)

    
    class func newGameScene() -> GameScene {
        // Load 'GameScene.sks' as an SKScene.
        //Can also manually create
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
        
        // Create stage bounding box. Did this manually because one created in scene rendered weird
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
        ball?.position = CGPoint(x: 0.0, y: 0.0)
        ball?.fillColor = ballColor
        //Should I add the ball to the stage or to the scene?
        self.stage!.addChild(ball!)
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
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        //ball?.position.x = (ball?.position.x)! + 1
        move(item: ball!, vector: ballVector)
        ballVector = getUpdatedVectorInCaseOfBoundsCollision(ballVector)
    }
    
    //MARK: Behaviors
    func move(item:SKShapeNode, vector:CGVector) {
        let calculatedPosition = applyVector(startPosition: item.position, vector: vector)
        
        //turn off implicit layer animations by using transaction
        //necessary so can do the reset jump
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        item.position = calculatedPosition
        CATransaction.commit()
        
    }
    
    func getUpdatedVectorInCaseOfBoundsCollision(_ vector:CGVector) -> CGVector {
        
        //seed with current value
        var newVector = vector
        let stageFrame = self.stage?.frame
        
        
        //bounds detection
        if (((ball!.position.x) >= (stageFrame!.maxX)) || (ball!.position.x <= (stageFrame!.minX))) {
            newVector.dx = vector.dx * -1;
        }
        if (((ball!.position.y) >= (stageFrame!.maxY)) || (ball!.position.y <= (stageFrame!.minY))) {
            newVector.dy = vector.dy * -1;
        }
        
        return newVector
    }
    
    func applyVector(startPosition:CGPoint, vector:CGVector) -> CGPoint {
        let deltaX:CGFloat = vector.dx
        let deltaY:CGFloat = vector.dy
        let newPoint:CGPoint = CGPoint(x: startPosition.x+deltaX, y: startPosition.y+deltaY)
        return newPoint
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



