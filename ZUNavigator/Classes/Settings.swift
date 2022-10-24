//
//  Module: Navigator
//  Created by: MrTrent on 07.09.2022
//  Copyright (c) 2022 Zordz Union
//  


import Foundation
import ZUCore
import UIKit

// MARK: - Settings
extension Navigator {
    
    /**Behavior policy which determines how deep the update by url data is applied.*/
    public static var identicalLinksPolicy: IdenticalLinksPolicy {
        set {
            Navigator.shared.identicalLinksPolicy = newValue
        }
        get {
            return Navigator.shared.identicalLinksPolicy
        }
    }
    
    
    /**Behavior policy which determines how deep the update by url data is applied.*/
    public static var updatePolicy: UpdatePolicy {
        set {
            Navigator.shared.updatePolicy = newValue
        }
        get {
            return Navigator.shared.updatePolicy
        }
    }
    
    
    /**Enable or disable logs. Logs prints only in debug scheme.*/
    public static var debugEnabled: Bool {
        set {
            Navigator.shared.debugEnabled = newValue
        }
        get {
            return Navigator.shared.debugEnabled
        }
    }
}
