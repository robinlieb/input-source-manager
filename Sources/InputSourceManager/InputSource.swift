import Foundation
import Carbon

protocol TISInputSourceConvertible {
    init?(tisInputSource: TISInputSource)
}

public struct InputSource {
    
    // Identifier of the input source, e.g com.apple.keylayout.US
    public var id: String
    
    // Localized name of the input source, e.g. U.S.
    public var localizedName: String
    
    // The category of the input source
    public var category: String
    
    // True if input source is enabled and can be programaticly selected
    public var isSelectable: Bool
    
    // True if input source can be programaticly enabled
    public var isEnableable: Bool
    
    // True if input source is selected
    public var isSelected: Bool
    
    // True if input source is enabled
    public var isEnabled: Bool
    
    // Contains language codes for a language that can be input using the input source
    public var sourceLanguages: [String]
    
    // URL for icon image of input source (typically TIFF). If nil iconRef should be used.
    public var iconImageURL: URL?
    
    // IconRef value for the input source icon.
    public var iconRef: IconRef?
    
    init(id: String,
         localizedName: String,
         category: String,
         isSelectable: Bool,
         isEnableable: Bool,
         isSelected: Bool,
         isEnabled: Bool,
         sourceLanguages: [String],
         iconImageURL: URL? = nil,
         iconRef: IconRef? = nil) {
        self.id = id
        self.localizedName = localizedName
        self.category = category
        self.isSelectable = isSelectable
        self.isEnableable = isEnableable
        self.isSelected = isSelected
        self.isEnabled = isEnabled
        self.sourceLanguages = sourceLanguages
        self.iconImageURL = iconImageURL
        self.iconRef = iconRef
    }
}

extension InputSource: TISInputSourceConvertible {
    init?(tisInputSource: TISInputSource) {
        guard let pointer = TISGetInputSourceProperty(tisInputSource, kTISPropertyInputSourceID),
              let id = Unmanaged<AnyObject>.fromOpaque(pointer).takeUnretainedValue() as? String else {
            return nil
        }
        
        guard let pointer = TISGetInputSourceProperty(tisInputSource, kTISPropertyLocalizedName),
              let name = Unmanaged<AnyObject>.fromOpaque(pointer).takeUnretainedValue() as? String else {
            return nil
        }
        
        guard let pointer = TISGetInputSourceProperty(tisInputSource, kTISPropertyInputSourceCategory),
              let category = Unmanaged<AnyObject>.fromOpaque(pointer).takeUnretainedValue() as? String else {
            return nil
        }
        
        guard let pointer = TISGetInputSourceProperty(tisInputSource, kTISPropertyInputSourceIsSelectCapable),
              let isSelectable = Unmanaged<AnyObject>.fromOpaque(pointer).takeUnretainedValue() as? Bool else {
            return nil
        }
        
        guard let pointer = TISGetInputSourceProperty(tisInputSource, kTISPropertyInputSourceIsEnableCapable),
              let isEnableable = Unmanaged<AnyObject>.fromOpaque(pointer).takeUnretainedValue() as? Bool else {
            return nil
        }
        
        guard let pointer = TISGetInputSourceProperty(tisInputSource, kTISPropertyInputSourceIsSelected),
              let isSelected = Unmanaged<AnyObject>.fromOpaque(pointer).takeUnretainedValue() as? Bool else {
            return nil
        }
        
        guard let pointer = TISGetInputSourceProperty(tisInputSource, kTISPropertyInputSourceIsEnabled),
              let isEnabled = Unmanaged<AnyObject>.fromOpaque(pointer).takeUnretainedValue() as? Bool else {
            return nil
        }
        
        guard let pointer = TISGetInputSourceProperty(tisInputSource, kTISPropertyInputSourceLanguages),
              let sourceLanguages = Unmanaged<AnyObject>.fromOpaque(pointer).takeUnretainedValue() as? [String] else {
            return nil
        }
        
        var url: URL?
         if let pointer = TISGetInputSourceProperty(tisInputSource, kTISPropertyIconImageURL),
         let iconImageURL = Unmanaged<AnyObject>.fromOpaque(pointer).takeUnretainedValue() as? URL? {
         url = iconImageURL
         }
         
        var iconRef: IconRef?
        if let retIconRef = OpaquePointer(TISGetInputSourceProperty(tisInputSource, kTISPropertyIconRef)) as IconRef? {
                  iconRef = retIconRef
        }
        
        self.id = id
        self.localizedName = name
        self.category = category
        self.isSelectable = isSelectable
        self.isEnableable = isEnableable
        self.isSelected = isSelected
        self.isEnabled = isEnabled
        self.sourceLanguages = sourceLanguages
        self.iconImageURL = url
        self.iconRef = iconRef
    }
    
    
}
