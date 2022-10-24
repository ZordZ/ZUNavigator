//
//  Module: Navigator
//  Created by: MrTrent on 22.10.2022
//  Copyright (c) 2022 Zordz Union
//  


import Foundation

// MARK: Update data in view controllers via url
extension Navigator {
    
    // MARK: - Update navigation controller
    /**
     Update data via url in navigation controller.
     
     - parameter url: Url to search in view controllers for matching.
     - parameter queryItems: Query part for url.
     - parameter navigationController: Specified navigation controller.
     - parameter updatePolicy: Custom update policy.
     - parameter forceUpdate: By default is false.
     - warning: If navigationController is nil and top navigation controller is nil too, it causes assertionFailure with message to indicate about problem or misunderstanding.
     - warning: If you set policy to .EveryMatchAndNearBy, it will try get navigation controller parent as UITabBarController and call update to it. Or it will down policy to .EveryMatch. So if you setted global policy .EveryMatchAndNearBy you will update every tab in parent tab bar controller as well.
     
     # Notes: #
     1. Argument queryItems isn't necessary and by default is empty array, so you can set queryItems by yourself in url parameter. But better practice is pass queryItems.
     2. If navigationController is nil, by default used top navigation controller if can.
     3. Argument updatePolicy allows you to temporarily ignore global update policy. May be useful in some cases.
     4. Argument forceUpdate may be useful if you can't set new query items for update, but you really want call update.
     5. Update calling is based on difference between old query params in view controllers url and new query params.
     
     # Example #
     ```
     Navigator.shared.update(by: url)
     Navigator.shared.update(by: url, queryItems: queryItems)
     Navigator.shared.update(by: url, queryItems: queryItems, navigationController: navigationController)
     Navigator.shared.update(by: url, queryItems: queryItems, navigationController: navigationController, updatePolicy: .FirstMatch)
     Navigator.shared.update(by: url, queryItems: queryItems, navigationController: navigationController, updatePolicy: .FirstMatch, forceUpdate: true)
     ```
     */
    public class func update(by url: URL, queryItems: [URLQueryItem] = [], navigationController: UINavigationController? = nil, policy: UpdatePolicy? = nil, forceUpdate: Bool = false) {
        Navigator.shared.update(by: url, queryItems: queryItems, navigationController: navigationController, updatePolicy: policy, forceUpdate: forceUpdate)
    }
    
    
    // MARK: - Update tab bar controller
    /**
     Update data via url in tab bar controller for specified tab index.
     
     - parameter url: Url to search in view controllers for matching.
     - parameter queryItems: Query part for url.
     - parameter tabBarController: Specified tab bar controller.
     - parameter tabIndex: Specified tab bar index.
     - parameter updatePolicy: Custom update policy.
     - parameter forceUpdate: By default is false.
     - warning: If tabBarController is nil and window root tab bar controller is nil, it causes assertionFailure with message to indicate about problem or misunderstanding.
     - warning: updatePolicy can't be .EveryMatchAndNearBy and will be lowered. Because policy conflicts with tab specifing. If you need .EveryMatchAndNearBy - use method wtihout tab specifing. It's maked to allow you update only in one tab even if global updatePolicy is .EveryMatchAndNearBy.
     
     # Notes: #
     1. Argument queryItems isn't necessary and by default is empty array, so you can set queryItems by yourself in url parameter. But better practice is pass queryItems.
     2. If tabBarController is nil, by default used window root tab bar controller if can.
     3. Argument updatePolicy allows you to temporarily ignore global update policy. May be useful in some cases.
     4. Argument forceUpdate may be useful if you can't set new query items for update, but you really want call update.
     5. Update calling is based on difference between old query params in view controllers url and new query params.
     
     # Example #
     ```
     Navigator.shared.update(by: url)
     Navigator.shared.update(by: url, queryItems: queryItems)
     Navigator.shared.update(by: url, queryItems: queryItems, tabBarController: tabBarController)
     Navigator.shared.update(by: url, queryItems: queryItems, tabBarController: tabBarController, tabIndex: 0)
     Navigator.shared.update(by: url, queryItems: queryItems, tabBarController: tabBarController, tabIndex: 0, updatePolicy: .FirstMatch)
     Navigator.shared.update(by: url, queryItems: queryItems, tabBarController: tabBarController, tabIndex: 0, updatePolicy: .FirstMatch, forceUpdate: true)
     ```
     */
    public class func updateTabBar(by url: URL, queryItems: [URLQueryItem] = [], tabBarController: UITabBarController? = nil, tabIndex: Int, policy: UpdatePolicy? = nil, forceUpdate: Bool = false) {
        Navigator.shared.updateTabBar(by: url, queryItems: queryItems, tabBarController: tabBarController, tabIndex: tabIndex, updatePolicy: policy, forceUpdate: forceUpdate)
    }
    
    
    /**
     Update data via url in tab bar controller at every tab and every matching view controller.
     
     - parameter url: Url to search in view controllers for matching.
     - parameter queryItems: Query part for url.
     - parameter tabBarController: Specified tab bar controller.
     - parameter forceUpdate: By default is false.
     - warning: This method try call update in tab bar controller at every tab and every matching view controller. Update policy is always .EveryMatchAndNearBy.
     - warning: If tabBarController is nil and window root tab bar controller is nil, it causes assertionFailure with message to indicate about problem or misunderstanding.
     
     # Notes: #
     1. Argument queryItems isn't necessary and by default is empty array, so you can set queryItems by yourself in url parameter. But better practice is pass queryItems.
     2. If tabBarController is nil, by default used window root tab bar controller if can.
     3. Argument forceUpdate may be useful if you can't set new query items for update, but you really want call update.
     4. Update calling is based on difference between old query params in view controllers url and new query params.
     
     # Example #
     ```
     Navigator.shared.update(by: url)
     Navigator.shared.update(by: url, queryItems: queryItems)
     Navigator.shared.update(by: url, queryItems: queryItems, tabBarController: tabBarController)
     Navigator.shared.update(by: url, queryItems: queryItems, tabBarController: tabBarController, forceUpdate: forceUpdate)
     ```
     */
    public class func updateTabBar(by url: URL, queryItems: [URLQueryItem] = [], tabBarController: UITabBarController? = nil, forceUpdate: Bool = false) {
        Navigator.shared.updateTabBar(by: url, queryItems: queryItems, tabBarController: tabBarController, updatePolicy: .EveryMatchAndNearBy, forceUpdate: forceUpdate)
    }
    
    
    // MARK: - Update everywhere
    /**
     Call update() everywhere. Based ONLY on registered UINavigationControllers, UITabBarControllers.
     
     - parameter url: Url to search in view controllers for matching.
     - parameter queryItems: Query part for url.
     - parameter forceUpdate: By default is false.
     - warning: This method use ONLY registered UINavigationControllers, UITabBarControllers.
     
     # Notes: #
     1. Argument queryItems isn't necessary and by default is empty array, so you can set queryItems by yourself in url parameter. But better practice is pass queryItems.
     2. Argument forceUpdate may be useful if you can't set new query items for update, but you really want call update.
     3. Update calling is based on difference between old query params in view controllers url and new query params.
     
     # Example #
     ```
     Navigator.updateEveryWhere(by: url)
     Navigator.updateEveryWhere(by: url, queryItems: queryItems)
     Navigator.updateEveryWhere(by: url, forceUpdate: true)
     Navigator.updateEveryWhere(by: url, queryItems: queryItems, forceUpdate: false)
     ```
     */
    public class func updateEveryWhere(by url: URL, queryItems: [URLQueryItem] = [], forceUpdate: Bool = false) {
        Navigator.shared.updateEveryWhere(by: url, queryItems: queryItems, forceUpdate: forceUpdate)
    }
}
