//
//  Module: Navigator
//  Created by: MrTrent on 24.10.2022
//  Copyright (c) 2022 Zordz Union
//  


import Foundation

// MARK: - Fast access vars
extension Navigator {
    /**Current top on screen navigation controller or nil(powered by ZUCore)*/
    public static var navigationController: UINavigationController? {
        return Navigator.shared.navigationController
    }
    
    
    /**Tab bar controller if it's a window root contoller**/
    public static var tabBarController: UITabBarController? {
        return UIApplication.shared.rootVC as? UITabBarController
    }
    
    
    /**Returns all registered url patterns(chained to your constructors) as array of strings.**/
    public static var urlPatterns: [String] {
        return Navigator.shared.urlPatterns
    }
}
