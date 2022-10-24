//
//  Module: Navigator
//  Created by: MrTrent on 03.10.2022
//  Copyright (c) 2022 Zordz Union
//  


import Foundation
import ZUCore

internal extension UINavigationController {
    /// Uniq id as string based on memory address
    var uniqID: String {
        return MemoryAddressUtils.getAddress(self)
    }
}



// MARK: - Segues with Navigator
public extension UINavigationController {
    // typealiases - to cut some code
    typealias PushSegueCompletionHandler = Navigator.PushSegueCompletionHandler
    typealias PopSegueCompletionHandler = Navigator.PopSegueCompletionHandler
    typealias UpdatePolicy = Navigator.UpdatePolicy
    
    
    // MARK: Register/release navigation controllers
    /// Use to register UINavigationController in Navigator environment
    func register() {
        Navigator.register(self)
    }
    
    /// Use to relese UINavigationController from Navigator environment
    func release() {
        Navigator.release(self)
    }
    
    
    // MARK: Update data by url
    /// Updates data in view controller(controllers) for target url. View controllers must comforms to ZNTargetViewController_Protocol. You can set custom policy - sometimes may be usefull(other way used Navigator's global policy). If policy == .EveryMatchAndNearBy and navigation controller placed in tab bar controlle - also will try update everywhere in tab bar controller. Use force update if you realy sure that you need call update().
    func update(by url: URL, queryItems: [URLQueryItem] = [], updatePolicy: UpdatePolicy? = nil, forceUpdate: Bool = false) {
        Navigator.update(by: url, queryItems: queryItems, navigationController: self)
    }
    
    
    // MARK: Push segues
    /// Make push segue by url with segueCompletionHandler callback. You can set query items separated from url by queryItems parameter.
    func push(by url: URL, queryItems: [URLQueryItem] = [], animated: Bool = true, completion: PushSegueCompletionHandler? = nil) {
        Navigator.push(by: url, queryItems: queryItems, navigationController: self, animated: animated, completion: completion)
    }
    
    
    // MARK: Pop segues
    /// Make pop segue by url with segueCompletionHandler callback. If you want you can pass "/" as url to pop to root view controller - just short case. Will be called func update of protocol ZNTargetViewController_Protocol before pop if you set forceUpdate or if queryItems differs.
    func popTo(url: URL, queryItems: [URLQueryItem] = [], forceUpdate: Bool = false, animated: Bool = true, completion: PopSegueCompletionHandler? = nil) {
        Navigator.popTo(url: url, queryItems: queryItems, navigationController: self, forceUpdate: forceUpdate, animated: animated, completion: completion)
    }
    
    /// Make common pop segue. if needed with segueCompletionHandler callback. Will be called func update of protocol ZNTargetViewController_Protocol before pop if you set forceUpdate or if new queryItems differs.
    func pop(queryItems: [URLQueryItem] = [], forceUpdate: Bool = false, animated: Bool = true, completion: PopSegueCompletionHandler? = nil) {
        Navigator.pop(queryItems: queryItems, navigationController: self, forceUpdate: forceUpdate, animated: animated, completion: completion)
    }
    
    /// Make common pop to root view controller segue. If need with segueCompletionHandler callback. Will be called func update of protocol ZNTargetViewController_Protocol before pop if you set forceUpdate or if new queryItems differs.
    func popToRoot(queryItems: [URLQueryItem] = [], forceUpdate: Bool = false, animated: Bool = true, completion: PopSegueCompletionHandler? = nil) {
        Navigator.popToRoot(queryItems: queryItems, navigationController: self, forceUpdate: forceUpdate, animated: animated, completion: completion)
    }
    
    // MARK: Links map
    /// Returns links map as array of tuples(URL-ViewController).  In debug mode prints to console.
    func linksMap() -> [(URL, UIViewController)] {
        return Navigator.linksMap(for: self)
    }
}
