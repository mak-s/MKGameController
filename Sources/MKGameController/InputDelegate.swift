import Foundation

/// Protocol to handle Input commands
public protocol InputDelegate: AnyObject {
    
    /// handle a given `command`
    /// - Parameter command: an `InputCommand` to handle
    func handle(command: InputCommand)
}
