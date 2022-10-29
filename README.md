# Navigator

[![CI Status](https://img.shields.io/travis/MrTrent/Navigator.svg?style=flat)](https://travis-ci.org/MrTrent/Navigator)
[![Version](https://img.shields.io/cocoapods/v/Navigator.svg?style=flat)](https://cocoapods.org/pods/Navigator)
[![License](https://img.shields.io/cocoapods/l/Navigator.svg?style=flat)](https://cocoapods.org/pods/Navigator)
[![Platform](https://img.shields.io/cocoapods/p/Navigator.svg?style=flat)](https://cocoapods.org/pods/Navigator)

## Info

Navigator allows you to reduce dependencies between controllers without calling them directly and make modular app, where each module is pod for example.
  List of main features:
  - Make push/pop segues by url.
  - Prevent push segue if view controller already in view controllers stack or if in next tab - depends on policy.
  - Update data on pop segue in target view controller.
  - Simple switch tabs or switch tabs with segue.
  - Call update method by url in first matching target view controller in stack. Or every matching. Or in next tabs. - depends on policy.
  - Call update by url everywhere in app.(Navigation and tab bar controllers must be registered in Navigator - or use ZNTabBarController/ZNBavigationController).
  - Prints links map of your stack.
  - And some other things.
  All public methods documented and separated to files for fast access. Look at classes root folder.

## Requirements

:small_blue_diamond: swift 5 :small_blue_diamond: ios 13.0 :small_blue_diamond:

## Installation

Navigator is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ZUNavigator'
```


## Simple integration example.

```swift
import ZUNavigator
```

Preparation
```swift
Navigator.debugEnabled = true // better set it enabled to see logs
Navigator.identicalLinksPolicy = .Open // more info in policy description
Navigator.updatePolicy = .FirstMatch // more info in policy description
```

Implementing short constructor for BlueViewController.
```swift
static let urlPattern: String = "/blue" // try start url pattern with '/'
class func register() {
    Navigator.register(url: urlPattern) { url, callback in
        let viewController = BlueViewController()
        viewController.setDate(url.queryItemValue("date"))
        let title = url.path.dropFirstAndUppercasedFirst()
        viewController.setTitle(title)
        callback(viewController)
    }
}
```

Implementing ZNTargetViewController_Protocol
```swift
var url: URL?
func update(via url: URL) {
    // your UI update or load data or etc...
}
```

Registering in Navigator environment.
```swift
    // inside appDelegate for example
    BlueViewController.register()
```  

Push to Blue controller via url.
```swift
    Navigator.push(by: URL(string: "/blue")!)
```  

Pop to controller via url.
```swift
    Navigator.popTo(url: URL(string: "/blue")!)
```

Update controller via url.
```swift
    Navigator.update(by url: URL(string: "/blue")!)
```

Links map of top navigation controller(presented not included).
```swift
    Navigator.linksMap() // prints to logs or you can by yourselves
```

Global call update(everywhere in app). You must register your UINavigationControllers and UITabbarControllers or use: ZNTabBarController/ZNBavigationController
```swift
    Navigator.updateEveryWhere(by url: URL(string: "/blue")!)
```

:small_blue_diamond: Look example project and root pod files for more info about push, pop, register, links map and other. :small_blue_diamond: 

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.
In this example, for red and green controllers made simulation of loading data.

## Short description of full features list as listing of public methods and vars:

:small_orange_diamond: Fast access vars.    
```swift
    /**Current top on screen navigation controller or nil(powered by ZUCore)*/
    public static var navigationController: UINavigationController?
    
    /**Tab bar controller if it's a window root contoller**/
    public static var tabBarController: UITabBarController?
    
    /**Returns all registered url patterns(chained to your constructors) as array of strings.**/
    public static var urlPatterns: [String]
```

:small_orange_diamond: Settings.    
```swift
    /**Behavior policy which determines how deep the update by url data is applied.*/
    public static var identicalLinksPolicy: IdenticalLinksPolicy
    
    /**Behavior policy which determines how deep the update by url data is applied.*/
    public static var updatePolicy: UpdatePolicy
    
    /**Enable or disable logs. Logs prints only in debug scheme.*/
    public static var debugEnabled: Bool
```

:small_orange_diamond: Registring url patterns and etc.
```swift
    // MARK: - Register url patterns and constructors
    /**Register(chaine) url pattern and specified view controller constructor for push segue.*/
    public class func register(url: String, constructor: @escaping ViewControllerConstructor)
    
    
    /**Register array of urls and specified view controller constructor for push segues.*/
    public class func register(urls: [String], constructor: @escaping ViewControllerConstructor)
    
    
    // MARK: - Register/release navigation or tab bar controllers
    /**Registers UITabBarController or UINavigationController in Navigator environment.*/
    public class func register(_ controller: UIViewController)
    
    /**Releases UITabBarController or UINavigationController from Navigator environment.*/
    public class func release(_ controller: UIViewController)
```

:small_orange_diamond: Navigation controllers segues.    
```swift
    // MARK: - Push segues
    /**Make push segue by url with completion callback.*/
    public class func push(by url: URL, queryItems: [URLQueryItem] = [], navigationController: UINavigationController? = nil, animated: Bool = true, policy: IdenticalLinksPolicy? = nil, completion: PushSegueCompletionHandler? = nil)
    
    
    // MARK: - Pop segues
    /**Make pop segue by url with completion callback.*/
    public class func popTo(url: URL, queryItems: [URLQueryItem] = [], navigationController: UINavigationController? = nil, forceUpdate: Bool = false, animated: Bool = true, completion: PopSegueCompletionHandler? = nil)
    
    /**Make common pop segue(one view controller) with completion callback.*/
    public class func pop(queryItems: [URLQueryItem] = [], navigationController: UINavigationController? = nil, forceUpdate: Bool = false, animated: Bool = true, completion: PopSegueCompletionHandler? = nil)
    
    /**Make common pop to root view controller segue with completion callback.*/
    public class func popToRoot(queryItems: [URLQueryItem] = [], navigationController: UINavigationController? = nil, forceUpdate: Bool = false, animated: Bool = true, completion: PopSegueCompletionHandler? = nil)
    
    /**Fast access to default pop method of navigation controller. No data update.*/
    public class func popViewController(animated: Bool = true)
```

:small_orange_diamond: Tab bar controllers tab switching and segues.    
```swift
    // MARK: - Switch tabs
    /**Switch tab in tab bar controller with completion callback.*/
    public class func switchTab(to tabIndex: Int, tabBarController: UITabBarController? = nil, completion: SwitchTabSegueCompletionHandler? = nil)
    
    
    // MARK: - Switch tabs and push segue
    /**Combination of: Switch tab in tab bar controller with completion callback and then push segue by url with completion callback.*/
    public class func switchTabAndPush(to tabIndex: Int, tabBarController: UITabBarController? = nil, switchCompletion: SwitchTabSegueCompletionHandler? = nil, pushTo url: URL, queryItems: [URLQueryItem] = [], animated: Bool = true, policy: IdenticalLinksPolicy? = nil, segueCompletion: PushSegueCompletionHandler? = nil)
    
    
    // MARK: - Switch tabs and pop segue
    /**Combination of: Switch tab in tab bar controller with completion callback and then pop segue by url with completion callback.*/
    public class func switchTabAndPopTo(to tabIndex: Int, tabBarController: UITabBarController? = nil, switchCompletion: SwitchTabSegueCompletionHandler? = nil, popTo url: URL, queryItems: [URLQueryItem] = [], forceUpdate: Bool = false, animated: Bool = true, segueCompletion: PopSegueCompletionHandler? = nil)
    
    /**Combination of: Switch tab in tab bar controller with completion callback and then pop one controller segue with completion callback.*/
    public class func switchTabAndPop(to tabIndex: Int, tabBarController: UITabBarController? = nil, switchCompletion: SwitchTabSegueCompletionHandler? = nil, queryItems: [URLQueryItem] = [], forceUpdate: Bool = false, animated: Bool = true, segueCompletion: PopSegueCompletionHandler? = nil)
    
    /**Combination of: Switch tab in tab bar controller with completion callback and then pop to root controller segue with completion callback.*/
    public class func switchTabAndPopToRoot(to tabIndex: Int, tabBarController: UITabBarController? = nil, switchCompletion: SwitchTabSegueCompletionHandler? = nil, queryItems: [URLQueryItem] = [], forceUpdate: Bool = false, animated: Bool = true, segueCompletion: PopSegueCompletionHandler? = nil)
```

:small_orange_diamond: Update data in view controllers via url.    
```swift
    // MARK: - Update navigation controller
    /**Update data via url in navigation controller.*/
    public class func update(by url: URL, queryItems: [URLQueryItem] = [], navigationController: UINavigationController? = nil, policy: UpdatePolicy? = nil, forceUpdate: Bool = false)
    
    
    // MARK: - Update tab bar controller
    /**Update data via url in tab bar controller for specified tab index.*/
    public class func updateTabBar(by url: URL, queryItems: [URLQueryItem] = [], tabBarController: UITabBarController? = nil, tabIndex: Int, policy: UpdatePolicy? = nil, forceUpdate: Bool = false)
    
    /**Update data via url in tab bar controller at every tab and every matching view controller.*/
    public class func updateTabBar(by url: URL, queryItems: [URLQueryItem] = [], tabBarController: UITabBarController? = nil, forceUpdate: Bool = false)
    
    
    // MARK: - Update everywhere
    /**Call update() everywhere. Based ONLY on registered UINavigationControllers, UITabBarControllers.*/
    public class func updateEveryWhere(by url: URL, queryItems: [URLQueryItem] = [], forceUpdate: Bool = false)
```

:small_orange_diamond: Links map.    
```swift
    /**Return links map as array of tuples(URL-ViewController) for specified or top navigation controller.*/
    @discardableResult public class func linksMap(for navigationController: UINavigationController? = nil) -> [(URL, UIViewController)]
    
    /**Return links map as array of tuples(URL-ViewController) for specified tab bar controller and tab index.*/
    @discardableResult public class func linksMap(for tabBarController: UITabBarController? = nil, tabIndex: Int) -> [(URL, UIViewController)]
    
    /**Return links map as array of array of tuples(URL-ViewController) for tab bar controller. The array index corresponds to tab index.*/
    @discardableResult public class func linksMapTabs(for tabBarController: UITabBarController? = nil) -> [[(URL, UIViewController)]]
```

:small_orange_diamond: Url short cases.    
```swift
    /** Pseudo url. You can use it as short case to pop to root. */
    static let rootURL: URL = URL(string: "POP_ROOT")!
    
    /** Pseudo url. You can use it as short case to pop to root. */
    static let rootSlashURL: URL = URL(string: "/")!
    
    /** Pseudo url. You can use it as short case to pop one view controller */
    static let popURL: URL = URL(string: "POP_ONE")!
```

:small_orange_diamond: Implement this protocol for full support Navigator.
```swift
    public protocol ZNTargetViewController_Protocol: UIViewController {
    
        /// View controller url which should be used in Navigator.
        var url: URL? {set get}
    
        /// Used to update data on pop. URL path used as uniq, but query part can be changed to transfer new data to target view controller.
        func update(via url: URL)
    }
```

:small_orange_diamond: UINavigationController and UITabBarController with auto register/release.
```swift
    // UINavigationController
    class CustomNavigationController: ZNNavigationController {
    
    }
    // UITabBarController
    class CustomTabBarController: ZNTabBarController {
    
    }
```



## Url examples    
Here some examples of patterns and urls.
|  Pattern  |  Url examples  |
| ------------- | ------------- |
|  "/wallet"  |  "/wallet"  |
|  "page/%i"  |  "page/:12"  |
|  "page/%i"  |  "page/12" - will be deprecated  |
|  "/profile/%s"  |  "/profile/:ivan"  |
|  "/feed/%s/page/%d"  |  "/feed/:ivan/page/:10"  |
|  "/feed/%s/%d"  |  "/feed/:ivan/:10"  |



## Version description    
v.0.0.5    
- Minor update to url patterns.    
Now, you can use urls with string params at path.    
Pattern: ”/profile/%s”. Url call: “/profile/:ivan”.    
Also, will be deprecated url calls with double parameters without explicit parameter specification.    
Explanation:    
You have url pattern - “/profile/%d”.    
You can call url as: “/profile/123” or “/profile/:123”.    
“/test/123” - this option will be deprecated soon.    
- Example fixes    



## Author

MrTrent, show6time@gmail.com

## License

Navigator is available under the MIT license. See the LICENSE file for more info.
