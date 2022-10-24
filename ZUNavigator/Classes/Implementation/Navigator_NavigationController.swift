//
//  Module: Navigator
//  Created by: MrTrent on 05.10.2022
//  Copyright (c) 2022 Zordz Union
//  


import Foundation
import ZUCore

// MARK: - Navigation controllers stuff
extension Navigator {
    
    /// Returns current on screen navigation controller - top navigation controller(powered by ZUCore)
    internal var navigationController: UINavigationController? {
        return UIApplication.shared.topNavigationController
    }
    
    
    // MARK: - Typealiases
    /// Block allows you to process push segue state if needed.
    public typealias PushSegueCompletionHandler = (PushState) -> Void
    
    /// Block allows you to process pop segue state if needed.
    public typealias PopSegueCompletionHandler = (PopState) -> Void
    
    
    // MARK: - Identical Links Policy - Applies on push segues
    /// Stack matching behavior policy for push segues. Other words - behavior for same links in linksMap for navigation controller or tabbar.
    public enum IdenticalLinksPolicy: Equatable, CaseIterable {
        /// Push view controller. Anyway even if link is in the stack.
        case Open
        /// If view controller with same link already in stack, pop to it.
        case PopTo
        /// If view controller with same link already in stack, pop to it. Or will try switch tab bar and pop to matching link, if navigation controller child of tab bar controller.
        case PopToOrOpenTab
        
        // Equatable implementation
        public static func ==(lhs: IdenticalLinksPolicy, rhs: IdenticalLinksPolicy) -> Bool {
            switch (lhs, rhs) {
            case (.Open, .Open):
                return true
            case (.PopTo, .PopTo):
                return true
            case (.PopToOrOpenTab, .PopToOrOpenTab):
                return true
            default:
                return false
            }
        }
    }
    
    
    // MARK: - State enums
    /// Used to track and debug push segue state
    public enum PushState: Equatable, StatePrintable_Protocol {
        /// Segue not allowed at this moment.
        case Blocked(URL)
        /// Segue not allowed by setted policy and no need pop to view controller with same url - already here.
        case BlockedByPolicyAndStayed(URL)
        /// Segue not allowed by setted policy and popped to view controller with same url.
        case BlockedByPolicyAndPopped(URL)
        /// Segue not allowed by setted policy and opened tab contained view controller with same url and poped if was needed.
        case BlockedByPolicyAndOpenedInTab(URL)
        /// Constructor not found for URL.
        case NotFoundConstructor(URL)
        /// Navigation controller not found.
        case NotFoundNavigationController(URL)
        /// Waiting constuctor callback.
        case WaitingConstuctor(URL)
        /// Segue rejected by view controller constructor.
        case RejectedByConstructor(URL)
        /// Segue completed successfully.
        case Success(URL)
        
        /// Debug description string
        public var description: String {
            switch self {
            case .Blocked(_):
                return "\tPUSH segue - NOT ALLOWED: \n\ttWait until the end of the previous segue."
            case .BlockedByPolicyAndStayed(_):
                return "\tPUSH segue - NOT ALLOWED: \n\tby setted policy and target url view controller is already on screen."
            case .BlockedByPolicyAndPopped(_):
                return "\tPUSH segue - NOT ALLOWED: \n\tby setted policy and popped to view controller with same url. \n\tCheck identicalLinksPolicy for more info."
            case .BlockedByPolicyAndOpenedInTab(_):
                return "\tPUSH segue - NOT ALLOWED: \n\tby setted policy and opened nearby tab contained view controller with same url and poped if was needed. \n\tCheck identicalLinksPolicy for more info."
            case .NotFoundConstructor(_):
                return "\tPUSH segue - NOT ALLOWED: \n\tView controller constructor for url not found(not registred). \n\tFirst of all register view controller constructor via Navigator.register(...)"
            case .NotFoundNavigationController(_):
                return "\tPUSH segue - NOT ALLOWED: \n\tNavigation controller not found."
            case .WaitingConstuctor(_):
                return "\tPUSH segue - NOT ALLOWED: \n\tWaiting constructor callback."
            case .RejectedByConstructor(_):
                return "\tPUSH segue - NOT ALLOWED: \n\tSegue rejected by view controller constructor."
            case .Success(_):
                return "\tPUSH segue - COMPLETED SUCCESSFULLY."
            }
        }
        
        /// Returns stored in state URL value
        public var associatedValue: URL {
            switch self {
            case .Blocked(let url),
                    .BlockedByPolicyAndStayed(let url),
                    .BlockedByPolicyAndPopped(let url),
                    .BlockedByPolicyAndOpenedInTab(let url),
                    .NotFoundConstructor(let url),
                    .NotFoundNavigationController(let url),
                    .WaitingConstuctor(let url),
                    .RejectedByConstructor(let url),
                    .Success(let url):
                return url
            }
        }
        
        /// Prints debug info in console
        internal func print() {
            if AppUtils.isDebug {
                Navigator.shared.printLogs("\(description)\n\tURL: \(associatedValue)")
            }
        }
        
        // Equatable implementation
        public static func ==(lhs: PushState, rhs: PushState) -> Bool {
            switch (lhs, rhs) {
            case (let .Blocked(lhsURL), let .Blocked(rhsURL)):
                return lhsURL == rhsURL
            case (let .BlockedByPolicyAndStayed(lhsURL), let .BlockedByPolicyAndStayed(rhsURL)):
                return lhsURL == rhsURL
            case (let .BlockedByPolicyAndPopped(lhsURL), let .BlockedByPolicyAndPopped(rhsURL)):
                return lhsURL == rhsURL
            case (let .BlockedByPolicyAndOpenedInTab(lhsURL), let .BlockedByPolicyAndOpenedInTab(rhsURL)):
                return lhsURL == rhsURL
            case (let .NotFoundConstructor(lhsURL), let .NotFoundConstructor(rhsURL)):
                return lhsURL == rhsURL
            case (let .NotFoundNavigationController(lhsURL), let .NotFoundNavigationController(rhsURL)):
                return lhsURL == rhsURL
            case (let .WaitingConstuctor(lhsURL), let .WaitingConstuctor(rhsURL)):
                return lhsURL == rhsURL
            case (let .RejectedByConstructor(lhsURL), let .RejectedByConstructor(rhsURL)):
                return lhsURL == rhsURL
            case (let .Success(lhsURL), let .Success(rhsURL)):
                return lhsURL == rhsURL
            default:
                return false
            }
        }
    }
    
    
    /// Used to track and debug pop segue state
    public enum PopState: Equatable, StatePrintable_Protocol {
        /// Segue not allowed at this moment. URL in state will be "/", if not found on pop without specified url.
        case Blocked(URL)
        /// Navigations controller have only one view controller. URL in state will be "/", if not found on pop without specified url.
        case isRootViewController(URL)
        /// Pop target url not found. URL in state will be "/", if not found on pop without specified url.
        case NotFoundDestinationURL(URL)
        /// Navigation controller not found. URL in state will be "/", if not found on pop without specified url.
        case NotFoundNavigationController(URL)
        /// Navigation controller have no view controllers. URL in state will be "/", if not found on pop without specified url.
        case NoViewControllers(URL)
        /// Already here
        case AlreadyHere(URL)
        /// Pop successful
        case Success(URL)
        /// Pop successful with called update
        case SuccessWithUpdate(URL)
        /// Pop successful, but update can't be called
        case SuccessWithoutUpdate(URL)
        /// Pop successful, but update can't be called
        case SuccessNoNeedUpdate(URL)
        
        /// Debug description string
        public var description: String {
            switch self {
            case .Blocked(_):
                return "\tPOP segue - NOT ALLOWED: \n\tWait until the end of the previous segue."
            case .isRootViewController(_):
                return "\tPOP segue - NOT ALLOWED: \n\tDetected only one view controller in view controllers stack."
            case .NotFoundDestinationURL(_):
                return "\tPOP segue - NOT ALLOWED: \n\tTarget controller with specified URL not found in view controllers stack."
            case .NotFoundNavigationController(_):
                return "\tPOP segue - NOT ALLOWED: \n\tNavigation controller not found."
            case .NoViewControllers(_):
                return "\tPOP segue - NOT ALLOWED: \n\tView controllers stack of navigation controller is empty."
            case .AlreadyHere(_):
                return "\tPOP segue - NOT ALLOWED: \n\tTarget view controller is already on screen."
            case .Success(_):
                return "\tPOP segue - COMPLETED SUCCESSFULLY."
            case .SuccessWithUpdate(_):
                return "\tPOP segue - COMPLETED SUCCESSFULLY. \n\tupdate() - SUCCESSFULLY called in targer view controller."
            case .SuccessWithoutUpdate(_):
                return "\tPOP segue - COMPLETED SUCCESSFULLY. \n\tupdate() - NOT CALLED in targer view controller. \n\tCheck view controller conformance to ZNTargetViewController_Protocol."
            case .SuccessNoNeedUpdate(_):
                return "\tPOP segue - COMPLETED SUCCESSFULLY. \n\tupdate() - NOT CALLED in targer view controller, same query params. \n\tIf you still want call update(), you can use force parameter."
            }
        }
        
        /// Returns stored in state URL value
        public var associatedValue: URL {
            switch self {
            case .Blocked(let url),
                    .isRootViewController(let url),
                    .NotFoundDestinationURL(let url),
                    .NotFoundNavigationController(let url),
                    .NoViewControllers(let url),
                    .AlreadyHere(let url),
                    .Success(let url),
                    .SuccessWithUpdate(let url),
                    .SuccessWithoutUpdate(let url),
                    .SuccessNoNeedUpdate(let url):
                return url
            }
        }
        
        /// Prints debug info in console
        internal func print() {
            if AppUtils.isDebug {
                Navigator.shared.printLogs("\(description)\n\tURL: \(associatedValue)")
            }
        }
        
        // Equatable implementation
        public static func ==(lhs: PopState, rhs: PopState) -> Bool {
            switch (lhs, rhs) {
            case (let .Blocked(lhsURL), let .Blocked(rhsURL)):
                return lhsURL == rhsURL
            case (let .isRootViewController(lhsURL), let .isRootViewController(rhsURL)):
                return lhsURL == rhsURL
            case (let .NotFoundDestinationURL(lhsURL), let .NotFoundDestinationURL(rhsURL)):
                return lhsURL == rhsURL
            case (let .NotFoundNavigationController(lhsURL), let .NotFoundNavigationController(rhsURL)):
                return lhsURL == rhsURL
            case (let .NoViewControllers(lhsURL), let .NoViewControllers(rhsURL)):
                return lhsURL == rhsURL
            case (let .AlreadyHere(lhsURL), let .AlreadyHere(rhsURL)):
                return lhsURL == rhsURL
            case (let .Success(lhsURL), let .Success(rhsURL)):
                return lhsURL == rhsURL
            case (let .SuccessWithUpdate(lhsURL), let .SuccessWithUpdate(rhsURL)):
                return lhsURL == rhsURL
            case (let .SuccessWithoutUpdate(lhsURL), let .SuccessWithoutUpdate(rhsURL)):
                return lhsURL == rhsURL
            case (let .SuccessNoNeedUpdate(lhsURL), let .SuccessNoNeedUpdate(rhsURL)):
                return lhsURL == rhsURL
            default:
                return false
            }
        }
    }
    
    
    
    // MARK: - Push segues
    /// Make push segue by url with segueCompletionHandler callback. You can specify navigation controller or segue will be applied to top navigation controller. You can set query items separated from url by queryItems parameter.
    internal func push(by url: URL, queryItems: [URLQueryItem] = [], navigationController: UINavigationController? = nil, animated: Bool = true, identicalLinksPolicy: IdenticalLinksPolicy?, completion: PushSegueCompletionHandler? = nil) {
        // # - generating url for debug and usage
        // making url mutable
        var url = url
        if queryItems.count > 0 {
            url.append(queryItems: queryItems)
        }
        
        // custom policy used to open from tab bar - when we want to ignore setted policy for some reasons
        let identicalLinksPolicy = identicalLinksPolicy ?? self.identicalLinksPolicy
        
        // used to print debug info, unlock segues on error and return to caller. Starting status is Blocked.
        var state: PushState = .Blocked(url)
        
        // defer used to control interruptions
        defer {
            // skip for waiting status
            switch state {
            case .WaitingConstuctor(_):
                // skip
                break
            default:
                // print segue state
                printState(state)
                // unlock segues if we had some wrong state and it's state isn't Blocked
                if state != .Blocked(url) {
                    isSegueing = false
                }
                // call segueCompletionHandler if we have
                completion?(state)
                break
            }
        }
        
        // segue not allowed at this moment
        if isSegueing {
            return
        }
        
        // block other segues until this one ended
        isSegueing = true
        
        // try get top navigation controller
        guard let navigationController = navigationController ?? self.navigationController else {
            state = .NotFoundNavigationController(url)
            return
        }
        
        // apply policy
        switch identicalLinksPolicy {
        case .Open:
            break
        case .PopTo, .PopToOrOpenTab:
            // pop - try pop.
            if let index = lastIndex(of: url, for: navigationController) {
                popTo(url: url, queryItems: queryItems, navigationController: navigationController, forceUpdate: false, animated: animated, completion: nil, ignoreBlocked: true, allowDefer: false)
                if index == navigationController.viewControllers.count - 1 {
                    // stayed here
                    state = .BlockedByPolicyAndStayed(url)
                } else {
                    // was popped
                    state = .BlockedByPolicyAndPopped(url)
                }
                return
            }
            // If pop failed and identicalLinksPolicy setted PopToOrOpenTab - Navigator will try to check nearby tabs if navigation controller placed in tab bar controller.
            if identicalLinksPolicy == .PopToOrOpenTab {
                // open in tab
                if tryOpenInNearByTab(url: url, navigationController: navigationController, queryItems: queryItems, forceUpdate: false, animated: animated, segueCompletion: nil, ignoreBlocked: true, allowDefer: false) {
                    state = .BlockedByPolicyAndOpenedInTab(url)
                    return
                }
            }
            break
        }
        
        // try find chained url - handler index
        guard let chaine = registeredUrls.first(where: {$0.key == url.pattern}) else {
            state = .NotFoundConstructor(url)
            return
        }
        // constructor chained with url
        let constructor = constructors[chaine.value]
        
        // actions when received view controller from constructor
        let constructorCallback: ViewControllerConstructor_Callback = { viewController in
            // used to print debug info, unlock segues on error and return to caller
            var state: PushState = .RejectedByConstructor(url)
            if let viewController = viewController {
                // set segue url to controller
                viewController.url = url
                // apply segue
                navigationController.pushViewController(viewController, animated: animated)
                // apply state
                state = .Success(url)
            }
            // print debug
            if self.debugEnabled { state.print() }
            // unlock segues
            self.isSegueing = false
            // call complition if we have
            completion?(state)
        }
        
        // call constructor with callback
        constructor(url, constructorCallback)
        
        // set waiting status to skip defer
        state = .WaitingConstuctor(url)
    }
    
    
    // MARK: - Pop segues
    /// Make pop segue by url with segueCompletionHandler callback. If you want you can pass "/" as url to pop to root view controller - just short case. You can specify navigation controller or segue will be applied to top navigation controller. Will be called func update of protocol ZNTargetViewController_Protocol before pop if you set forceUpdate or if new queryItems differs or if query items in url differs. URL Destinations: "/" | "POP_ROOT" - root, "POP_ONE" - pop one.
    func popTo(url: URL, queryItems: [URLQueryItem] = [], navigationController: UINavigationController? = nil, forceUpdate: Bool = false, animated: Bool = true, completion: PopSegueCompletionHandler? = nil, ignoreBlocked: Bool = false, allowDefer: Bool = true) {
        
        // # - generating url for debug and usage
        // making url mutable
        var url = url
        
        // try update queries
        if queryItems.count > 0 {
            url.append(queryItems: queryItems)
        }
        
        // # - main part
        // used to print debug info, unlock segues on error and return to caller. Starting status is Blocked.
        var state: PopState = .Blocked(url)
        
        // defer used to control interruptions
        defer {
            if allowDefer {
                // print segue state
                printState(state)
                // unlock segues if we had some wrong state and it's state isn't .Blocked
                if state != .Blocked(url) {
                    isSegueing = false
                }
                // call segueCompletionHandler if we have
                completion?(state)
            }
        }
        
        // segue not allowed at this moment
        if isSegueing && !ignoreBlocked {
            return
        }
        
        // block other segues until this one ended
        isSegueing = true
        
        // try get top navigation controller
        guard let navigationController = navigationController ?? self.navigationController else {
            state = .NotFoundNavigationController(url)
            return
        }
        
        // check view controllers in stack
        let count = navigationController.viewControllers.count
        if count <= 1 {
            if count == 0 {
                state = .NoViewControllers(url)
            } else {
                // we must try call update if one existing view controller conforms to url. No need know about update state.
                update(viewController: navigationController.viewControllers.last, url: url, forceUpdate: forceUpdate)
                // change state here to prevent .Success and etc
                state = .isRootViewController(url)
            }
            return
        }
        
        // detecting target view controller index
        var index: Int?
        switch url.path {
        case Navigator.rootURL.path, Navigator.rootSlashURL.path:
            index = 0
            // we must fix destination link
            url = correctedURL(basedOn: navigationController.viewControllers[0], queryItems: queryItems)
            break
        case Navigator.popURL.path:
            index = count - 2
            // we must fix destination link
            url = correctedURL(basedOn: navigationController.viewControllers[count - 2], queryItems: queryItems)
            break
        default:
            index = lastIndex(of: url, for: navigationController)
            break
        }
        
        // check index availability
        guard let index = index else {
            state = .NotFoundDestinationURL(url)
            return
        }
        
        // get target view controller
        let viewController = navigationController.viewControllers[index]
        
        // if view controller is visible now
        if index == count - 1 {
            // we must try call update in target view controller, even if view controller is visible now. No need know about update state.
            update(viewController: viewController, url: url, forceUpdate: forceUpdate)
            // change state here to prevent .Success and etc
            state = .AlreadyHere(url)
            return
        }
        
        // set final url to success state
        state = .Success(url)
        
        // update
        let updateState = update(viewController: viewController, url: url, forceUpdate: forceUpdate)
        switch updateState {
        case .NoNeed(let url):
            // No need call update()
            state = .SuccessNoNeedUpdate(url)
            break
        case .Done(let url):
            // indicates that segue success, and update called
            state = .SuccessWithUpdate(url)
            break
        default:
            // indicates that segue is success, but can't call update()
            state = .SuccessWithoutUpdate(url)
            break
        }
        
        // pop
        navigationController.popToViewController(viewController, animated: animated)
    }
    
    func correctedURL(basedOn viewController: UIViewController, queryItems: [URLQueryItem]) -> URL {
        if let viewController = viewController as? ZNTargetViewController_Protocol, let path = viewController.url?.path, var url = URL(string: path) {
            url.append(queryItems: queryItems)
            return url
        }
        return viewController._url
    }
}
