import UIKit
import SpriteKit

class GameViewController: UIViewController {

    private var skView: SKView!
    private var gravitySlider: UISlider!
    private var gravityLabel: UILabel!
    private var pauseButton: UIButton!
    private var resetButton: UIButton!
    private var gameScene: GameScene?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupScene()
    }

    private func setupUI() {
        // Setup SKView
        skView = SKView(frame: view.bounds)
        skView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(skView)

        // Setup slider
        gravitySlider = UISlider()
        gravitySlider.translatesAutoresizingMaskIntoConstraints = false
        gravitySlider.minimumValue = -20
        gravitySlider.maximumValue = 0
        gravitySlider.value = -9.8
        gravitySlider.minimumTrackTintColor = .systemBlue
        gravitySlider.maximumTrackTintColor = .systemBlue
        gravitySlider.setThumbImage(makeSilverThumbImage(size: CGSize(width: 24, height: 24)), for: .normal)
        gravitySlider.addTarget(self, action: #selector(gravitySliderChanged), for: .valueChanged)
        view.addSubview(gravitySlider)

        // Setup gravity label
        gravityLabel = UILabel()
        gravityLabel.translatesAutoresizingMaskIntoConstraints = false
        gravityLabel.font = UIFont(name: "SFMono-Regular", size: 16)
        gravityLabel.textColor = UIColor.systemBlue
        gravityLabel.text = "Gravity: \(gravitySlider.value)"
        view.addSubview(gravityLabel)

        // Setup buttons
        pauseButton = makeStyledButton(title: "Pause", bgColor: UIColor.systemBlue)
        pauseButton.addTarget(self, action: #selector(togglePause), for: .touchUpInside)
        view.addSubview(pauseButton)

        resetButton = makeStyledButton(title: "Reset", bgColor: UIColor.systemRed)
        resetButton.addTarget(self, action: #selector(resetScene), for: .touchUpInside)
        view.addSubview(resetButton)

        // Layout
        NSLayoutConstraint.activate([
            gravitySlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            gravitySlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            gravitySlider.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),

            gravityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            gravityLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),

            pauseButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            pauseButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            pauseButton.widthAnchor.constraint(equalToConstant: 70),
            pauseButton.heightAnchor.constraint(equalToConstant: 36),

            resetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            resetButton.topAnchor.constraint(equalTo: pauseButton.bottomAnchor, constant: 12),
            resetButton.widthAnchor.constraint(equalToConstant: 70),
            resetButton.heightAnchor.constraint(equalToConstant: 36),
        ])
    }

    private func setupScene() {
        let scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        gameScene = scene
    }

    // MARK: - UI Helpers

    private func makeStyledButton(title: String, bgColor: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont(name: "SFMono-Regular", size: 14)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = bgColor
        button.layer.cornerRadius = 18
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.25
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        return button
    }

    private func makeSilverThumbImage(size: CGSize) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)
        let renderer = UIGraphicsImageRenderer(size: size)

        return renderer.image { context in
            let ctx = context.cgContext
            let center = CGPoint(x: size.width/2, y: size.height/2)
            let radius = size.width/2

            let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                      colors: [UIColor.lightGray.cgColor, UIColor.darkGray.cgColor] as CFArray,
                                      locations: [0.0, 1.0])!

            ctx.addEllipse(in: rect)
            ctx.clip()
            ctx.drawRadialGradient(gradient,
                                   startCenter: center, startRadius: 0,
                                   endCenter: center, endRadius: radius,
                                   options: [])
            ctx.setStrokeColor(UIColor.black.withAlphaComponent(0.3).cgColor)
            ctx.setLineWidth(1)
            ctx.strokeEllipse(in: rect)
        }
    }

    // MARK: - Actions

    @objc private func gravitySliderChanged() {
        let gravityValue = CGFloat(gravitySlider.value)
        gameScene?.physicsWorld.gravity.dy = gravityValue
        gravityLabel.text = String(format: "Gravity: %.1f", gravityValue)
    }

    @objc private func togglePause() {
        skView.isPaused.toggle()
        pauseButton.setTitle(skView.isPaused ? "Resume" : "Pause", for: .normal)
    }

    @objc private func resetScene() {
        gameScene?.resetScene()
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
