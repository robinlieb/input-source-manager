import Foundation
import Carbon

public protocol InputSourceEventManaging {
    func listen(event: @escaping ((InputSourceEvent) -> Void))
}

public class InputSourceEventManager: InputSourceEventManaging {
    
    // MARK: - Properties
    let inputSourceManager: InputSourceManaging
    let iohidManager: IOHIDManager
    let notificationCenter: CFNotificationCenter
    var completionHandler: ((InputSourceEvent) -> Void)?
    
    // MARK: - Init
    
    public init(inputSourceManager: InputSourceManaging, iohidManager: IOHIDManager, notificationCenter: CFNotificationCenter) {
        self.inputSourceManager = inputSourceManager
        self.iohidManager = iohidManager
        self.notificationCenter = notificationCenter
    }
    
    public convenience init() {
        self.init(inputSourceManager: InputSourceManager(),
                  iohidManager: IOHIDManagerCreate(kCFAllocatorDefault, IOOptionBits(kIOHIDOptionsTypeNone)),
                  notificationCenter: CFNotificationCenterGetDistributedCenter())
    }
    
    deinit {
        print("deinit \(self)")
    }
    
    // MARK: - Methods
    public func listen(event: @escaping ((InputSourceEvent) -> Void)) {
        let context = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
        CFNotificationCenterAddObserver(notificationCenter, context, layoutCallback, kTISNotifySelectedKeyboardInputSourceChanged, nil, .deliverImmediately)
        
        let criteria = [
            [kIOHIDDeviceUsagePageKey: kHIDPage_GenericDesktop, kIOHIDDeviceUsageKey : kHIDUsage_GD_Keyboard],
            [kIOHIDDeviceUsagePageKey: kHIDPage_GenericDesktop, kIOHIDDeviceUsageKey : kHIDUsage_GD_Keypad],
        ]
        
        IOHIDManagerSetDeviceMatchingMultiple(iohidManager, criteria as CFArray)
        IOHIDManagerRegisterInputValueCallback(iohidManager, inputValueCallback, context)
        IOHIDManagerScheduleWithRunLoop(iohidManager, CFRunLoopGetMain(), CFRunLoopMode.defaultMode.rawValue)
        IOHIDManagerOpen(iohidManager, IOOptionBits(kIOHIDOptionsTypeNone))
        completionHandler = event
    }
    
    // MARK: - Helpers
    private func createDict(page: Int, usage: Int) -> CFMutableDictionary {
        [kIOHIDDeviceUsagePageKey: page, kIOHIDDeviceUsageKey : usage] as! CFMutableDictionary
    }
    
    // MARK: - Callbacks
    var layoutCallback: CFNotificationCallback = { _, observer, _, _, _ in
        
        guard let observer = observer else {
            return
        }
        
        let selfObserver = Unmanaged<InputSourceEventManager>.fromOpaque(observer).takeUnretainedValue()
        
        guard let inputSource = selfObserver.inputSourceManager.getCurrentKeybaordInputSource() else {
            return
        }
        
        selfObserver.completionHandler?(.inputSource(inputSource))
    }
    
    let inputValueCallback: IOHIDValueCallback = { context, _, sender, _ in
        
        guard let context = context else {
            return
        }
        
        let selfObserver = Unmanaged<InputSourceEventManager>.fromOpaque(context).takeUnretainedValue()
        
        selfObserver.completionHandler?(.inputValue(InputValue(id: "")))
    }
}
