import SpriteKit

/// An SKSpriteNode that handles D-Pad Touch controller keys events and forwards the events to the touch delegate
public class TouchControllerNode: SKSpriteNode {
    
    /// alpha value when a button is in released state
    static let alphaUnpressed: CGFloat = 0.5
    
    /// aplha value when a button is in pressed state
    static let alphaPressed: CGFloat = 0.9
    
    /// a delegate that will handle the input commands generated on key press
    public weak var inputDelegate: InputDelegate?
    
    /// buttons currently pressed
    var pressedButtons: [SKSpriteNode] = []
    
    /// node for direction up button
    var buttonUp: SKSpriteNode
    
    /// node for direction left button
    var buttonLeft: SKSpriteNode
    
    /// node for direction down button
    var buttonDown: SKSpriteNode
    
    /// node for direction right button
    var buttonRight: SKSpriteNode
    
    /// node for action A button
    var buttonA: SKSpriteNode
    
    /// node for action B button
    var buttonB: SKSpriteNode
    
    /// node for action X button
    var buttonX: SKSpriteNode
    
    /// node for action Y button
    var buttonY: SKSpriteNode
    
    /// all supported buttons
    lazy var allButtons: [SKSpriteNode] = [
        buttonUp,
        buttonLeft,
        buttonDown,
        buttonRight,
        buttonA,
        buttonB,
        buttonX,
        buttonY
    ]

    public init(frame: CGRect) {
        buttonUp = SKSpriteNode(texture: SKTexture(image: UIImage(named: "button_dir_up", in: .module, with: nil)!))
        buttonDown = SKSpriteNode(texture: SKTexture(image: UIImage(named: "button_dir_down", in: .module, with: nil)!))
        buttonLeft = SKSpriteNode(texture: SKTexture(image: UIImage(named: "button_dir_left", in: .module, with: nil)!))
        buttonRight = SKSpriteNode(
            texture: SKTexture(image: UIImage(named: "button_dir_right", in: .module, with: nil)!)
        )
        buttonA = SKSpriteNode(texture: SKTexture(image: UIImage(named: "button_a", in: .module, with: nil)!))
        buttonB = SKSpriteNode(texture: SKTexture(image: UIImage(named: "button_b", in: .module, with: nil)!))
        buttonX = SKSpriteNode(texture: SKTexture(image: UIImage(named: "button_x", in: .module, with: nil)!))
        buttonY = SKSpriteNode(texture: SKTexture(image: UIImage(named: "button_y", in: .module, with: nil)!))
        super.init(
            texture: nil,
            color: .clear,
            size: frame.size
        )
        setupControls(size: frame.size)
        isUserInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    func setupControls(size: CGSize) {
        let centerOffsetHorizontal = size.width / 3
        let centerOffsetVertical = size.height / 4
        let offsetX = 50.0
        let offsetY = 50.0
        let scale = 1.0
        
        addButton(
            button: buttonUp,
            position: CGPoint(x: -centerOffsetHorizontal, y: -centerOffsetVertical + offsetY),
            name: InputKey.keyUp.rawValue,
            scale: scale
        )
        addButton(
            button: buttonLeft,
            position: CGPoint(x: -centerOffsetHorizontal - offsetX, y: -centerOffsetVertical),
            name: InputKey.keyLeft.rawValue,
            scale: scale
        )
        addButton(
            button: buttonDown,
            position: CGPoint(x: -centerOffsetHorizontal, y: -centerOffsetVertical - offsetY),
            name: InputKey.keyDown.rawValue,
            scale: scale
        )
        addButton(
            button: buttonRight,
            position: CGPoint(x: -centerOffsetHorizontal + offsetX, y: -centerOffsetVertical),
            name: InputKey.keyRight.rawValue,
            scale: scale
        )
        addButton(
            button: buttonX,
            position: CGPoint(x: centerOffsetHorizontal, y: -centerOffsetVertical + offsetY),
            name: InputKey.keyX.rawValue,
            scale: scale
        )
        addButton(
            button: buttonY,
            position: CGPoint(x: centerOffsetHorizontal - offsetX, y: -centerOffsetVertical),
            name: InputKey.keyY.rawValue,
            scale: scale
        )
        addButton(
            button: buttonB,
            position: CGPoint(x: centerOffsetHorizontal, y: -centerOffsetVertical - offsetY),
            name: InputKey.keyB.rawValue,
            scale: scale
        )
        addButton(
            button: buttonA,
            position: CGPoint(x: centerOffsetHorizontal + offsetX, y: -centerOffsetVertical),
            name: InputKey.keyA.rawValue,
            scale: scale
        )
    }

    func addButton(
        button: SKSpriteNode,
        position: CGPoint,
        name: String,
        scale: CGFloat
    ) {
        button.position = position
        button.setScale(scale)
        button.name = name
        button.zPosition = 1000
        button.alpha = Self.alphaUnpressed
        self.addChild(button)
    }

    // MARK: - Touch handling

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: parent!)
            // for all buttons
            for button in allButtons {
                if button.contains(location) && pressedButtons.firstIndex(of: button) == nil {
                    pressedButtons.append(button)
                    handleButtonPress(button)
                }
                highlight(button)
            }
        }
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: parent!)
            let previousLocation = touch.previousLocation(in: parent!)
            for button in allButtons {
                // if i get off the button where i was before
                if button.contains(previousLocation) && !button.contains(location) {
                    let index = pressedButtons.firstIndex(of: button)
                    if index != nil {
                        pressedButtons.remove(at: index!)
                        handleButtonCancel(button)
                    }
                } else if !button.contains(previousLocation)
                            && button.contains(location)
                            && pressedButtons.firstIndex(of: button) == nil {
                    pressedButtons.append(button)
                    handleButtonPress(button)
                }
                highlight(button)
            }
        }
    }

    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchUp(touches, with: event)
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchUp(touches, with: event)
    }

    func touchUp(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: parent!)
            let previousLocation = touch.previousLocation(in: parent!)
            for button in allButtons {
                if button.contains(previousLocation) || button.contains(location) {
                    if let index = pressedButtons.firstIndex(of: button) {
                        pressedButtons.remove(at: index)
                        handleButtonStop(button)
                    }
                }
                highlight(button)
            }
        }
    }

    // MARK: -

    func highlight(_ button: SKSpriteNode) {
        if pressedButtons.firstIndex(of: button) != nil {
            button.alpha = Self.alphaPressed
        } else {
            button.alpha = Self.alphaUnpressed
        }
    }

    func handleButtonPress(_ button: SKSpriteNode) {
        guard let delegate = inputDelegate else {
            return
        }
        let key = InputKey(rawValue: button.name!)!
        delegate.handle(command: .hold(key))
    }

    func handleButtonCancel(_ button: SKSpriteNode) {
        guard let delegate = inputDelegate else {
            return
        }
        let key = InputKey(rawValue: button.name!)!
        delegate.handle(command: .cancel(key))
    }

    func handleButtonStop(_ button: SKSpriteNode) {
        guard let delegate = inputDelegate else {
            return
        }
        let key = InputKey(rawValue: button.name!)!
        delegate.handle(command: .release(key))
    }
}
