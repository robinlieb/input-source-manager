import Foundation
import Carbon
import SwiftUI

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
        guard let id = tisInputSource.getProperty(for: kTISPropertyInputSourceID) as? String else {
            return nil
        }
        
        guard let name = tisInputSource.getProperty(for: kTISPropertyLocalizedName) as? String else {
            return nil
        }
        
        guard let category = tisInputSource.getProperty(for: kTISPropertyInputSourceCategory) as? String else {
            return nil
        }
        
        guard let isSelectable = tisInputSource.getProperty(for: kTISPropertyInputSourceIsSelectCapable) as? Bool else {
            return nil
        }
        
        guard let isEnableable = tisInputSource.getProperty(for: kTISPropertyInputSourceIsEnableCapable) as? Bool else {
            return nil
        }
        
        guard let isSelected = tisInputSource.getProperty(for: kTISPropertyInputSourceIsSelected) as? Bool else {
            return nil
        }
        
        guard let isEnabled = tisInputSource.getProperty(for: kTISPropertyInputSourceIsEnabled) as? Bool else {
            return nil
        }
        
        guard let sourceLanguages = tisInputSource.getProperty(for: kTISPropertyInputSourceLanguages) as? [String] else {
            return nil
        }
        
        self.id = id
        self.localizedName = name
        self.category = category
        self.isSelectable = isSelectable
        self.isEnableable = isEnableable
        self.isSelected = isSelected
        self.isEnabled = isEnabled
        self.sourceLanguages = sourceLanguages
        self.iconImageURL = tisInputSource.getProperty(for: kTISPropertyIconImageURL) as? URL
        self.iconRef = OpaquePointer(TISGetInputSourceProperty(tisInputSource, kTISPropertyIconRef)) as IconRef?
    }
    
    
}
