import Foundation
import Carbon

extension TISInputSource {
    func getProperty(for key: CFString) -> Any? {
        guard let pointer = TISGetInputSourceProperty(self, key) else {
            return nil
        }
        
        return  Unmanaged<AnyObject>.fromOpaque(pointer).takeUnretainedValue()
    }
}
