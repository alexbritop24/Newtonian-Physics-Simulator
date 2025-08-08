import SpriteKit

struct PhysicsObjectFactory {
    // Single knob to change size across all shapes
    static let baseRadius: CGFloat = 14

    static func makeObject(type: ObjectType, position: CGPoint) -> SKShapeNode {
        let mass = CGFloat.random(in: 0.02...0.05)
        let scale = baseRadius // consistent size for all

        switch type {
        case .ball:
            let ball = SKShapeNode(circleOfRadius: scale)
            ball.fillColor = .systemBlue
            ball.position = position

            let body = SKPhysicsBody(circleOfRadius: scale)
            body.mass = mass
            body.restitution = 0.5
            ball.physicsBody = body
            return ball

        case .box:
            let size = CGSize(width: scale * 2, height: scale * 2)
            let box = SKShapeNode(rectOf: size, cornerRadius: 4)
            box.fillColor = .systemTeal
            box.position = position

            let body = SKPhysicsBody(rectangleOf: size)
            body.mass = mass
            body.restitution = 0.5
            box.physicsBody = body
            return box

        case .triangle:
            let trianglePath = UIBezierPath()
            trianglePath.move(to: CGPoint(x: 0, y: scale * 2))
            trianglePath.addLine(to: CGPoint(x: scale * 2, y: -scale * 2))
            trianglePath.addLine(to: CGPoint(x: -scale * 2, y: -scale * 2))
            trianglePath.close()

            let triangle = SKShapeNode(path: trianglePath.cgPath)
            triangle.fillColor = .systemOrange
            triangle.position = position

            let body = SKPhysicsBody(polygonFrom: trianglePath.cgPath)
            body.mass = mass
            body.restitution = 0.5
            triangle.physicsBody = body
            return triangle

        case .star:
            let starPath = createStarPath(radius: scale * 2, points: 5)
            let star = SKShapeNode(path: starPath)
            star.fillColor = .systemYellow
            star.position = position

            let body = SKPhysicsBody(polygonFrom: starPath)
            body.mass = mass
            body.restitution = 0.5
            star.physicsBody = body
            return star
        }
    }

    private static func createStarPath(radius: CGFloat, points: Int) -> CGPath {
        let path = UIBezierPath()
        let adjustment = CGFloat.pi / 2

        for i in 0..<(points * 2) {
            let angle = CGFloat(i) * (.pi / CGFloat(points)) - adjustment
            let pointRadius = i % 2 == 0 ? radius : radius * 0.5
            let x = pointRadius * cos(angle)
            let y = pointRadius * sin(angle)
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }

        path.close()
        return path.cgPath
    }
}
