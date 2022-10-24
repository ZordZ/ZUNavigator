//
//  Module: Navigator
//  Created by: MrTrent on 23.10.2022
//  Copyright (c) 2022 Zordz Union
//  


import Foundation

// MARK: Registring url patterns and etc.
extension Navigator {
    
    // MARK: - Register url patterns and constructors
    /**
     Register(chaine) url pattern and specified view controller constructor for push segue.
     
     - parameter url: Url pattern represented as string.
     - parameter constructor: Block implements creation and transfer for view controller.
     - warning: You can specify parameters in url pattern path part. But only as Int values.
     
     # Notes: #
     1. About constructor look at ViewControllerConstructor definition.
     2. Argument url is represented as url string pattern.
     3. Start url pattern from "/".
     4. Simple example: "/testScreen"
     5. Example with parameter in url path: "/profile/%d".
     
     # Example #
     ```
     Navigator.register(url: "/testScreen") { url, callback in
         let viewController = TestViewController()
         viewController.setData(by: url)
         // Simple usage
         callback(viewController)
         // or if some data loading
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
             callback(viewController)
         }
     }
     ```
     */
    public class func register(url: String, constructor: @escaping ViewControllerConstructor) {
        Navigator.shared.register(urlPattern: url, constructor: constructor)
    }
    
    
    /**
     Register array of urls and specified view controller constructor for push segues.
     
     - parameter url: Array of url patterns represented as string.
     - parameter constructor: Block implements creation and transfer for view controller.
     - warning: You can specify parameters in url pattern path part. But only as Int values.
     
     # Notes: #
     1. About constructor look at ViewControllerConstructor definition.
     2. Argument url is represented as url string pattern.
     3. Start url pattern from "/".
     4. Simple example: "/testScreen"
     5. Example with parameter in url path: "/profile/%d".
     
     # Example #
     ```
     Navigator.register(url: "/testScreen") { url, callback in
         let viewController = TestViewController()
         viewController.setData(by: url)
         // Simple usage
         callback(viewController)
         // or if some data loading
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
             callback(viewController)
         }
     }
     ```
     */
    public class func register(urls: [String], constructor: @escaping ViewControllerConstructor) {
        Navigator.shared.register(urlPatterns: urls, constructor: constructor)
    }
    
    
    // MARK: - Register/release navigation or tab bar controllers
    /**
     Registers UITabBarController or UINavigationController in Navigator environment.
     
     - parameter controller: UITabBarController or UINavigationController controller.
     - warning: If you'll pass as controller any controller not inherited from UITabBarController or UINavigationController, it'll be just skipped.
     - warning: Don't forget call release method on deinit of controller for example. You won't get memory leaks, but will stay some garbage if you don't.
     - warning: Use ZNNavigationController and ZNTabBarController for simple experience. Or look implemetation for better understanding.
     
     # Notes: #
     1. You can call this in init method of your custom controller UITabBarController or UINavigationController.
     2. You can also use ZNNavigationController and ZNTabBarController. They can do automatically register and release ourselves.
     
     # Example #
     ```
     Navigator.register(controller)
     ```
     */
    public class func register(_ controller: UIViewController) {
        Navigator.shared.register(controller)
    }
    
    
    /**
     Releases UITabBarController or UINavigationController from Navigator environment.
     
     - parameter controller: UITabBarController or UINavigationController controller.
     - warning: If you'll pass as controller any controller not inherited from UITabBarController or UINavigationController, it'll be just skipped.
     - warning: If controller isn't registered, no sense to call release.
     - warning: Use ZNNavigationController and ZNTabBarController for simple experience. Or look implemetation for better understanding.
     
     # Notes: #
     1. You can call this in deinit method of your custom controller UITabBarController or UINavigationController.
     2. You can also use ZNNavigationController and ZNTabBarController. They can do automatically register and release ourselves.
     
     # Example #
     ```
     Navigator.register(controller)
     ```
     */
    public class func release(_ controller: UIViewController) {
        Navigator.shared.release(controller)
    }
}
