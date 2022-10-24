//
//  Module: Navigator
//  Created by: MrTrent on 18.10.2022
//  Copyright (c) 2022 Zordz Union
//  


import Foundation

/// Base UINavigationController with integration to Navigator environment(auto register and release).
public class ZNNavigationController: UINavigationController {
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        register()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        register()
    }
    
    override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
        register()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        register()
    }
    
    deinit {
        release()
    }
}
