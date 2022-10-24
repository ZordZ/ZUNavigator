//
//  Module: Navigator
//  Created by: MrTrent on 17.10.2022
//  Copyright (c) 2022 Zordz Union
//  


import Foundation
import UIKit

// MARK: - Navigation update data by urls
extension Navigator {
    
    
    // MARK: - Update Policy
    /// Behavior policy which determines how deep the update by url data is applied.
    public enum UpdatePolicy: Int, Equatable, CaseIterable, Comparable {
        /// Call update() at first found view controller with url matching from end of stack
        case FirstMatch = 0
        /// Call update() at every found view controller with url matching in stack of view controller.
        case EveryMatch
        /// Call update() at every found view controller with url matching in stack of view controller. And this applies to every tab of tab bar controller.
        case EveryMatchAndNearBy
        
        public static func <(lhs: UpdatePolicy, rhs: UpdatePolicy) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }
    }
    
    
    // MARK: - State enums
    /// The status reflects the process of calling the update.
    enum UpdateState: Equatable {
        /// View controller is nil
        case NoViewController(URL)
        /// View controllers url path not equal to passed url path
        case MismatchURL(URL)
        /// No need to update - same queries in url - Success type
        case NoNeed(URL)
        /// Can't call update doesn't comform to ZNTargetViewController_Protocol - Success type
        case Issue(URL)
        /// No problems with update() call - Success type
        case Done(URL)
        
        // Equatable implementation
        public static func ==(lhs: UpdateState, rhs: UpdateState) -> Bool {
            switch (lhs, rhs) {
            case (let .NoNeed(lhsURL), let .NoNeed(rhsURL)):
                return lhsURL == rhsURL
            case (let .Issue(lhsURL), let .Issue(rhsURL)):
                return lhsURL == rhsURL
            case (let .Done(lhsURL), let .Done(rhsURL)):
                return lhsURL == rhsURL
            default:
                return false
            }
        }
        
        // Fast check to success type
        public var isSuccessType: Bool {
            switch self {
            case .NoNeed(_), .Issue(_), .Done(_):
                return true
            default:
                return false
            }
        }
    }
    
    
    // MARK: - Update implementation - UITabBarController
    /// Update data via url in tab bar controller. If tabBarController is nil, update used to window root tab bar controller. You can set custom policy - sometimes may be usefull(other way used global policy). If policy == .EveryMatchEverywhere - will try update everywhere. Use force update if you realy sure that you need call update(). If you didn't specify a tab index - it will iterate over tabs and try call update based on updatePolicy.
    internal func updateTabBar(by url: URL, queryItems: [URLQueryItem] = [], tabBarController: UITabBarController? = nil, tabIndex: Int? = nil, updatePolicy: UpdatePolicy? = nil, forceUpdate: Bool = false) {
        // try get tabBarController
        guard let tabBarController = tabBarController ?? self.tabBarController else {
            assertionFailure("Tab bar controller not found.")
            return
        }
        
        // try update
        let states: [UpdateState] = update(by: url, queryItems: queryItems, tabBarController: tabBarController, tabIndex: tabIndex, updatePolicy: updatePolicy, forceUpdate: forceUpdate)
        
        // try print logs
        printUpdateInfo(url: url, queryItems: queryItems, states: states)
    }
    
    internal func update(by url: URL, queryItems: [URLQueryItem] = [], tabBarController: UITabBarController, tabIndex: Int? = nil, updatePolicy: UpdatePolicy? = nil, forceUpdate: Bool = false) -> [UpdateState] {
        guard let viewControllers = tabBarController.viewControllers else {
            assertionFailure("Tab bar controller haven't tabs.")
            return []
        }
        
        // check tab bar controller tabs and tab index
        assertTabBar(count: viewControllers.count, tabIndex: tabIndex)
        
        // get policy
        var updatePolicy = updatePolicy ?? self.updatePolicy
        // check tab index
        let tabIndex = tabIndex ?? -1
        // correcting policy
        if tabIndex == -1 {
            // if tab index is not specified, policy is .EveryMatchAndNearBy always
            updatePolicy = .EveryMatchAndNearBy
        } else {
            // if tab index is specified, but policy setted to .EveryMatchAndNearBy
            if updatePolicy == .EveryMatchAndNearBy {
                updatePolicy = .EveryMatch
            }
        }
        
        var states: [UpdateState] = []
        switch updatePolicy {
        case .EveryMatchAndNearBy:
            states = updateEveryTab(viewControllers: viewControllers, url: url, queryItems: queryItems, forceUpdate: forceUpdate)
            break
        case .FirstMatch, .EveryMatch:
            states = update(unknownController: viewControllers[tabIndex], url: url, queryItems: queryItems, updatePolicy: updatePolicy, forceUpdate: forceUpdate)
            break
        }
        
        return states
    }
    
    /// Will iterate every tab and update.
    fileprivate func updateEveryTab(viewControllers: [UIViewController], url: URL, queryItems: [URLQueryItem], forceUpdate: Bool = false) -> [UpdateState] {
        var states: [UpdateState] = []
        for viewController in viewControllers {
            let statesTemp = update(unknownController: viewController, url: url, queryItems: queryItems, updatePolicy: .EveryMatch, forceUpdate: forceUpdate)
            states.append(contentsOf: statesTemp)
        }
        return states
    }
    
    /// Method to use as tab bar method helper. As view controller can be passed UINavigationController or UIViewController.
    fileprivate func update(unknownController: UIViewController, url: URL, queryItems: [URLQueryItem] = [], updatePolicy: UpdatePolicy? = nil, forceUpdate: Bool = false) -> [UpdateState] {
        var states: [UpdateState] = []
        // if UINavigationController
        if let navigationController = unknownController as? UINavigationController {
            states = update(navigationController: navigationController, url: url, queryItems: queryItems, updatePolicy: updatePolicy, forceUpdate: forceUpdate)
        
        // if UIViewController
        } else {
            let state = update(viewController: unknownController, url: url, forceUpdate: forceUpdate)
            states = [state]
        }
        
        return states
    }
    
    
    // MARK: - Update implementation - UINavigationController
    internal func update(by url: URL, queryItems: [URLQueryItem] = [], navigationController: UINavigationController? = nil, updatePolicy: UpdatePolicy? = nil, forceUpdate: Bool = false) {
        // try get top navigation controller
        guard let navigationController = navigationController ?? self.navigationController else {
            assertionFailure("Navigation controller not found.")
            return
        }
        // try update
        let states = update(navigationController: navigationController, url: url, queryItems: queryItems, updatePolicy: updatePolicy, forceUpdate: forceUpdate)
        // try print logs
        printUpdateInfo(url: url, queryItems: queryItems, states: states)
    }
    
    /// Update data via url in navigation controller. You can set custom policy - sometimes may be usefull(other way used global policy). If policy == .EveryMatchEverywhere - will try update everywhere.
    internal func update(navigationController: UINavigationController, url: URL, queryItems: [URLQueryItem] = [], updatePolicy: UpdatePolicy? = nil, forceUpdate: Bool = false) -> [UpdateState] {
        // custom policy if need
        var updatePolicy = updatePolicy ?? self.updatePolicy
        
        var states: [UpdateState] = []
        
        switch updatePolicy {
        case .EveryMatchAndNearBy:
            // getting tabbar - if we here and we have tab bar controller - single navigation controller not interested now
            if let tabBarController = tabBarController(for: navigationController) {
                // all logs lays to this method
                return update(by: url, queryItems: queryItems, tabBarController: tabBarController, tabIndex: nil, updatePolicy: updatePolicy, forceUpdate: forceUpdate)
            }
            // if we here, so tab bar not found and we need change policy to EveryMatch to fall through into next case
            updatePolicy = .EveryMatch
            fallthrough
            
        case .FirstMatch, .EveryMatch:
            states = update(viewControllers: navigationController.viewControllers, url: url, queryItems: queryItems, updatePolicy: updatePolicy, forceUpdate: forceUpdate)
            break
        }
        
        return states
    }
    
    /// Updates view controllers from end based on passed policy
    fileprivate func update(viewControllers: [UIViewController], url: URL, queryItems: [URLQueryItem], updatePolicy: UpdatePolicy, forceUpdate: Bool) -> [UpdateState] {
        // making url mutable
        var url = url
        if queryItems.count > 0 {
            url.append(queryItems: queryItems)
        }
        
        // updating
        var states: [UpdateState] = []
        for index in stride(from: viewControllers.count - 1, through: 0, by: -1) {
            let state = update(viewController: viewControllers[index], url: url, forceUpdate: forceUpdate)
            states.append(state)
            if state.isSuccessType && updatePolicy == .FirstMatch { break }
        }
        
        return states
    }
    
    
    // MARK: - Update implementation - UIViewController
    /// Main method to update data by url in target view controller
    @discardableResult internal func update(viewController: UIViewController?, url: URL, forceUpdate: Bool) -> UpdateState {
        // Nil check
        guard let viewController = viewController else { return .NoViewController(url) }
        
        // View controllers url path not equal to passed url path
        if viewController._url.path != url.path { return .MismatchURL(url) }
        
        // check if need update
        let needUpdate: Bool = forceUpdate || viewController._url != url
        
        // try update
        if needUpdate {
            if let viewController = viewController as? ZNTargetViewController_Protocol {
                // call update
                viewController.update(via: url)
                // set url to view controller
                viewController.url = url
                // indicates that segue success, and update called
                return .Done(url)
            } else {
                // can't call update() and set url
                return .Issue(url)
            }
        }
        
        // No need state any way - even if no query items - it's just some sort of indications
        return .NoNeed(url)
    }
    
    
    // MARK: - Global update everywhere
    internal func updateEveryWhere(by url: URL, queryItems: [URLQueryItem] = [], forceUpdate: Bool = false) {
        var states: [UpdateState] = []
        
        // collecting navigation controller
        var navigationControllersToUpdate: Set<UIViewController> = []
        
        // prepare controllers to update
        for wrapper in registeredControllers {
            switch wrapper.value {
            case is UINavigationController:
                navigationControllersToUpdate.insert(wrapper.value as! UINavigationController)
                break
            case is UITabBarController:
                if let viewControllers = (wrapper.value as! UITabBarController).viewControllers {
                    for controller in viewControllers {
                        navigationControllersToUpdate.insert(controller)
                    }
                }
                break
            default:
                break
            }
        }
        
        // updating
        for viewController in navigationControllersToUpdate {
            let statesTemp = update(unknownController: viewController, url: url, queryItems: queryItems, updatePolicy: .EveryMatch, forceUpdate: forceUpdate)
            states.append(contentsOf: statesTemp)
        }
        
        // try print logs
        printUpdateInfo(url: url, queryItems: queryItems, states: states)
    }
}
