import Foundation

protocol IOHIDDeviceConvertible {
    init(iohidDevice: IOHIDDevice)
}

public struct InputValue {
    
    // The unique id of the input value
    public var id: Int?
    
    // A key for specifying the vendor ID of the device.
    public var vendorId: Int?
    
    // A key that specifies the manufacturer of the device.
    public var manufacturer: String?
    
    // A key that specifies the device's serial number.
    public var serialNumber: String?
    
    // A key for specifying the product identifier of the device.
    public var product: String?
    
    // A key for specifying the version number of the device.
    public var versionNumber: Int?
    
    // A key for specifying the product identifier of the device.
    public var productId: Int?
    
    // A key for specifying the transport mechanism of the device.
    public var transport: String?
    
    // A key that specifies the country code or region of the device.
    public var countryCode: Int?
    
    init(id: Int? = nil,
         vendorId: Int? = nil,
         manufacturer: String? = nil,
         serialNumber: String? = nil,
         product: String? = nil,
         versionNumber: Int? = nil,
         productId: Int? = nil,
         transport: String? = nil,
         countryCode: Int? = nil) {
        self.id = id
        self.vendorId = vendorId
        self.manufacturer = manufacturer
        self.serialNumber = serialNumber
        self.product = product
        self.versionNumber = versionNumber
        self.productId = productId
        self.transport = transport
        self.countryCode = countryCode
    }
}

extension InputValue: IOHIDDeviceConvertible {
    init(iohidDevice: IOHIDDevice) {
        let id = IOHIDDeviceGetProperty(iohidDevice, kIOHIDUniqueIDKey as CFString) as? Int
        let serialNumber = IOHIDDeviceGetProperty(iohidDevice, kIOHIDSerialNumberKey as CFString) as? String
        let vendorId = IOHIDDeviceGetProperty(iohidDevice, kIOHIDVendorIDKey as CFString) as? Int
        let countryCode = IOHIDDeviceGetProperty(iohidDevice, kIOHIDCountryCodeKey as CFString) as? Int
        let manufacturer = IOHIDDeviceGetProperty(iohidDevice, kIOHIDManufacturerKey as CFString) as? String
        let product = IOHIDDeviceGetProperty(iohidDevice, kIOHIDProductKey as CFString) as? String
        let versionNumber = IOHIDDeviceGetProperty(iohidDevice, kIOHIDVersionNumberKey as CFString) as? Int
        let productId = IOHIDDeviceGetProperty(iohidDevice, kIOHIDProductIDKey as CFString) as? Int
        let transport = IOHIDDeviceGetProperty(iohidDevice, kIOHIDTransportKey as CFString) as? String
        
        self.id = id
        self.serialNumber = serialNumber
        self.vendorId = vendorId
        self.countryCode = countryCode
        self.manufacturer = manufacturer
        self.product = product
        self.versionNumber = versionNumber
        self.productId = productId
        self.transport = transport
    }
}
