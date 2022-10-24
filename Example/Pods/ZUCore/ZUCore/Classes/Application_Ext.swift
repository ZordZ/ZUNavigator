//
//  Module: ZUCore
//  Created by: MrTrent on 21.08.2022
//  Copyright (c) 2022 Zordz Union
//


import Foundation

// access to navigation and view controllers
public extension UIApplication {
    /// returns selected window
    var selectedWindow: UIWindow? {
        return UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    }
    
    /// returns root view controller of selected window
    var rootVC: UIViewController? {
        return selectedWindow?.rootViewController
    }
    
    /// return top UINavigationController - doesn't include presented
    var topNavigationController: UINavigationController? {
        let rootVC = rootVC
        // common case
        if let nav = rootVC as? UINavigationController {
            return nav
        }
        if let tab = rootVC as? UITabBarController {
            if let selected = tab.selectedViewController as? UINavigationController {
                return selected
            }
        }
        
        return nil
    }
    
    /// return top UIViewController - doesn't include presented
    var topViewController: UIViewController? {
        if let nc = topNavigationController {
            return nc.viewControllers.last
        }
        return rootVC
    }
}


// adds ability to make push/pop - need we? - it's future part of router
//public extension UIApplication {
//    /// Uses a horizontal slide transition. Has no effect if the view controller is already in the stack.
//    func pushViewController(_ viewController: UIViewController, animated: Bool) {
//        topNavigationController?.pushViewController(viewController, animated: animated)
//    }
//
//    /// Returns the popped controller.
//    func popViewController(animated: Bool) -> UIViewController? {
//        return topNavigationController?.popViewController(animated: animated)
//    }
//
//    /// Pops view controllers until the one specified is on top. Returns the popped controllers.
//    func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
//        return topNavigationController?.popToViewController(viewController, animated: animated)
//    }
//
//    /// Pops until there's only a single view controller left on the stack. Returns the popped controllers.
//    func popToRootViewController(animated: Bool) -> [UIViewController]? {
//        return topNavigationController?.popToRootViewController(animated: animated)
//    }
//}
