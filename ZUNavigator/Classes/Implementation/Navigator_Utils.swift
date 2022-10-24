//
//  Module: Navigator
//  Created by: MrTrent on 05.10.2022
//  Copyright (c) 2022 Zordz Union
//  


import Foundation

// protocol for printing states to console
internal protocol StatePrintable_Protocol {
    var description: String {get}
    func print()
}

// MARK: - Utils & Logs
extension Navigator {
    
    /// Prints state if debug enabled.
    internal func printState(_ state: StatePrintable_Protocol, force: Bool = false) {
        if debugEnabled || force { state.print() }
    }
    
    /// Used to print formatted logs.
    internal func printLogs(_ text: String) {
        Swift.print("__Navigator__:\n\(text)\n__Navigator__")
    }
    
    /// Prints logs for update states
    internal func printUpdateInfo(url: URL, queryItems: [URLQueryItem], states: [UpdateState]) {
        // skip if no need
        if !debugEnabled { return }
        // making url
        var url = url
        if queryItems.count > 0 {
            url.append(queryItems: queryItems)
        }
        
        // generating counter
        var counter: (Int, Int, Int, Int, Int) = (noViewController: 0, mismatchURL: 0, noNeed: 0, issue: 0, done: 0)
        states.forEach { state in
            switch state {
            case .NoViewController(_):
                counter.0 = counter.0 + 1
                break
            case .MismatchURL(_):
                counter.1 = counter.1 + 1
                break
            case .NoNeed(_):
                counter.2 = counter.2 + 1
                break
            case .Issue(_):
                counter.3 = counter.3 + 1
                break
            case .Done(_):
                counter.4 = counter.4 + 1
                break
            }
        }
        // not printing MismatchURL(no need log skiped controllers) and NoViewController.
        printLogs("\tUpdates. \n\tDone: \(counter.4). Issues: \(counter.3). No need: \(counter.2).")
    }
    
    /// convert UIUINavigationController's links map to string
    internal func linksMapAsString(_ linksMap: [(URL, UIViewController)], prefixString: String = "") -> String {
        let linksMapPrepared: [String] = linksMap.map({"\(prefixString) \($0.0) - \($0.1.className)"})
        let linksMapStr: String = linksMapPrepared.joined(separator: "\n")
        return linksMapStr
    }
    
    /// prints UIUINavigationController's links map as formatted info to console
    internal func printLinksMap(_ linksMap: [(URL, UIViewController)]) {
        if !debugEnabled { return }
        
        // generating message
        let message = linksMapAsString(linksMap, prefixString: "\t")
        
        printLogs(message)
    }
    
    /// prints UITabBarController's links map as formatted info to console
    internal func printLinksMap(_ linksMap: [[(URL, UIViewController)]]) {
        if !debugEnabled { return }
        
        var messages: [String] = []
        for i in 0..<linksMap.count {
            let message = "\tTab index: \(i)\n\(linksMapAsString(linksMap[i], prefixString: "\t\t"))"
            messages.append(message)
        }
        let finalMessage: String = messages.joined(separator: "\n")
        
        printLogs(finalMessage)
    }
    
    /// If can will return index of url from end of stack. Search based on path part excluding query items.
    internal func lastIndex(of url: URL, for navigationController: UINavigationController) -> Int? {
        return navigationController.viewControllers.lastIndex(where: {$0._url.path == url.path})
    }
    
    /// Return tabbar controller if navigation controller is placed in tabbar controller
    internal func tabBarController(for navigationController: UINavigationController) -> UITabBarController? {
        return navigationController.parent as? UITabBarController
    }

    /// check tab bar controller tabs and tab index as assert
    internal func assertTabBar(count: Int, tabIndex: Int?) {
        if let tabIndex = tabIndex {
            assert(tabIndex >= 0, "Tab index must be >= 0")
            assert(tabIndex < count, "Tab index out of bounds. Tabs count = \(count)")
        }
        assert(count > 0, "Tab bar controller have no tabs")
    }
}
