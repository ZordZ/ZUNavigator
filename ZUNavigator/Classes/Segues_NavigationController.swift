//
//  Module: Navigator
//  Created by: MrTrent on 22.10.2022
//  Copyright (c) 2022 Zordz Union
//  


import Foundation

// MARK: Navigation controllers segues
extension Navigator {
    
    
    // MARK: - Push segues
    /**
     Make push segue by url with completion callback.
     
     - parameter url: Url to search for view controller constructor.
     - parameter queryItems: Query part for url.
     - parameter navigationController: Specified navigation controller.
     - parameter animated: Indicates whether an animation is needed during the transition.
     - parameter identicalLinksPolicy: Custom policy.
     - parameter completion: Push segue completion block that allows you to implement status(PushState) processing.
     - warning: There is no assertionFailure, use debug mode because states are printed to console as formatted text and it's much easier to debug and remove issues rather than use assert.
     
     # Notes: #
     1. Argument queryItems isn't necessary and by default is empty array, so you can set queryItems by yourself in url parameter. But better practice is pass queryItems.
     2. If navigationController is nil, by default used top navigation controller if can.
     3. If identicalLinksPolicy not specified, used global by default. This provides some flexibility.
     
     # Example #
     ```
     Navigator.push(by: url)
     Navigator.push(by: url, queryItems: queryItems)
     Navigator.push(by: url, queryItems: queryItems, navigationController: navigationController)
     Navigator.push(by: url, queryItems: queryItems, navigationController: navigationController, animated: true) { state in
         // some code
         switch state {
             ...
         }
     }
     ```
     */
    public class func push(by url: URL, queryItems: [URLQueryItem] = [], navigationController: UINavigationController? = nil, animated: Bool = true, policy: IdenticalLinksPolicy? = nil, completion: PushSegueCompletionHandler? = nil) {
        Navigator.shared.push(by: url, queryItems: queryItems, navigationController: navigationController, animated: animated, identicalLinksPolicy: policy, completion: completion)
    }
    
    
    // MARK: - Pop segues
    /**
     Make pop segue by url with completion callback.
     
     - parameter url: Url to search in view controllers stack of navigation controllers.
     - parameter queryItems: Query part for url.
     - parameter navigationController: Specified navigation controller.
     - parameter forceUpdate: By default is false.
     - parameter animated: Indicates whether an animation is needed during the transition.
     - parameter completion: Pop segue completion block that allows you to implement status(PopState) processing.
     - warning: There is no assertionFailure, use debug mode because final state is printed to console as formatted text and it's much easier to debug and remove issues.
     
     # Notes: #
     1. Argument queryItems isn't necessary and by default is empty array, so you can set queryItems by yourself in url parameter. But better practice is pass queryItems.
     2. If navigationController is nil, by default used top navigation controller if can.
     3. You can use short case links defined as statics. rootURL or rootSlashURL - pop to root view controller. popURL - to pop one view controller.
     4. If you use short case links you can also use queryItems to change params at target view controller and call update.
     5. As short case you can use url "/" - it will pop to root view controller.
     6. Update will be called on view controllers implementing ZNTargetViewController_Protocol ONLY.
     7. Update calls before pop segue.
     8. Argument forceUpdate may be useful if you can't set new query items for update, but you really want call update.
     
     # Example #
     ```
     Navigator.popTo(url: Navigator.rootURL)
     Navigator.popTo(url: Navigator.popURL)
     Navigator.popTo(url: Navigator.rootSlashURL, queryItems: queryItems)
     Navigator.popTo(url: url)
     Navigator.popTo(url: url, queryItems: queryItems)
     Navigator.popTo(url: url, queryItems: queryItems, navigationController: navigationController)
     Navigator.popTo(url: url, queryItems: queryItems, navigationController: navigationController, forceUpdate: 0)
     Navigator.popTo(url: url, queryItems: queryItems, navigationController: navigationController, forceUpdate: 0, animated: true) { state in
         // some code
         switch state {
             ...
         }
     }
     ```
     */
    public class func popTo(url: URL, queryItems: [URLQueryItem] = [], navigationController: UINavigationController? = nil, forceUpdate: Bool = false, animated: Bool = true, completion: PopSegueCompletionHandler? = nil) {
        Navigator.shared.popTo(url: url, queryItems: queryItems, navigationController: navigationController, forceUpdate: forceUpdate, animated: animated, completion: completion, ignoreBlocked: false)
    }
    
    
    /**
     Make common pop segue(one view controller) with completion callback.
     
     - parameter queryItems: New query part for target view controller url.
     - parameter navigationController: Specified navigation controller.
     - parameter forceUpdate: By default is false.
     - parameter animated: Indicates whether an animation is needed during the transition.
     - parameter completion: Pop segue completion block that allows you to implement status(PopState) processing.
     - warning: There is no assertionFailure, use debug mode because segue state is printed to console as formatted text and it's much easier to debug and remove issues.
     
     # Notes: #
     1. Argument queryItems isn't necessary and by default is empty array, so you can set queryItems by yourself in url parameter. But better practice is pass queryItems.
     2. If navigationController is nil, by default used top navigation controller if can.
     3. You can use short case links defined as statics. rootURL or rootSlashURL - pop to root view controller. popURL - to pop one view controller.
     4. If you use short case links you can also use queryItems to change params at target view controller and call update.
     5. As short case you can use url "/" - it will pop to root view controller.
     6. Update will be called on view controllers implementing ZNTargetViewController_Protocol ONLY.
     7. Update calls before pop segue.
     8. Argument forceUpdate may be useful if you can't set new query items for update, but you really want call update.
     
     # Example #
     ```
     // this:
     Navigator.popTo(url: Navigator.popURL)
     // will grant same result as this:
     Navigator.pop()
     // other cases
     Navigator.pop(queryItems: queryItems)
     Navigator.pop(queryItems: queryItems, navigationController: navigationController)
     Navigator.pop(queryItems: queryItems, navigationController: navigationController, forceUpdate: 0)
     Navigator.pop(queryItems: queryItems, navigationController: navigationController, forceUpdate: 0, animated: true) { state in
         // some code
         switch state {
             ...
         }
     }
     ```
     */
    public class func pop(queryItems: [URLQueryItem] = [], navigationController: UINavigationController? = nil, forceUpdate: Bool = false, animated: Bool = true, completion: PopSegueCompletionHandler? = nil) {
        Navigator.shared.popTo(url: Navigator.popURL, queryItems: queryItems, navigationController: navigationController, forceUpdate: forceUpdate, animated: animated, completion: completion, ignoreBlocked: false)
    }
    
    
    /**
     Make common pop to root view controller segue with completion callback.
     
     - parameter queryItems: New query part for target view controller url.
     - parameter navigationController: Specified navigation controller.
     - parameter forceUpdate: By default is false.
     - parameter animated: Indicates whether an animation is needed during the transition.
     - parameter completion: Pop segue completion block that allows you to implement status(PopState) processing.
     - warning: There is no assertionFailure, use debug mode because segue state is printed to console as formatted text and it's much easier to debug and remove issues.
     
     # Notes: #
     1. Argument queryItems isn't necessary and by default is empty array, so you can set queryItems by yourself in url parameter. But better practice is pass queryItems.
     2. If navigationController is nil, by default used top navigation controller if can.
     3. You can use short case links defined as statics. rootURL or rootSlashURL - pop to root view controller. popURL - to pop one view controller.
     4. If you use short case links you can also use queryItems to change params at target view controller and call update.
     5. As short case you can use url "/" - it will pop to root view controller.
     6. Update will be called on view controllers implementing ZNTargetViewController_Protocol ONLY.
     7. Update calls before pop segue.
     8. Argument forceUpdate may be useful if you can't set new query items for update, but you really want call update.
     
     # Example #
     ```
     // this:
     Navigator.popTo(url: Navigator.rootURL)
     // or:
     Navigator.popTo(url: Navigator.rootSlashURL)
     // or
     Navigator.popTo(url: URL(string: "/")!)
     // will grant same result as this:
     Navigator.popToRoot()
     // other cases
     Navigator.popToRoot(queryItems: queryItems)
     Navigator.popToRoot(queryItems: queryItems, navigationController: navigationController)
     Navigator.popToRoot(queryItems: queryItems, navigationController: navigationController, forceUpdate: 0)
     Navigator.popToRoot(queryItems: queryItems, navigationController: navigationController, forceUpdate: 0, animated: true) { state in
         // some code
         switch state {
             ...
         }
     }
     ```
     */
    public class func popToRoot(queryItems: [URLQueryItem] = [], navigationController: UINavigationController? = nil, forceUpdate: Bool = false, animated: Bool = true, completion: PopSegueCompletionHandler? = nil) {
        Navigator.shared.popTo(url: Navigator.rootURL, queryItems: queryItems, navigationController: navigationController, forceUpdate: forceUpdate, animated: animated, completion: completion, ignoreBlocked: false)
    }
    
    /**Fast access to default pop method of navigation controller. No data update.*/
    public class func popViewController(animated: Bool = true) {
        Navigator.shared.navigationController?.popViewController(animated: animated)
    }
}
