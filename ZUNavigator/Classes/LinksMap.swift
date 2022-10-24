//
//  Module: Navigator
//  Created by: MrTrent on 22.10.2022
//  Copyright (c) 2022 Zordz Union
//  


import Foundation

// MARK: Links map
extension Navigator {
    
    /**
     Return links map as array of tuples(URL-ViewController) for specified or top navigation controller.
     
     - parameter navigationController: Specified UINavigationController? or nil.
     - returns: Array of tuples(URL-ViewController)
     - warning: If navigationController is nil and top navigation controller is nil will return empty array.
     
     # Notes: #
     1. If navigationController is nil, by default used top navigation controller if can.
     2. If debug enabled, map will be printed as formatted text in console.
     
     # Example #
     ```
     let map = Navigator.linksMap()
     let map = Navigator.linksMap(for: navigationController)
     ```
     */
    @discardableResult public class func linksMap(for navigationController: UINavigationController? = nil) -> [(URL, UIViewController)] {
        return Navigator.shared.linksMap(for: navigationController)
    }
    
    
    /**
     Return links map as array of tuples(URL-ViewController) for specified tab bar controller and tab index.
     
     - parameter tabBarController: Specified UITabBarController? or nil.
     - parameter tabIndex: Specified tab bar index.
     - returns: Array of tuples(URL-ViewController)
     - warning: If tabBarController is nil and window root view controller isn't UITabBarController will return empty array.
     
     # Notes: #
     1. If tabBarController is nil, by default used window root tab bar controller if can.
     2. If debug enabled, map will be printed as formatted text in console.
     
     # Example #
     ```
     let map = Navigator.linksMap(tabIndex: 0)
     let map = Navigator.linksMap(for: tabBarController, tabIndex: 0)
     ```
     */
    @discardableResult public class func linksMap(for tabBarController: UITabBarController? = nil, tabIndex: Int) -> [(URL, UIViewController)] {
        return Navigator.shared.linksMap(for: tabBarController, tabIndex: tabIndex)
    }
    
    
    /**
     Return links map as array of array of tuples(URL-ViewController) for tab bar controller. The array index corresponds to tab index.
     
     - parameter tabBarController: Specified UITabBarController? or nil.
     - returns: Array of array of tuples(URL-ViewController)
     - warning: If tabBarController is nil and window root view controller isn't UITabBarController will return empty array.
     
     # Notes: #
     1. Index of returned array corresponds to tab index.
     2. If tabBarController is nil, by default used window root tab bar controller if can.
     3. If debug enabled, map will be printed as formatted text in console.
     
     # Example #
     ```
     let map = Navigator.linksMapTabs()
     let map = Navigator.linksMapTabs(for: tabBarController)
     ```
     */
    @discardableResult public class func linksMapTabs(for tabBarController: UITabBarController? = nil) -> [[(URL, UIViewController)]] {
        return Navigator.shared.linksMap(for: tabBarController)
    }
}
