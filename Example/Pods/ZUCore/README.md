# ZUCore

[![CI Status](https://img.shields.io/travis/MrTrent/ZUCore.svg?style=flat)](https://travis-ci.org/MrTrent/ZUCore)
[![Version](https://img.shields.io/cocoapods/v/ZUCore.svg?style=flat)](https://cocoapods.org/pods/ZUCore)
[![License](https://img.shields.io/cocoapods/l/ZUCore.svg?style=flat)](https://cocoapods.org/pods/ZUCore)
[![Platform](https://img.shields.io/cocoapods/p/ZUCore.svg?style=flat)](https://cocoapods.org/pods/ZUCore)

## Info

ZUCore - is the base layer for other libs. It's just bunch of extension and some usefull utils.

## Full features list:

:small_orange_diamond: AppUtils.    
(as Class)    
```swift
import ZUCore

// use to detect that app is runs with debug scheme
isDebug: Bool
```    

:small_orange_diamond: MemoryAddressUtils.    
(as Class)    
```swift
import ZUCore

// use to get address as string representation
let address = MemoryAddressUtils.getAddress(data)
```

:small_orange_diamond: UIApplication.shared.    
(as extension of UIApplication)
```swift
// use to get selected window
selectedWindow: UIWindow?

// use to get root view controller of selected window
rootVC: UIViewController?

// use to get top UINavigationController(doesn't include presented)
topNavigationController: UINavigationController?

// use to get top UIViewController(doesn't include presented)
topViewController: UIViewController?
```

:small_orange_diamond: Bundle.main.    
(as extension of Bundle)
```swift
// use to get app name
displayName: String 

// use to get app version
appVersion: String

// use to get build version
buildVersion: String

// use to get target name
targetName: String?
```

----

Later example will be added. 
So. To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

:small_blue_diamond: swift 5 :small_blue_diamond: ios 13.0 :small_blue_diamond:

## Installation

ZUCore is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ZUCore'
```

## Author

MrTrent, show6time@gmail.com

## License

ZUCore is available under the MIT license. See the LICENSE file for more info.
