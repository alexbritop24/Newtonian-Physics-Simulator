import UIKit
import SpriteKit

class GameViewController: UIViewController {

    private var skView: SKView!
    private var gravitySlider: UISlider!
    private var pauseButton: UIButton!
    private var resetButton: UIButton!
    private var gameScene: GameScene?

    override func loadView() {
        let containerView = UIView(frame: UIScreen.main.bounds)
        containerView.backgroundColor = .white

        skView = SKView(frame: containerView.bounds)
        skView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView.addSubview(skView)

        self.view = containerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // 🎮 Setup SpriteKit Scene
        skView.accessibilityIdentifier = "SpriteKitViewIdentifier"
        let scene = GameScene(size: skView.bounds.size)
        self.gameScene = scene
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true

        // 🎛️ Gravity Slider
        gravitySlider = UISlider(frame: .zero)
        gravitySlider.minimumValue = -20       // Stronger gravity
        gravitySlider.maximumValue = 0         // Zero gravity
        gravitySlider.value = -9.8             // Earth gravity
        gravitySlider.addTarget(self, action: #selector(gravitySliderChanged(_:)), for: .valueChanged)
        gravitySlider.isUserInteractionEnabled = true
        view.addSubview(gravitySlider)

        // ⏸ Pause Button
        pauseButton = UIButton(type: .system)
        pauseButton.setTitle("Pause", for: .normal)
        pauseButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        pauseButton.tintColor = .white
        pauseButton.backgroundColor = .systemBlue
        pauseButton.layer.cornerRadius = 8
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pauseButton)
        pauseButton.addTarget(self, action: #selector(togglePause), for: .touchUpInside)

        // 🔁 Reset Button
        resetButton = UIButton(type: .system)
        resetButton.setTitle("Reset", for: .normal)
        resetButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        resetButton.tintColor = .white
        resetButton.backgroundColor = .systemRed
        resetButton.layer.cornerRadius = 8
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(resetButton)
        resetButton.addTarget(self, action: #selector(resetSceneFromButton), for: .touchUpInside)

        // 🧩 Button Layout
        NSLayoutConstraint.activate([
            pauseButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            pauseButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            pauseButton.widthAnchor.constraint(equalToConstant: 100),
            pauseButton.heightAnchor.constraint(equalToConstant: 40),

            resetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            resetButton.topAnchor.constraint(equalTo: pauseButton.bottomAnchor, constant: 20),
            resetButton.widthAnchor.constraint(equalToConstant: 100),
            resetButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        skView.frame = view.bounds

        gravitySlider.frame = CGRect(
            x: 20,
            y: view.bounds.height - 60,
            width: view.bounds.width - 40,
            height: 30
        )

        view.bringSubviewToFront(gravitySlider)
        view.bringSubviewToFront(pauseButton)
        view.bringSubviewToFront(resetButton)
    }

    // MARK: - Actions

    @objc private func gravitySliderChanged(_ sender: UISlider) {
        gameScene?.physicsWorld.gravity = CGVector(dx: 0, dy: CGFloat(sender.value))
    }

    @objc private func togglePause() {
        guard let skView = self.skView else { return }
        skView.isPaused.toggle()

        let title = skView.isPaused ? "Resume" : "Pause"
        pauseButton.setTitle(title, for: .normal)
    }

    @objc private func resetSceneFromButton() {
        gameScene?.resetScene()
    }

    // MARK: - Orientation & Status Bar

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIDevice.current.userInterfaceIdiom == .phone
            ? .allButUpsideDown
            : .all
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
