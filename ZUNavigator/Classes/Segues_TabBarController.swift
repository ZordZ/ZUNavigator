//
//  Module: Navigator
//  Created by: MrTrent on 22.10.2022
//  Copyright (c) 2022 Zordz Union
//  


import Foundation

// MARK: Tab bar controllers tab switching and segues
extension Navigator {
    
    // MARK: - Switch tabs
    /**
     Switch tab in tab bar controller with completion callback.
     
     - parameter tabIndex: Specified tab bar index.
     - parameter tabBarController: Specified tab bar controller.
     - parameter completion: Switch completion block that allows you to implement status(SwitchState) processing.
     - warning: There is no assertionFailure, use debug mode because states are printed to console as formatted text and it's much easier to debug and remove issues rather than use assert.
     
     # Notes: #
     1. If tabBarController is nil, by default used window root tab bar controller if can.
     
     # Example #
     ```
     Navigator.switchTab(to: 0)
     Navigator.switchTab(to: 0, tabBarController: tabBarController)
     Navigator.switchTab(to: 0, tabBarController: tabBarController) { state in
         switch state {
             // ...
         }
     }
     ```
     */
    public class func switchTab(to tabIndex: Int, tabBarController: UITabBarController? = nil, completion: SwitchTabSegueCompletionHandler? = nil) {
        Navigator.shared.switchTab(to: tabIndex, tabBarController: tabBarController, completion: completion)
    }
    
    
    // MARK: - Switch tabs and push segue
    /**
     Combination of: Switch tab in tab bar controller with completion callback and then push segue by url with completion callback.
     
     - parameter tabIndex: Specified tab bar index.
     - parameter tabBarController: Specified tab bar controller.
     - parameter completion: Switch completion block that allows you to implement status(SwitchState) processing.
     - parameter url: Url to search for view controller constructor.
     - parameter queryItems: Query part for url.
     - parameter animated: Indicates whether an animation is needed during the transition.
     - parameter identicalLinksPolicy: Custom policy.
     - parameter completion: Push segue completion block that allows you to implement status(PushState) processing.
     - warning: There is no assertionFailure, use debug mode because states are printed to console as formatted text and it's much easier to debug and remove issues rather than use assert.
     
     # Notes: #
     1. If tabBarController is nil, by default used window root tab bar controller if can.
     2. Argument queryItems isn't necessary and by default is empty array, so you can set queryItems by yourself in url parameter. But better practice is pass queryItems.
     3. If identicalLinksPolicy not specified, used global by default. This provides some flexibility.
     4. Inspect SwitchTabSegueCompletionHandler for more info about switch status processing.
     5. Inspect PushSegueCompletionHandler for more info about segue status processing.
     
     # Example #
     ```
     // Shortest
     Navigator.switchTabAndPush(to: 0, pushTo: URL(string: "/testScreen")!)
     // Full
     Navigator.switchTabAndPush(to: 0, tabBarController: tabBarController, switchCompletion: { switchState in
         // some code
     }, pushTo: url, queryItems: queryItems, animated: false, policy: .Open) { segueState in
         // some code
     }
     ```
     */
    public class func switchTabAndPush(to tabIndex: Int, tabBarController: UITabBarController? = nil, switchCompletion: SwitchTabSegueCompletionHandler? = nil, pushTo url: URL, queryItems: [URLQueryItem] = [], animated: Bool = true, policy: IdenticalLinksPolicy? = nil, segueCompletion: PushSegueCompletionHandler? = nil) {
        Navigator.shared.switchTabAndPush(to: tabIndex, tabBarController: tabBarController, switchCompletion: switchCompletion, pushTo: url, queryItems: queryItems, animated: animated, identicalLinksPolicy: policy, segueCompletion: segueCompletion)
    }
    
    
    // MARK: - Switch tabs and pop segue
    /**
     Combination of: Switch tab in tab bar controller with completion callback and then pop segue by url with completion callback.
     
     - parameter tabIndex: Specified tab bar index.
     - parameter tabBarController: Specified tab bar controller.
     - parameter completion: Switch completion block that allows you to implement status(SwitchState) processing.
     - parameter url: Url to search for view controller constructor.
     - parameter queryItems: Query part for url.
     - parameter forceUpdate: By default is false.
     - parameter animated: Indicates whether an animation is needed during the transition.
     - parameter completion: Push segue completion block that allows you to implement status(PushState) processing.
     - warning: There is no assertionFailure, use debug mode because states are printed to console as formatted text and it's much easier to debug and remove issues rather than use assert.
     
     # Notes: #
     1. If tabBarController is nil, by default used window root tab bar controller if can.
     2. Argument queryItems isn't necessary and by default is empty array, so you can set queryItems by yourself in url parameter. But better practice is pass queryItems.
     3. Inspect SwitchTabSegueCompletionHandler for more info about switch status processing.
     4. Inspect PushSegueCompletionHandler for more info about segue status processing.
     5. Argument forceUpdate may be useful if you can't set new query items for update, but you really want call update.
     
     # Example #
     ```
     // Shortest
     Navigator.switchTabAndPopTo(to: 0, popTo: URL(string: "/testScreen")!)
     // Full
     Navigator.switchTabAndPopTo(to: 0, tabBarController: tabBarController, switchCompletion: { switchState in
         // some code
     }, popTo: url, queryItems: queryItems, forceUpdate: false, animated: false) { segueState in
         // some code
     }
     ```
     */
    public class func switchTabAndPopTo(to tabIndex: Int, tabBarController: UITabBarController? = nil, switchCompletion: SwitchTabSegueCompletionHandler? = nil, popTo url: URL, queryItems: [URLQueryItem] = [], forceUpdate: Bool = false, animated: Bool = true, segueCompletion: PopSegueCompletionHandler? = nil) {
        Navigator.shared.switchTabAndPopTo(to: tabIndex, tabBarController: tabBarController, switchCompletion: switchCompletion, popTo: url, queryItems: queryItems, forceUpdate: forceUpdate, animated: animated, segueCompletion: segueCompletion)
    }
    
    
    /**
     Combination of: Switch tab in tab bar controller with completion callback and then pop one controller segue with completion callback.
     
     - parameter tabIndex: Specified tab bar index.
     - parameter tabBarController: Specified tab bar controller.
     - parameter completion: Switch completion block that allows you to implement status(SwitchState) processing.
     - parameter url: Url to search for view controller constructor.
     - parameter queryItems: Query part for url.
     - parameter forceUpdate: By default is false.
     - parameter animated: Indicates whether an animation is needed during the transition.
     - parameter completion: Push segue completion block that allows you to implement status(PushState) processing.
     - warning: There is no assertionFailure, use debug mode because states are printed to console as formatted text and it's much easier to debug and remove issues rather than use assert.
     
     # Notes: #
     1. If tabBarController is nil, by default used window root tab bar controller if can.
     2. Argument queryItems isn't necessary and by default is empty array, so you can set queryItems by yourself in url parameter. But better practice is pass queryItems.
     3. Inspect SwitchTabSegueCompletionHandler for more info about switch status processing.
     4. Inspect PushSegueCompletionHandler for more info about segue status processing.
     5. Argument forceUpdate may be useful if you can't set new query items for update, but you really want call update.
     
     # Example #
     ```
     // Shortest
     Navigator.switchTabAndPop(to: 0)
     // Full
     Navigator.switchTabAndPop(to: 0, tabBarController: tabBarController, switchCompletion: { switchState in
         // some code
     }, queryItems: queryItems, forceUpdate: false, animated: false) { segueState in
         // some code
     }
     ```
     */
    public class func switchTabAndPop(to tabIndex: Int, tabBarController: UITabBarController? = nil, switchCompletion: SwitchTabSegueCompletionHandler? = nil, queryItems: [URLQueryItem] = [], forceUpdate: Bool = false, animated: Bool = true, segueCompletion: PopSegueCompletionHandler? = nil) {
        Navigator.shared.switchTabAndPopTo(to: tabIndex, tabBarController: tabBarController, switchCompletion: switchCompletion, popTo: Navigator.popURL, queryItems: queryItems, forceUpdate: forceUpdate, animated: animated, segueCompletion: segueCompletion)
    }
    
    
    /**
     Combination of: Switch tab in tab bar controller with completion callback and then pop to root controller segue with completion callback.
     
     - parameter tabIndex: Specified tab bar index.
     - parameter tabBarController: Specified tab bar controller.
     - parameter completion: Switch completion block that allows you to implement status(SwitchState) processing.
     - parameter url: Url to search for view controller constructor.
     - parameter queryItems: Query part for url.
     - parameter forceUpdate: By default is false.
     - parameter animated: Indicates whether an animation is needed during the transition.
     - parameter completion: Push segue completion block that allows you to implement status(PushState) processing.
     - warning: There is no assertionFailure, use debug mode because states are printed to console as formatted text and it's much easier to debug and remove issues rather than use assert.
     
     # Notes: #
     1. If tabBarController is nil, by default used window root tab bar controller if can.
     2. Argument queryItems isn't necessary and by default is empty array, so you can set queryItems by yourself in url parameter. But better practice is pass queryItems.
     3. Inspect SwitchTabSegueCompletionHandler for more info about switch status processing.
     4. Inspect PushSegueCompletionHandler for more info about segue status processing.
     5. Argument forceUpdate may be useful if you can't set new query items for update, but you really want call update.
     
     # Example #
     ```
     // Shortest
     Navigator.switchTabAndPopToRoot(to: 0)
     // Full
     Navigator.switchTabAndPopToRoot(to: 0, tabBarController: tabBarController, switchCompletion: { switchState in
         // some code
     }, queryItems: queryItems, forceUpdate: false, animated: false) { segueState in
         // some code
     }
     ```
     */
    public class func switchTabAndPopToRoot(to tabIndex: Int, tabBarController: UITabBarController? = nil, switchCompletion: SwitchTabSegueCompletionHandler? = nil, queryItems: [URLQueryItem] = [], forceUpdate: Bool = false, animated: Bool = true, segueCompletion: PopSegueCompletionHandler? = nil) {
        Navigator.shared.switchTabAndPopTo(to: tabIndex, tabBarController: tabBarController, switchCompletion: switchCompletion, popTo: Navigator.rootURL, queryItems: queryItems, forceUpdate: forceUpdate, animated: animated, segueCompletion: segueCompletion)
    }
}
