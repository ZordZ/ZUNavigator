//
//  Module: ZUCore
//  Created by: MrTrent on 03.09.2022
//  Copyright (c) 2022 Zordz Union
//


import Foundation

public struct MemoryAddressUtils {
    /// get memory address string for some data
    public static func getAddress(_ data: Any) -> String {
        if isClass(data) {
            return getAddress_Obj(data as AnyObject)
        }
        return getAddress_Stack(data)
    }
    private static func getAddress_Obj(_ data: AnyObject) -> String {
        return NSString(format: "%p", address(o: data)) as String
    }
    
    private static func getAddress_Stack(_ data: Any) -> String {
        var _data = data
        return NSString(format: "%p", address(o: &_data)) as String
    }
    /// get address for object
    private static func address(o: AnyObject) -> Int {
        return unsafeBitCast(o, to: Int.self)
    }
    /// get address for struct
    private static func address(o: UnsafeRawPointer) -> Int {
        return Int(bitPattern: o)
    }
    /// detect class or struct
    private static func isClass(_ any: Any) -> Bool {
        if Mirror(reflecting: any).displayStyle == .class {
            return true
        }
        return false
    }
}
