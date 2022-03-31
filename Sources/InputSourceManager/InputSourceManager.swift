import Foundation

public protocol InputSourceManaging {
    
}

public struct InputSourceManager: InputSourceManaging {
    // MARK: - Properties
    public private(set) var text = "Hello, World!"

    // MARK: - Init
    public init() {
    }
}
