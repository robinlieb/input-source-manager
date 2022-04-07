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
    
    /// Returns the input source for given input source id.
    /// - Parameters:
    ///     - inputSource:  String representation of the inputSource, e.g. com.apple.keylayout.US
    ///
    func getInputSource(for inputSourceId: String)  -> InputSource?
    
    /// Returns the currently selected keyboard layout input source.
    /// - Parameters:
    ///     - inputSource:  String representation of the inputSource, e.g. com.apple.keylayout.US
    ///
    func setInputSource(to inputSource: String)
    
    /// Returns list of all input sources.
    ///
    /// - Returns: List of all input sources.
    func getAllInputSources() -> [InputSource]
    
    /// Returns list of installed input sources.
    ///
    /// - Returns: List of all installed sources.
    func getInstalledInputSources() -> [InputSource]
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
        
        return InputSource(tisInputSource: currentInputSource)
    }
    
    public func getCurrentKeybaordLayoutInputSource() -> InputSource? {
        let currentInputSource = TISCopyCurrentKeyboardLayoutInputSource().takeUnretainedValue()
        
        return InputSource(tisInputSource: currentInputSource)
    }
    
    public func getInputSource(for inputSourceId: String) -> InputSource? {
        var inputSources: [InputSource] = []
        let inputSourcePropertiesDict = [kTISPropertyInputSourceID as String: inputSourceId]
        guard let tisInputSources = TISCreateInputSourceList(inputSourcePropertiesDict as CFDictionary, false).takeRetainedValue() as? [TISInputSource] else { // as NSArray
            return nil
        }
        
        for inputSource in tisInputSources {
            if let inputSource = InputSource(tisInputSource: inputSource) {
                inputSources.append(inputSource)
            }
        }
        
        return inputSources.first(where: { $0.id == inputSourceId })
    }
    
    public func setInputSource(to inputSource: String) {
        let inputSourceIDKey = kTISPropertyInputSourceID
        let inputSourcePropertiesDict = [inputSourceIDKey! as String: inputSource]
        let inputSourceList_nsarray = TISCreateInputSourceList(inputSourcePropertiesDict as CFDictionary, false).takeRetainedValue() as NSArray
        let inputSourceList = inputSourceList_nsarray as! [TISInputSource]
        let inputSource = inputSourceList[0]
        
        TISSelectInputSource(inputSource)
    }
    
    public func getAllInputSources() -> [InputSource] {
        return getInputSource(all: true)
    }
    
    public func getInstalledInputSources() -> [InputSource] {
        return getInputSource(all: false)
    }
    
    // MARK: - Helpers
    private func getInputSource(all: Bool) -> [InputSource] {
        let inputSourcesRef = TISCreateInputSourceList(nil, all).takeRetainedValue() as NSArray
        guard let tisInputSources = inputSourcesRef as? [TISInputSource] else {
            return []
        }
        
        var inputSources: [InputSource] = []
        
        for tisInputSource in tisInputSources {
            
            if let inputSource = InputSource(tisInputSource: tisInputSource) {
                inputSources.append(inputSource)
            }
        }
        return inputSources
    }
}
