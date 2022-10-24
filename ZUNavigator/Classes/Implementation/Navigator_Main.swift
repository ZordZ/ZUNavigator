//
//  Module: Navigator
//  Created by: MrTrent on 23.10.2022
//  Copyright (c) 2022 Zordz Union
//  


import Foundation

public class Navigator {

    /// Internal singletone to make direct access via module name
    internal static let shared = Navigator()
    
    /// IdenticalLinksPolicy - stack matching behavior policy
    internal var identicalLinksPolicy: IdenticalLinksPolicy = .Open
    
    /// Stores all available segue handlers
    internal var constructors: [ViewControllerConstructor] = []
    
    /// Stores chained urls with segue handlers
    internal var registeredUrls: [String : Int] = [:]
    
    /// Indicates segue status to prevent many segue in one time
    internal var isSegueing: Bool = false
    
    /// If enabled - prints segue info in console
    internal var debugEnabled: Bool = true
    
    /// All registered navigation and tab bar controllers
    internal var registeredControllers: Set<WeakWrapper<UIViewController>> = []
    
    /// A policy that determines how deeply the update of url data is applied.
    internal var updatePolicy: UpdatePolicy = .FirstMatch
}
