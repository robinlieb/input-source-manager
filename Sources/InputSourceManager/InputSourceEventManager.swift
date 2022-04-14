import Foundation
import Carbon
import Combine

@available(macOS 10.15, *)
public class InputSourceEventManager: ObservableObject {
    
    // MARK: - Properties
    let inputSourceManager: InputSourceManaging
    let iohidManager: IOHIDManager
    let notificationCenter: CFNotificationCenter
    
    var context: UnsafeMutableRawPointer?
    
    @Published
    public private(set) var event: InputSourceEvent?
    
    // MARK: - Init
    
    public init(inputSourceManager: InputSourceManaging, iohidManager: IOHIDManager, notificationCenter: CFNotificationCenter) {
        self.inputSourceManager = inputSourceManager
        self.iohidManager = iohidManager
        self.notificationCenter = notificationCenter
        self.setup()
    }
    
    public convenience init() {
        self.init(inputSourceManager: InputSourceManager(),
                  iohidManager: IOHIDManagerCreate(kCFAllocatorDefault, IOOptionBits(kIOHIDOptionsTypeNone)),
                  notificationCenter: CFNotificationCenterGetDistributedCenter())
    }
    
    deinit {
        print("deinit \(self)")
        CFNotificationCenterRemoveEveryObserver(notificationCenter, context)
        IOHIDManagerClose(iohidManager, IOOptionBits(kIOHIDOptionsTypeNone))
        IOHIDManagerUnscheduleFromRunLoop(iohidManager, CFRunLoopGetMain(), CFRunLoopMode.defaultMode.rawValue)
    }
    
    // MARK: - Helpers
    private func setup() {
        context = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
        CFNotificationCenterAddObserver(notificationCenter, context, layoutCallback, kTISNotifySelectedKeyboardInputSourceChanged, nil, .deliverImmediately)
        
        let criteria = [
            [kIOHIDDeviceUsagePageKey: kHIDPage_GenericDesktop, kIOHIDDeviceUsageKey : kHIDUsage_GD_Keyboard],
            [kIOHIDDeviceUsagePageKey: kHIDPage_GenericDesktop, kIOHIDDeviceUsageKey : kHIDUsage_GD_Keypad],
        ]
        
        IOHIDManagerSetDeviceMatchingMultiple(iohidManager, criteria as CFArray)
        IOHIDManagerRegisterInputValueCallback(iohidManager, inputValueCallback, context)
        IOHIDManagerScheduleWithRunLoop(iohidManager, CFRunLoopGetMain(), CFRunLoopMode.defaultMode.rawValue)
        IOHIDManagerOpen(iohidManager, IOOptionBits(kIOHIDOptionsTypeNone))
    }
    
    private func createDict(page: Int, usage: Int) -> CFMutableDictionary {
        [kIOHIDDeviceUsagePageKey: page, kIOHIDDeviceUsageKey : usage] as! CFMutableDictionary
    }
    
    // MARK: - Callbacks
    var layoutCallback: CFNotificationCallback = { _, observer, _, _, _ in
        
        guard let observer = observer else {
            return
        }
        
        let selfPointer = Unmanaged<InputSourceEventManager>.fromOpaque(observer).takeUnretainedValue()
        
        guard let inputSource = selfPointer.inputSourceManager.getCurrentKeybaordInputSource() else {
            return
        }
        
        selfPointer.event = .inputSource(inputSource)
    }
    
    let inputValueCallback: IOHIDValueCallback = { context, _, sender, _ in
        
        guard let context = context,
              let sender = sender else {
            return
        }
        
        let selfPointer = Unmanaged<InputSourceEventManager>.fromOpaque(context).takeUnretainedValue()
        
        let senderDevice = Unmanaged<IOHIDDevice>.fromOpaque(sender).takeUnretainedValue()
        
        let inputValue = InputValue(iohidDevice: senderDevice)
        
        selfPointer.event = .inputValue(inputValue)
    }
}
