import SpriteKit

class GameScene: SKScene {
    weak var uiDelegate: GameSceneUIDelegate?

    private var selectedNode: SKNode?
    private var infoLabel: SKLabelNode?
    private var currentObjectType: ObjectType = .ball

    // Stacked debug overlay (container + 3 labels)
    private var debugContainer: SKNode?
    private var debugObjectsLabel: SKLabelNode?
    private var debugGravityLabel: SKLabelNode?
    private var debugFPSLabel: SKLabelNode?

    private var lastUpdateTime: TimeInterval = 0
    private var fpsSmoothed: Double = 60

    // MARK: - Lifecycle
    override func didMove(to view: SKView) {
        print("🧠 GameScene.didMove (size=\(size))")

        backgroundColor = .white
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)

        // Keep objects inside the screen
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody?.restitution = 0.3

        setupScene()
        setupDebugOverlay()

        // Build the UIKit controls (slider, buttons)
        uiDelegate?.setupSimulationUI()
    }

    // MARK: - Setup
    func setupScene() {
        // Simple ground bar
        let groundHeight: CGFloat = 20
        let ground = SKSpriteNode(color: .gray, size: CGSize(width: size.width, height: groundHeight))
        ground.position = CGPoint(x: size.width/2, y: groundHeight/2)
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.isDynamic = false
        addChild(ground)

        // Seed one object so the screen isn’t empty
        spawnRandomObject(at: CGPoint(x: size.width/2, y: size.height - 100))
    }

    func setupDebugOverlay() {
        // Container pinned to middle-right with a 10pt inset from the edge
        let container = SKNode()
        container.zPosition = 999
        container.position = CGPoint(x: size.width - 10, y: size.height / 2)
        addChild(container)
        debugContainer = container

        func makeLine() -> SKLabelNode {
            let l = SKLabelNode(fontNamed: "SFMono-Regular")
            l.fontSize = 12
            l.fontColor = .blue
            l.horizontalAlignmentMode = .right
            l.verticalAlignmentMode = .center
            return l
        }

        // Three stacked lines: top/middle/bottom
        let spacing: CGFloat = 14

        let objects = makeLine()
        objects.position = CGPoint(x: 0, y: spacing)
        container.addChild(objects)
        debugObjectsLabel = objects

        let gravity = makeLine()
        gravity.position = CGPoint(x: 0, y: 0)
        container.addChild(gravity)
        debugGravityLabel = gravity

        let fps = makeLine()
        fps.position = CGPoint(x: 0, y: -spacing)
        container.addChild(fps)
        debugFPSLabel = fps
    }

    // Keep overlay anchored after rotation/resize
    override func didChangeSize(_ oldSize: CGSize) {
        debugContainer?.position = CGPoint(x: size.width - 10, y: size.height / 2)
    }

    // MARK: - Reset
    func resetScene() {
        removeAllChildren()
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody?.restitution = 0.3
        setupScene()
        setupDebugOverlay()
    }

    // MARK: - Update
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime > 0 {
            let dt = currentTime - lastUpdateTime
            let fpsInstant = dt > 0 ? 1.0 / dt : 60
            fpsSmoothed = fpsSmoothed * 0.9 + fpsInstant * 0.1
        }
        lastUpdateTime = currentTime

        if let node = selectedNode, let label = infoLabel {
            label.position = CGPoint(x: node.position.x, y: node.position.y + 50)
        }

        // Cull offscreen shapes
        for child in children {
            if let shape = child as? SKShapeNode, shape.position.y < -200 {
                shape.removeFromParent()
            }
        }

        // Update stacked overlay
        let objectCount = children.compactMap { $0 as? SKShapeNode }.count
        debugObjectsLabel?.text = "Objects: \(objectCount)"
        debugGravityLabel?.text = String(format: "Gravity: %.1f", -physicsWorld.gravity.dy)
        debugFPSLabel?.text = String(format: "FPS: %.0f", fpsSmoothed)
    }

    // MARK: - Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else { return }

        // Pick up an existing physics node if tapped
        for node in nodes(at: location) {
            if let shape = node as? SKShapeNode, shape.physicsBody != nil {
                selectObject(shape)
                selectedNode = shape
                shape.physicsBody?.isDynamic = false
                return
            }
        }

        // Otherwise, spawn one of the currently selected type
        spawnRandomObject(at: location)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let t = touches.first, let node = selectedNode else { return }
        node.position = t.location(in: self)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectedNode?.physicsBody?.isDynamic = true
        selectedNode = nil
    }

    // MARK: - Spawning & Selection
    func spawnRandomObject(at location: CGPoint) {
        let object = PhysicsObjectFactory.makeObject(type: currentObjectType, position: location)
        addChild(object)
    }

    func setSelectedObject(type: ObjectType) {
        currentObjectType = type
    }

    func selectObject(_ node: SKNode) {
        selectedNode = node
        infoLabel?.removeFromParent()

        let label = SKLabelNode(fontNamed: "SFMono-Regular")
        label.fontSize = 16
        label.fontColor = .black
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.zPosition = 1000

        if let body = node.physicsBody {
            label.text = String(format: "mass: %.2f | restitution: %.2f", body.mass, body.restitution)
        }

        label.position = CGPoint(x: node.position.x, y: node.position.y + 50)
        addChild(label)
        infoLabel = label

        label.run(.sequence([
            .wait(forDuration: 3.0),
            .fadeOut(withDuration: 0.5),
            .removeFromParent()
        ]))
    }
}
