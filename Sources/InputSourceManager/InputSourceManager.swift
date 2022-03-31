import Foundation
import Carbon

public protocol InputSourceManaging {
    
    /// Returns the currently selected layout input source.
    ///
    /// - Returns: InputSource object of currently selected layout input source.
    func getCurrentKeybaordInputSource() -> InputSource?
    
    /// Returns the currently selected keyboard layout input source.
    ///
    /// - Returns: InputSource object of currently selected keyboard layout input source.
    func getCurrentKeybaordLayoutInputSource() -> InputSource?
    
    /// Returns the currently selected keyboard layout input source.
    /// - Parameters:
    ///     - inputSource:  String representation of the inputSource, e.g. com.apple.keylayout.US
    ///
    func setInputSource(to inputSource: String)
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
    
    public func setInputSource(to inputSource: String) {
        let inputSourceIDKey = kTISPropertyInputSourceID
        let inputSourcePropertiesDict = [inputSourceIDKey! as String: inputSource]
        let inputSourceList_nsarray = TISCreateInputSourceList(inputSourcePropertiesDict as CFDictionary, false).takeRetainedValue() as NSArray
        let inputSourceList = inputSourceList_nsarray as! [TISInputSource]
        let inputSource = inputSourceList[0]
        
        TISSelectInputSource(inputSource)
    }
}
