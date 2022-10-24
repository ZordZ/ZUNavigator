//
//  Module: Navigator
//  Created by: MrTrent on 05.10.2022
//  Copyright (c) 2022 Zordz Union
//  


import Foundation
import ZUCore


// MARK: - Registration url patterns and etc
extension Navigator {
    
    // MARK: - Typealiases
    /// Block to transfer view controller from your constructor to Navigator
    public typealias ViewControllerConstructor_Callback = (ZNTargetViewController_Protocol?) -> ()
    
    /// Block provides url for your constructor and also provides block to transfer view controller back to Navigator
    public typealias ViewControllerConstructor = (URL, @escaping ViewControllerConstructor_Callback) -> ()
    
    
    // MARK: - url registration and list
    /// Register segue with url and specified view controller constructor
    internal func register(urlPattern: String, constructor: @escaping ViewControllerConstructor) {
        registeredUrls[urlPattern] = constructors.count
        constructors.append(constructor)
    }
    
    /// Register segue with batch of urls and specified view controller constructor
    internal func register(urlPatterns: [String], constructor: @escaping ViewControllerConstructor) {
        urlPatterns.forEach {
            registeredUrls[$0] = constructors.count
        }
        constructors.append(constructor)
    }
    
    /// Returns all registered url patterns
    internal var urlPatterns: [String] {
        return Array.init(registeredUrls.keys)
    }
    
    
    // MARK: - Register/release navigation and tab bar controllers
    /// Use to register UINavigationController or UITabBarController in Navigator environment
    internal func register(_ controller: UIViewController) {
        registeredControllers.insert(WeakWrapper(controller))
    }
    
    /// Use to relese UINavigationController or UITabBarController from Navigator environment
    internal func release(_ controller: UIViewController) {
        let addressStr = MemoryAddressUtils.getAddress(controller)
        if let index = registeredControllers.firstIndex(where: {$0.addressStr == addressStr}) {
            registeredControllers.remove(at: index)
        }
    }
}
