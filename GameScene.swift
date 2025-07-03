import SpriteKit
import GameplayKit

class GameScene: SKScene {

    private var selectedNode: SKNode?
    private var infoLabel: SKLabelNode?

    override func didMove(to view: SKView) {
        backgroundColor = .white
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        setupScene()
    }

    func setupScene() {
        let groundHeight: CGFloat = 20
        let ground = SKSpriteNode(color: .gray,
                                  size: CGSize(width: size.width, height: groundHeight))
        ground.position = CGPoint(x: size.width / 2, y: groundHeight / 2)
        ground.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(
            origin: CGPoint(x: -size.width / 2, y: -groundHeight / 2),
            size: ground.size))
        ground.physicsBody?.isDynamic = false
        addChild(ground)

        let ball = PhysicsObjectFactory.makeBall(radius: 25,
                                                 position: CGPoint(x: size.width / 2,
                                                                   y: size.height - 100))
        addChild(ball)
    }

    func resetScene() {
        removeAllChildren()
        setupScene()
    }

    override func update(_ currentTime: TimeInterval) {
        // Keep label above selected node
        if let node = selectedNode, let label = infoLabel {
            label.position = CGPoint(x: node.position.x, y: node.position.y + 50)
        }

        for child in children {
            if let node = child as? SKShapeNode {
                if node.position.y < -100 {
                    node.removeFromParent()
                }
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        let tappedNodes = nodes(at: location)
        for node in tappedNodes {
            if let shapeNode = node as? SKShapeNode, shapeNode.physicsBody != nil {
                selectObject(shapeNode)
                return
            }
        }

        let ball = PhysicsObjectFactory.makeBall(radius: 20, position: location)
        addChild(ball)
    }

    func selectObject(_ node: SKNode) {
        selectedNode = node
        infoLabel?.removeFromParent()

        let label = SKLabelNode(fontNamed: "SFMono-Regular")
        label.fontSize = 18
        label.fontColor = .black
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.zPosition = 9999

        if let body = node.physicsBody {
            label.text = String(format: "mass: %.2f | restitution: %.2f", body.mass, body.restitution)
        }

        label.position = CGPoint(x: node.position.x, y: node.position.y + 50)
        addChild(label)
        infoLabel = label

        // Add fade-out effect after 3 seconds
        let fadeOut = SKAction.sequence([
            SKAction.wait(forDuration: 3.0),
            SKAction.fadeOut(withDuration: 1.0),
            SKAction.removeFromParent()
        ])
        label.run(fadeOut)
    }
}
