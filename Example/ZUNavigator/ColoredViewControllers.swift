//
//  Module: Navigator_Example
//  Created by: MrTrent on 13.10.2022
//  Copyright (c) 2022 Zordz Union
//  


import Foundation
import ZUNavigator


// MARK: - Red
class RedViewController: BaseViewController, ZNTargetViewController_Protocol {
    static let urlPattern: String = "/red"
    class func register() {
        Navigator.register(url: urlPattern) { url, callback in
            let viewController = RedViewController()
            viewController.setDate(url.queryItemValue("date"))
            let title = url.path.dropFirstAndUppercasedFirst()
            viewController.setTitle(title)
            // Simulating data loading
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                callback(viewController)
            }
        }
    }
    
    // MARK: ZNTargetViewController_Protocol for Navigator
    func update(via url: URL) {
        setDate(url.queryItemValue("date"))
    }
}


// MARK: - Blue
class BlueViewController: BaseViewController, ZNTargetViewController_Protocol {
    static let urlPattern: String = "/blue"
    class func register() {
        Navigator.register(url: urlPattern) { url, callback in
            let viewController = BlueViewController()
            viewController.setDate(url.queryItemValue("date"))
            let title = url.path.dropFirstAndUppercasedFirst()
            viewController.setTitle(title)
            callback(viewController)
        }
    }
    
    // MARK: ZNTargetViewController_Protocol for Navigator
    func update(via url: URL) {
        setDate(url.queryItemValue("date"))
    }
}


// MARK: - Green
class GreenViewController: BaseViewController, ZNTargetViewController_Protocol {
    static let urlPattern: String = "/green"
    class func register() {
        Navigator.register(url: urlPattern) { url, callback in
            let viewController = GreenViewController()
            viewController.setDate(url.queryItemValue("date"))
            let title = url.path.dropFirstAndUppercasedFirst()
            viewController.setTitle(title)
            // Simulating data loading
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                callback(viewController)
            }
        }
    }
    
    // MARK: ZNTargetViewController_Protocol for Navigator
    func update(via url: URL) {
        setDate(url.queryItemValue("date"))
    }
}


// MARK: - Yellow
class YellowViewController: BaseViewController, ZNTargetViewController_Protocol {
    static let urlPattern: String = "/yellow"
    class func register() {
        Navigator.register(url: urlPattern) { url, callback in
            let viewController = YellowViewController()
            viewController.setDate(url.queryItemValue("date"))
            let title = url.path.dropFirstAndUppercasedFirst()
            viewController.setTitle(title)
            callback(viewController)
        }
    }
    
    // MARK: ZNTargetViewController_Protocol for Navigator
    func update(via url: URL) {
        setDate(url.queryItemValue("date"))
    }
}
