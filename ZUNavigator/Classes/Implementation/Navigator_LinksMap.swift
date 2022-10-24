//
//  Module: Navigator
//  Created by: MrTrent on 05.10.2022
//  Copyright (c) 2022 Zordz Union
//  


import Foundation

// MARK: - Links map
extension Navigator {
    
    /// Return links map as array of tuples(URL-ViewController) for specified or top navigation controller.
    internal func linksMap(for navigationController: UINavigationController? = nil, print: Bool = true) -> [(URL, UIViewController)] {
        guard let navigationController = navigationController ?? self.navigationController else { return [] }
        
        var linksMap: [(URL, UIViewController)] = []
        for viewController in navigationController.viewControllers {
            linksMap.append((viewController._url, viewController))
        }
        
        if print {
            printLinksMap(linksMap)
        }
        
        return linksMap
    }
    
    /// Return links map as array of tuples(URL-ViewController) for some tab index of window root tab bar or specified tab bar controller.
    internal func linksMap(for tabBarController: UITabBarController? = nil, tabIndex: Int, print: Bool = true) -> [(URL, UIViewController)] {
        var _linksMap: [(URL, UIViewController)] = []
        
        defer {
            if print {
                printLinksMap(_linksMap)
            }
        }
        
        guard let tabBarController = tabBarController ?? self.tabBarController, let viewControllers = tabBarController.viewControllers else { return _linksMap }
        
        // check tab bar controller tabs and tab index
        assertTabBar(count: viewControllers.count, tabIndex: tabIndex)
        
        // controller at tab index
        let viewController = viewControllers[tabIndex]
        
        // if root controller isn't based on UINavigationController
        guard let navigationController = viewControllers[tabIndex] as? UINavigationController else {
            _linksMap = [(viewController._url, viewController)]
            return _linksMap
        }
        
        // get map for UINavigationController
        _linksMap = linksMap(for: navigationController, print: false)
        return _linksMap
    }
    
    /// Return links map as array of array of tuples(URL-ViewController) for window root tab bar or specified tab bar controller. The array index corresponds to the tab index.
    internal func linksMap(for tabBarController: UITabBarController? = nil, print: Bool = true) -> [[(URL, UIViewController)]] {
        guard let tabBarController = tabBarController ?? self.tabBarController, let viewControllers = tabBarController.viewControllers, viewControllers.count > 0 else { return [] }
        
        var _linksMap: [[(URL, UIViewController)]] = []
        for i in 0..<viewControllers.count {
            let map = linksMap(for: tabBarController, tabIndex: i, print: false)
            _linksMap.append(map)
        }
        
        if print {
            printLinksMap(_linksMap)
        }
        
        return _linksMap
    }
}
