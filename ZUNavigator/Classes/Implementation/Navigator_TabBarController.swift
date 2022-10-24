//
//  Module: Navigator
//  Created by: MrTrent on 05.10.2022
//  Copyright (c) 2022 Zordz Union
//  


import Foundation
import ZUCore

// MARK: - Tab bar controllers stuff
extension Navigator {
    
    /// Return tab bar controller if it's as root contoller
    internal var tabBarController: UITabBarController? {
        return UIApplication.shared.rootVC as? UITabBarController
    }
    
    
    // MARK: - Typealiases
    /// Block allows you to process switch action state if needed.
    public typealias SwitchTabSegueCompletionHandler = (SwitchState) -> Void
    
    
    // MARK: - State enums
    /// Used to track and debug switch action state
    public enum SwitchState: Equatable, StatePrintable_Protocol {
        /// Not allowed at this moment.
        case Blocked(Int)
        /// Tab bar controller not found
        case NotFoundTabBarController(Int)
        /// Tab bar controller not found
        case SuccessAlreadySwitched(Int)
        /// Segue completed successfully.
        case Success(Int)
        
        /// Debug description string
        public var description: String {
            switch self {
            case .Blocked(_):
                return "\tSwitching tab - NOT ALLOWED: \n\tWait until the end of the previous operations or segues."
            case .NotFoundTabBarController(_):
                return "\tSwitching tab - NOT ALLOWED: \n\tTab bar controller not found."
            case .SuccessAlreadySwitched(_):
                return "\tSwitching tab - COMPLETED SUCCESSFULLY. \n\tBut tab was already on screen."
            case .Success(_):
                return "\tSwitching tab - COMPLETED SUCCESSFULLY."
            }
        }
        
        /// Returns stored in state tab index value
        public var associatedValue: Int {
            switch self {
            case .Blocked(let tabIndex),
                    .NotFoundTabBarController(let tabIndex),
                    .SuccessAlreadySwitched(let tabIndex),
                    .Success(let tabIndex):
                return tabIndex
            }
        }
        
        /// Prints debug info in console
        internal func print() {
            if AppUtils.isDebug {
                Navigator.shared.printLogs("\(description)\n\tTab index: \(associatedValue)")
            }
        }
        
        // Equatable implementation
        public static func ==(lhs: SwitchState, rhs: SwitchState) -> Bool {
            switch (lhs, rhs) {
            case (let .Blocked(lhsTabIndex), let .Blocked(rhsTabIndex)):
                return lhsTabIndex == rhsTabIndex
            case (let .NotFoundTabBarController(lhsTabIndex), let .NotFoundTabBarController(rhsTabIndex)):
                return lhsTabIndex == rhsTabIndex
            case (let .SuccessAlreadySwitched(lhsTabIndex), let .SuccessAlreadySwitched(rhsTabIndex)):
                return lhsTabIndex == rhsTabIndex
            case (let .Success(lhsTabIndex), let .Success(rhsTabIndex)):
                return lhsTabIndex == rhsTabIndex
            default:
                return false
            }
        }
    }
    
    
    
    // MARK: - Switch tabs
    /// Switch tab in specified tab bar controller or window root controller with switchCompletionHandler callback which returns switching state. Returns targeted UITabBarController only on states .Success or .SuccessAlreadySwitched.
    @discardableResult internal func switchTab(to tabIndex: Int, tabBarController: UITabBarController? = nil, completion: SwitchTabSegueCompletionHandler? = nil) -> UITabBarController? {
        var state: SwitchState = .Blocked(tabIndex)
        
        defer {
            // print segue state
            printState(state)
            // unlock segues if we had some wrong state and it's state isn't Blocked
            if state != .Blocked(tabIndex) {
                isSegueing = false
            }
            // call segueCompletionHandler if we have
            completion?(state)
        }
        
        // segue not allowed at this moment
        if isSegueing {
            return nil
        }
        
        // block other segues until this one ended
        isSegueing = true
        
        // check tab bar controller
        let _tabBarController = tabBarController ?? self.tabBarController
        guard let tabBarController = _tabBarController, let viewControllers = tabBarController.viewControllers else {
            state = .NotFoundTabBarController(tabIndex)
            return nil
        }
        
        // check tab bar controller tabs and tab index
        assertTabBar(count: viewControllers.count, tabIndex: tabIndex)
        
        // open tab if need
        if tabBarController.selectedIndex == tabIndex {
            state = .SuccessAlreadySwitched(tabIndex)
            return tabBarController
        }
        
        // switching
        state = .Success(tabIndex)
        tabBarController.selectedIndex = tabIndex
        
        return tabBarController
    }
    
    
    // MARK: - Switch tabs and push segue
    /// Combination of Navigator methods - switch tab in tab bar and push segue to url in switched tab.
    internal func switchTabAndPush(to tabIndex: Int, tabBarController: UITabBarController? = nil, switchCompletion: SwitchTabSegueCompletionHandler? = nil, pushTo url: URL, queryItems: [URLQueryItem] = [], animated: Bool = true, identicalLinksPolicy: IdenticalLinksPolicy? = nil, segueCompletion: PushSegueCompletionHandler? = nil) {
        
        // used to print debug info, unlock segues on error and return to caller. Starting status is Blocked.
        var state: PushState = .Blocked(url)
        
        // segue not allowed at this moment
        if isSegueing {
            printState(state)
            segueCompletion?(state)
        }
        
        // try switch tab, get tabbar controller and then navigation controller
        guard let tabBarController = switchTab(to: tabIndex, tabBarController: tabBarController, completion: switchCompletion),
              let navigationController = tabBarController.viewControllers?[tabIndex] as? UINavigationController else {
            state = .NotFoundNavigationController(url)
            printState(state)
            segueCompletion?(state)
            return
        }
        
        // make push
        push(by: url, queryItems: queryItems, navigationController: navigationController, animated: animated, identicalLinksPolicy: identicalLinksPolicy, completion: segueCompletion)
    }
    
    
    // MARK: - Switch tabs and pop segue
    /// Combination of Navigator methods - switch tab in tab bar and pop segue to url in switched tab.
    internal func switchTabAndPopTo(to tabIndex: Int, tabBarController: UITabBarController? = nil, switchCompletion: SwitchTabSegueCompletionHandler? = nil, popTo url: URL, queryItems: [URLQueryItem] = [], forceUpdate: Bool = false, animated: Bool = true, segueCompletion: PopSegueCompletionHandler? = nil, ignoreBlocked: Bool = false) {
        
        // used to print debug info, unlock segues on error and return to caller. Starting status is Blocked.
        var state: PopState = .Blocked(url)
        
        // segue not allowed at this moment
        if isSegueing && !ignoreBlocked {
            printState(state)
            segueCompletion?(state)
        }
        
        // try switch tab, get tabbar controller and then navigation controller
        guard let tabBarController = switchTab(to: tabIndex, tabBarController: tabBarController, completion: switchCompletion),
              let navigationController = tabBarController.viewControllers?[tabIndex] as? UINavigationController else {
            state = .NotFoundNavigationController(url)
            printState(state)
            segueCompletion?(state)
            return
        }
        
        // make pop
        popTo(url: url, queryItems: queryItems, navigationController: navigationController, forceUpdate: forceUpdate, animated: animated, completion: segueCompletion, ignoreBlocked: ignoreBlocked)
    }
    
    /// If navigation in tab bar controller, will try open in nearby tab if url allready opened.
    internal func tryOpenInNearByTab(url: URL, navigationController: UINavigationController, queryItems: [URLQueryItem] = [], forceUpdate: Bool = false, animated: Bool = true, segueCompletion: PopSegueCompletionHandler? = nil, ignoreBlocked: Bool = false, allowDefer: Bool = true) -> Bool {
        // getting tabbar
        guard let tabBarController = tabBarController(for: navigationController), let viewControllers = tabBarController.viewControllers else { return false }
        // skip if tabbar is empty
        if viewControllers.count == 0 { return false }
        
        for i in 0..<viewControllers.count {
            let controller = viewControllers[i]
            // if root controller is navigation controller
            if let tabNavigationController = controller as? UINavigationController {
                if let _ = lastIndex(of: url, for: tabNavigationController) {
                    // selecting correct tab
                    tabBarController.selectedIndex = i
                    // pop to url
                    popTo(url: url, queryItems: queryItems, navigationController: tabNavigationController, forceUpdate: forceUpdate, animated: animated, completion: segueCompletion, ignoreBlocked: ignoreBlocked, allowDefer: allowDefer)
                    return true
                }
                
            // if root controller is view controller
            } else {
                // just switch to tab
                if controller._url.path == url.path {
                    // selecting correct tab
                    tabBarController.selectedIndex = i
                    return true
                }
            }
        }
        return false
    }
}
