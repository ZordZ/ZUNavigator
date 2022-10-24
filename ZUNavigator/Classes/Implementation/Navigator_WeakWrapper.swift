//
//  Module: Navigator
//  Created by: MrTrent on 18.10.2022
//  Copyright (c) 2022 Zordz Union
//  


import Foundation
import ZUCore

// MARK: - WeakWrapper
extension Navigator {
    // Short name for combination of AnyObject and Hashable
    public typealias AnyHashableObject = AnyObject&Hashable
    
    // Just a simple wrapper for UINavigationController and UITabBarController to place in sequences
    public class WeakWrapper<T: AnyHashableObject>: Hashable {
        // Store value as weak
        weak var value : T?
        var addressStr: String
        
        init (_ value: T) {
            self.value = value
            self.addressStr = MemoryAddressUtils.getAddress(value)
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(value?.hashValue)
        }
        
        static public func == (lhs: Navigator.WeakWrapper<T>, rhs: Navigator.WeakWrapper<T>) -> Bool {
            return lhs.value?.hashValue == rhs.value?.hashValue
        }
    }
}
