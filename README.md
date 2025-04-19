# PhysicsSimulator

A SpriteKit‑powered iOS physics playground where you can watch objects fall, bounce, and interact under configurable parameters.

![Demo GIF](assets/demo.gif)

## 🚀 Features
- Gravity simulation with realistic restitution & friction  
- Static boundary (ground) via `edgeLoop` physics body  
- Tap to spawn new balls, rectangles, and custom shapes  
- Adjustable physics parameters via in‑app UI (coming soon!)

## 📥 Requirements
- Xcode 15+  
- iOS 16.0+ deployment target  
- Swift 5.9  

## ⚙️ Installation
```bash
git clone https://github.com/alexbritop24/Newtonian-Physics-Simulator.git
cd Newtonian-Physics-Simulator
open PhysicsSimulator.xcodeproj
# ⌘R to build & run in Simulator or on device


## 🎛️ Usage
- Run the app.  
- Tap anywhere to spawn a new object.  
- (Future) Use Settings menu to tweak gravity, restitution, friction.

## 🗺️ Roadmap
- [x] Basic gravity + bouncing ball demo  
- [ ] Touch interaction & multi‑shape support  
- [ ] On‑screen sliders for physics parameters  
- [ ] Save / load simulation presets  
- [ ] Dynamic forces (wind, magnets…)


