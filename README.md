# input-source-manager
Library wrapper for Text Input Source Services API

# Getting Started

## Installation

### Swift Package Manager

To include InputSourceManager into a Swift Package Manger project add the `dependencies` value in your `Package.swift`:

```
let package = Package(
    // name, platforms, products, etc.
    dependencies: [
        // other dependencies
        .package(url: "https://github.com/robinlieb/input-source-manager.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "YourProject",
            dependencies: [
                .product(name: "InputSourceManager", package: "input-source-manager"),
            ]),
    ]
)
```

## Usage

You can use the InputSourceManager.getCurrentKeybaordInputSource() function to retrieve a representation of an input source object. 

```swift
import InputSourceManager

let inputSource = InputSourceManager().getCurrentKeybaordInputSource()
print(inputSource.id) // e.g com.apple.keylayout.US
```

