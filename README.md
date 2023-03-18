# MKGameController

A simple Direction pad touch controller for SpriteKit games. 

## How to use?

- Instantiate an instance of TouchControllerNode and add it to the camera node in your scene.

  ```swift
  let controllerNode = TouchControllerNode(frame: ...)
  scene.camera.addChild(controllerNode)
  ```

- TouchControllerNode handles the layout for D-Pad Direction and Action keys.

  Assign a delegate to TouchControllerNode's `inputDelegate` property.

  ```swift
  controllerNode.inputDelegate = objectThatConformsToInputDelegate
  ```

- When a key action occurs, a command is sent to the delegate.

  Handle the command, to perform actions according to your game logic.

    ```swift
    func handle(command: InputCommand) {
        switch command {
        case .hold(let inputKey):
            // input key pressed
            ...
            
        case .cancel(let inputKey):
            // input key press cancelled
            ...
            
        case .release(let inputKey):
            // input key released
            ...
        }
    }
    ```

- Supported Keys are defined in `InputKey`
- Supported Actions are defined in `InputCommand`
- Images for D-pad Keys are present in `Images.xcassets`. 


---
## Note:

-  Enable multiple touches on SKView that will present the D-Pad controller node.

    It is important to enable multiple touch on the SKView that will present the scene to whose camera the D-Pad controller node will be added. Else multiple touch events will not be delivered when two (or more) buttons are pressed simultaneously


    ```swift
    camera.scene.view.isMultipleTouchEnabled = true
    ```

---