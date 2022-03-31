import Foundation
import Carbon

public protocol InputSourceManaging {
    func getCurrentKeybaordInputSource() -> String?
}

public struct InputSourceManager: InputSourceManaging {
    
    // MARK: - Properties
    public private(set) var text = "Hello, World!"
    
    // MARK: - Init
    public init() {
    }
    
    // MARK: - Methods
    public func getCurrentKeybaordInputSource() -> String? {
        let currentInputSource = TISCopyCurrentKeyboardInputSource().takeUnretainedValue()
        
        guard let id = TISGetInputSourceProperty(currentInputSource, kTISPropertyInputSourceID) else {
            return nil
        }
        
        return Unmanaged<AnyObject>.fromOpaque(id).takeUnretainedValue() as? String
    }
}
