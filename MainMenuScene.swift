import SpriteKit

class MainMenuScene: SKScene {

    weak var mainMenuDelegate: MainMenuSceneDelegate?

    private var startButton: SKShapeNode?
    private var modeButton: SKLabelNode?
    private var settingsButton: SKLabelNode?

    override func didMove(to view: SKView) {
        isUserInteractionEnabled = true
        backgroundColor = SKColor(red: 0.07, green: 0.09, blue: 0.2, alpha: 1.0)
        addTitle()
        addStartButton()
        addBottomButtons()
        print("[MainMenu] didMove (size=\(size))")
    }

    private func addTitle() {
        let titleLines = ["NEWTONIAN","PHYSICS","SIMULATOR"]
        let spacing: CGFloat = 10, font = "HelveticaNeue-Bold", fontSize: CGFloat = 36
        let totalH = CGFloat(titleLines.count - 1) * (fontSize + spacing)
        let startY = size.height * 0.65 + totalH / 2

        for (i, text) in titleLines.enumerated() {
            let l = SKLabelNode(fontNamed: font)
            l.text = text; l.fontSize = fontSize; l.fontColor = .white
            l.position = CGPoint(x: size.width/2, y: startY - CGFloat(i)*(fontSize+spacing))
            l.zPosition = 1
            l.horizontalAlignmentMode = .center
            l.verticalAlignmentMode = .center
            addChild(l)
        }
    }

    private func addStartButton() {
        let btn = SKShapeNode(rectOf: CGSize(width: 300, height: 60), cornerRadius: 30)
        btn.fillColor = .systemBlue
        btn.strokeColor = .white
        btn.lineWidth = 1.5
        btn.position = CGPoint(x: size.width/2, y: size.height*0.4)
        btn.name = "startButton"
        btn.zPosition = 1

        let label = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
        label.text = "Start Simulation"
        label.fontSize = 20
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        label.position = .zero
        label.name = "startButtonLabel"

        btn.addChild(label)
        addChild(btn)
        startButton = btn
    }

    private func addBottomButtons() {
        let mode = SKLabelNode(fontNamed: "HelveticaNeue-Medium")
        mode.text = "MODE 1"; mode.fontSize = 18; mode.fontColor = .lightGray
        mode.position = CGPoint(x: size.width*0.3, y: size.height*0.25)
        mode.name = "modeButton"; addChild(mode); modeButton = mode

        let settings = SKLabelNode(fontNamed: "HelveticaNeue-Medium")
        settings.text = "SETTINGS"; settings.fontSize = 18; settings.fontColor = .lightGray
        settings.position = CGPoint(x: size.width*0.7, y: size.height*0.25)
        settings.name = "settingsButton"; addChild(settings); settingsButton = settings
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else { return }
        let touched = atPoint(location)
        let isStart = (touched.name == "startButton") || (touched.parent?.name == "startButton")
            || (startButton?.contains(location) ?? false)

        print("👆 touches at \(location) — node=\(touched.name ?? "nil") parent=\(touched.parent?.name ?? "nil")")

        if isStart, let sb = startButton {
            animateTap(sb)
            print("🚀 Start tapped → calling delegate (nil? \(mainMenuDelegate == nil))")
            mainMenuDelegate?.didTapStartSimulation()
            return
        }
        if touched.name == "modeButton", let m = modeButton { animateTap(m); print("🧪 Mode 1 tapped"); return }
        if touched.name == "settingsButton", let s = settingsButton { animateTap(s); print("⚙️ Settings tapped"); showSettingsOverlay(); return }
    }

    private func animateTap(_ node: SKNode) {
        node.run(.sequence([.scale(to: 0.95, duration: 0.05), .scale(to: 1.0, duration: 0.08)]))
    }

    private func showSettingsOverlay() {
        let overlay = SKShapeNode(rectOf: CGSize(width: size.width*0.8, height: size.height*0.5), cornerRadius: 20)
        overlay.fillColor = SKColor.black.withAlphaComponent(0.8)
        overlay.zPosition = 10; overlay.name = "settingsOverlay"
        overlay.position = CGPoint(x: size.width/2, y: size.height/2)

        let l = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
        l.text = "Settings coming soon..."; l.fontSize = 20; l.fontColor = .white; l.position = .zero; l.zPosition = 11
        overlay.addChild(l); addChild(overlay)
        overlay.run(.sequence([.wait(forDuration: 2.0), .fadeOut(withDuration: 0.25), .removeFromParent()]))
    }

    override func didChangeSize(_ oldSize: CGSize) {
        if let sb = startButton { sb.position = CGPoint(x: size.width/2, y: size.height*0.4) }
        if let m  = modeButton { m.position  = CGPoint(x: size.width*0.3, y: size.height*0.25) }
        if let s  = settingsButton { s.position = CGPoint(x: size.width*0.7, y: size.height*0.25) }
    }
}
