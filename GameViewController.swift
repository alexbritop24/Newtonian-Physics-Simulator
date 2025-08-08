import UIKit
import SpriteKit

class GameViewController: UIViewController, MainMenuSceneDelegate, GameSceneUIDelegate {

    private var skView: SKView!
    private var gravitySlider: UISlider!
    private var gravityLabel: UILabel!
    private var pauseButton: UIButton!
    private var resetButton: UIButton!
    private var menuButton: UIButton!
    private var objectButton: UIButton!

    private var currentObjectType: ObjectType = .ball
    private(set) var gameScene: GameScene?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupSKView()
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.showsDrawCount = true
        skView.isPaused = false
        skView.isUserInteractionEnabled = true
        presentMainMenu()
    }

    private func setupSKView() {
        skView = SKView(frame: view.bounds)
        skView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        skView.ignoresSiblingOrder = true
        view.addSubview(skView)
    }

    private func presentMainMenu() {
        print("➡️ presentMainMenu()")
        removeSimulationUI()
        skView.isPaused = false

        let menuScene = MainMenuScene(size: skView.bounds.size)
        menuScene.scaleMode = .resizeFill
        menuScene.mainMenuDelegate = self
        print("✅ delegate set? \(menuScene.mainMenuDelegate != nil)")

        DispatchQueue.main.async {
            self.skView.presentScene(menuScene, transition: .fade(withDuration: 0.25))
            print("🎬 presented MainMenuScene  (current=\(String(describing: type(of: self.skView.scene!))))")
        }
    }

    // MARK: - MainMenuSceneDelegate
    func didTapStartSimulation() {
        print("🔥 didTapStartSimulation()")
        let scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .resizeFill
        scene.uiDelegate = self
        gameScene = scene
        skView.isPaused = false

        DispatchQueue.main.async {
            self.skView.presentScene(scene, transition: .crossFade(withDuration: 0.25))
            print("🎬 presented GameScene       (current=\(String(describing: type(of: self.skView.scene!))))")
        }
    }

    // MARK: - GameSceneUIDelegate
    func setupSimulationUI() {
        if gravitySlider != nil { return } // idempotent

        // Slider shows positive g (0…20), physics gets -g
        gravitySlider = UISlider()
        gravitySlider.minimumValue = 0
        gravitySlider.maximumValue = 20
        gravitySlider.value = 9.8
        gravitySlider.translatesAutoresizingMaskIntoConstraints = false
        gravitySlider.addTarget(self, action: #selector(gravityChanged(_:)), for: .valueChanged)
        gravitySlider.setThumbImage(styledThumbImage(diameter: 28), for: .normal)
        view.addSubview(gravitySlider)

        gravityLabel = UILabel()
        gravityLabel.text = "Gravity: 9.8"
        gravityLabel.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)
        gravityLabel.textColor = .systemBlue   // matches your old blue label
        gravityLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gravityLabel)

        pauseButton = makeButton("Pause", tint: .systemBlue, action: #selector(togglePause))
        resetButton = makeButton("Reset", tint: .systemRed, action: #selector(resetScene))
        menuButton  = makeButton("←", tint: .systemBlue, action: #selector(returnToMenu))
        objectButton = makeButton("Object", tint: .label, action: #selector(showObjectOptions))

        [pauseButton, resetButton, menuButton, objectButton].forEach { view.addSubview($0) }

        // Layout similar to your screenshot
        NSLayoutConstraint.activate([
            menuButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            menuButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),

            pauseButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            pauseButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),

            resetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            resetButton.topAnchor.constraint(equalTo: pauseButton.bottomAnchor, constant: 10),

            objectButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            objectButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -44),

            gravitySlider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gravitySlider.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            gravitySlider.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.55),

            gravityLabel.centerXAnchor.constraint(equalTo: gravitySlider.centerXAnchor),
            gravityLabel.bottomAnchor.constraint(equalTo: gravitySlider.topAnchor, constant: -8),
        ])

        gravityChanged(gravitySlider)
        print("🧰 setupSimulationUI complete")
    }

    private func makeButton(_ title: String, tint: UIColor, action: Selector) -> UIButton {
        let b = UIButton(type: .system)
        b.setTitle(title, for: .normal)
        b.setTitleColor(tint, for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: action, for: .touchUpInside)
        return b
    }

    private func removeSimulationUI() {
        gravitySlider?.removeFromSuperview(); gravitySlider = nil
        gravityLabel?.removeFromSuperview();  gravityLabel  = nil
        pauseButton?.removeFromSuperview();   pauseButton   = nil
        resetButton?.removeFromSuperview();   resetButton   = nil
        menuButton?.removeFromSuperview();    menuButton    = nil
        objectButton?.removeFromSuperview();  objectButton  = nil
        print("🧹 removeSimulationUI() done")
    }

    // MARK: - Actions
    @objc private func gravityChanged(_ sender: UISlider) {
        let g = CGFloat(sender.value) // 0…20 (positive)
        gravityLabel?.text = String(format: "Gravity: %.1f", g)
        gameScene?.physicsWorld.gravity = CGVector(dx: 0, dy: -g) // apply downward
    }

    @objc private func togglePause() {
        skView.isPaused.toggle()
        pauseButton.setTitle(skView.isPaused ? "Resume" : "Pause", for: .normal)
    }

    @objc private func resetScene() {
        let newScene = GameScene(size: skView.bounds.size)
        newScene.scaleMode = .resizeFill
        newScene.uiDelegate = self
        gameScene = newScene
        DispatchQueue.main.async {
            self.skView.presentScene(newScene, transition: .crossFade(withDuration: 0.2))
            print("♻️ reset → presented GameScene (current=\(String(describing: type(of: self.skView.scene!))))")
        }
        gravityChanged(gravitySlider)
    }

    @objc private func returnToMenu() {
        presentMainMenu()
    }

    @objc private func showObjectOptions() {
        let alert = UIAlertController(title: "Choose Object", message: nil, preferredStyle: .actionSheet)
        for t in ObjectType.allCases {
            alert.addAction(UIAlertAction(title: t.rawValue.capitalized, style: .default) { _ in
                self.currentObjectType = t
                self.objectButton.setTitle("Object: \(t.rawValue)", for: .normal)
                self.gameScene?.setSelectedObject(type: t)
            })
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    // MARK: - UI Helpers
    private func styledThumbImage(diameter: CGFloat) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }

        let circlePath = UIBezierPath(ovalIn: rect)
        context.addPath(circlePath.cgPath)
        context.clip()

        let colors = [UIColor.lightGray.cgColor, UIColor.darkGray.cgColor] as CFArray
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: nil)!

        let center = CGPoint(x: diameter / 2, y: diameter / 2)
        context.drawRadialGradient(gradient,
                                   startCenter: center, startRadius: 0,
                                   endCenter: center, endRadius: diameter / 2,
                                   options: .drawsAfterEndLocation)

        context.resetClip()
        context.addPath(circlePath.cgPath)
        context.setStrokeColor(UIColor.gray.cgColor)
        context.setLineWidth(1)
        context.strokePath()

        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }
}
