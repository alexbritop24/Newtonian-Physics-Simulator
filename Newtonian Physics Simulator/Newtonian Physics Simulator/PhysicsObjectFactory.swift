import SpriteKit

struct PhysicsObjectFactory {
    /// Creates a circle node with physics configured
    static func makeBall(radius: CGFloat, position: CGPoint) -> SKShapeNode {
        let ball = SKShapeNode(circleOfRadius: radius)
        ball.fillColor = .systemBlue
        ball.position = position

        // Physics properties
        let body = SKPhysicsBody(circleOfRadius: radius)
        body.restitution = 0.8  // bounciness
        body.friction = 0.2     // resistance
        ball.physicsBody = body

        return ball
    }
}
