import Foundation

/// Commands for Input Keys
public enum InputCommand {
    
    /// key pressed
    case hold(InputKey)
    
    /// key press cancelled
    case cancel(InputKey)
    
    /// key released
    case release(InputKey)
}
