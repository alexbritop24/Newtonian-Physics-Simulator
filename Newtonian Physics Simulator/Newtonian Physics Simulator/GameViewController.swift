import UIKit
import SpriteKit
import GameplayKit



class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 1. Cast view to SKView
        guard let skView = view as? SKView else { return }
        
        skView.accessibilityIdentifier = "SpriteKitViewIdentifier"

        // 2. Instantiate the scene to fit the view
        let scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill

        // 3. Present and configure debugging info
        skView.presentScene(scene)
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIDevice.current.userInterfaceIdiom == .phone
            ? .allButUpsideDown
            : .all
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
