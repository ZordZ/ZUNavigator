//
//  Module: Navigator
//  Created by: MrTrent on 04.10.2022
//  Copyright (c) 2022 Zordz Union
//  


import Foundation
import ZUCore

internal extension UITabBarController {
    /// Uniq id as string based on memory address
    var uniqID: String {
        return MemoryAddressUtils.getAddress(self)
    }
}



// MARK: - Segues with Navigator
public extension UITabBarController {
    // typealiases - to cut some code
    typealias SwitchTabSegueCompletionHandler = Navigator.SwitchTabSegueCompletionHandler
    typealias PushSegueCompletionHandler = Navigator.PushSegueCompletionHandler
    typealias PopSegueCompletionHandler = Navigator.PopSegueCompletionHandler
    typealias IdenticalLinksPolicy = Navigator.IdenticalLinksPolicy
    typealias UpdatePolicy = Navigator.UpdatePolicy
    
    
    // MARK: Register/release tab bar controllers
    /// Use to register UITabBarController in Navigator environment
    func register() {
        Navigator.register(self)
    }
    
    /// Use to relese UITabBarController from Navigator environment
    func release() {
        Navigator.release(self)
    }
    
    
    // MARK: Update data by url
    /// Update data via url in tab bar controller for specified tab index or selected tab if not specified. You can set custom policy - sometimes may be usefull(other way used Navigator's global policy). Use force update if you realy sure that you need call update() anyway. Warning: updatePolicy == .EveryMatchAndNearBy will be ignored an lowered to .EveryMatch.
    func update(by url: URL, queryItems: [URLQueryItem] = [], tabIndex: Int?, policy: UpdatePolicy? = nil, forceUpdate: Bool = false) {
        let tabIndex = tabIndex ?? selectedIndex
        Navigator.updateTabBar(by: url, queryItems: queryItems, tabBarController: self, tabIndex: tabIndex, policy: policy, forceUpdate: forceUpdate)
    }
    
    /// Update data via url in tab bar controller in every tab. Use force update if you realy sure that you need call update() anyway. UpdatePolicy always .EveryMatchAndNearBy.
    func update(by url: URL, queryItems: [URLQueryItem] = [], forceUpdate: Bool = false) {
        Navigator.updateTabBar(by: url, queryItems: queryItems, tabBarController: self, forceUpdate: forceUpdate)
    }
    
    
    // MARK: Switch tabs
    /// Switch tab with switchCompletionHandler callback which returns switching state.
    func switchTab(to tabIndex: Int, completion: SwitchTabSegueCompletionHandler? = nil) {
        Navigator.switchTab(to: tabIndex, tabBarController: self, completion: completion)
    }
    
    
    // MARK: Switch tabs and push segue
    /// Combination of Navigator methods - switch tab in tab bar and push segue to url in switched tab.
    func switchTabAndPush(to tabIndex: Int, switchCompletion: SwitchTabSegueCompletionHandler? = nil, pushTo url: URL, queryItems: [URLQueryItem] = [], animated: Bool = true, policy: IdenticalLinksPolicy? = nil, segueCompletion: PushSegueCompletionHandler? = nil) {
        Navigator.switchTabAndPush(to: tabIndex, tabBarController: self, switchCompletion: switchCompletion, pushTo: url, queryItems: queryItems, animated: animated, policy: policy, segueCompletion: segueCompletion)
    }
    
    
    // MARK: Switch tabs and pop segue
    /// Combination of Navigator methods - switch tab in tab bar and pop segue to url in switched tab.
    func switchTabAndPopTo(to tabIndex: Int, tabBarController: UITabBarController? = nil, switchCompletion: SwitchTabSegueCompletionHandler? = nil, popTo url: URL, queryItems: [URLQueryItem] = [], forceUpdate: Bool = false, animated: Bool = true, segueCompletion: PopSegueCompletionHandler? = nil, ignoreBlocked: Bool = false) {
        Navigator.switchTabAndPopTo(to: tabIndex, tabBarController: self, switchCompletion: switchCompletion, popTo: url, queryItems: queryItems, forceUpdate: forceUpdate, animated: animated, segueCompletion: segueCompletion)
    }
    
    /// Combination of Navigator methods - switch tab in tab bar and pop segue in switched tab.
    func switchTabAndPop(to tabIndex: Int, tabBarController: UITabBarController? = nil, switchCompletion: SwitchTabSegueCompletionHandler? = nil, queryItems: [URLQueryItem] = [], forceUpdate: Bool = false, animated: Bool = true, segueCompletion: PopSegueCompletionHandler? = nil) {
        Navigator.switchTabAndPop(to: tabIndex, tabBarController: self, switchCompletion: switchCompletion, queryItems: queryItems, forceUpdate: forceUpdate, animated: animated, segueCompletion: segueCompletion)
    }
    
    /// Combination of Navigator methods - switch tab in tab bar and pop to root in switched tab.
    func switchTabAndPopToRoot(to tabIndex: Int, tabBarController: UITabBarController? = nil, switchCompletion: SwitchTabSegueCompletionHandler? = nil, queryItems: [URLQueryItem] = [], forceUpdate: Bool = false, animated: Bool = true, segueCompletion: PopSegueCompletionHandler? = nil) {
        Navigator.switchTabAndPopToRoot(to: tabIndex, tabBarController: self, switchCompletion: switchCompletion, queryItems: queryItems, forceUpdate: forceUpdate, animated: animated, segueCompletion: segueCompletion)
    }
    
    // MARK: Links map
    /// Return links map as array of tuples(URL-ViewController). For exmaple to print. In debug mode prints to console.
    func linksMap(for tabIndex: Int) -> [(URL, UIViewController)] {
        return Navigator.linksMap(for: self, tabIndex: tabIndex)
    }
    
    /// Return links map as array of array of tuples(URL-ViewController). The array index corresponds to the tab index. In debug mode prints to console.
    func linksMap() -> [[(URL, UIViewController)]] {
        return Navigator.linksMapTabs(for: self)
    }
}
