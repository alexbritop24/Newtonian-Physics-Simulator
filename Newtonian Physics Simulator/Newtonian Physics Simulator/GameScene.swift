import SpriteKit
import GameplayKit

class GameScene: SKScene {

    override func didMove(to view: SKView) {
        // 1. White background & Earth‑like gravity
        backgroundColor = .white
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)

        // 2. Static ground at bottom
        let groundHeight: CGFloat = 20
        let ground = SKSpriteNode(color: .gray,
                                  size: CGSize(width: size.width, height: groundHeight))
        ground.position = CGPoint(x: size.width/2, y: groundHeight/2)
        ground.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(
            origin: CGPoint(x: -size.width/2, y: -groundHeight/2),
            size: ground.size))
        ground.physicsBody?.isDynamic = false
        addChild(ground)

        // 3. One bouncing ball to start
        let ball = PhysicsObjectFactory.makeBall(radius: 25,
                                                 position: CGPoint(x: size.width/2,
                                                                   y: size.height - 100))
        addChild(ball)
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered; leave empty for now
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        // Use our factory to make a ball at the tap
        let ball = PhysicsObjectFactory.makeBall(radius: 20, position: location)
        addChild(ball)
    }
}
