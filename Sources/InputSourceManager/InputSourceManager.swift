import Foundation
import Carbon

public protocol InputSourceManaging {
    func getCurrentKeybaordInputSource() -> InputSource?
    func getCurrentKeybaordLayoutInputSource() -> InputSource?
}

public struct InputSourceManager: InputSourceManaging {
    
    // MARK: - Properties
    public private(set) var text = "Hello, World!"
    
    // MARK: - Init
    public init() {
    }
    
    // MARK: - Methods
    public func getCurrentKeybaordInputSource() -> InputSource? {
        let currentInputSource = TISCopyCurrentKeyboardInputSource().takeUnretainedValue()
        
        guard let pointer = TISGetInputSourceProperty(currentInputSource, kTISPropertyInputSourceID),
              let id = Unmanaged<AnyObject>.fromOpaque(pointer).takeUnretainedValue() as? String else {
            return nil
        }
        
        guard let pointer = TISGetInputSourceProperty(currentInputSource, kTISPropertyLocalizedName),
              let name = Unmanaged<AnyObject>.fromOpaque(pointer).takeUnretainedValue() as? String else {
            return nil
        }
        
        return InputSource(id: id, localizedName: name)
    }
    
    public func getCurrentKeybaordLayoutInputSource() -> InputSource? {
        let currentInputSource = TISCopyCurrentKeyboardLayoutInputSource().takeUnretainedValue()
        
        guard let pointer = TISGetInputSourceProperty(currentInputSource, kTISPropertyInputSourceID),
              let id = Unmanaged<AnyObject>.fromOpaque(pointer).takeUnretainedValue() as? String else {
            return nil
        }
        
        guard let pointer = TISGetInputSourceProperty(currentInputSource, kTISPropertyLocalizedName),
              let name = Unmanaged<AnyObject>.fromOpaque(pointer).takeUnretainedValue() as? String else {
            return nil
        }
        
        return InputSource(id: id, localizedName: name)
    }
}
