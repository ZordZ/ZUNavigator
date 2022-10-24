//
//  Module: Navigator
//  Created by: MrTrent on 19.10.2022
//  Copyright (c) 2022 Zordz Union
//  


import Foundation
import ZUCore

extension NSObject {
    // returns class as string representation
    var className: String {
        return NSStringFromClass(type(of: self))
    }
    // returns class as string representation
    var classNameSimple: String {
        let targetName = Bundle.main.targetName ?? ""
        return NSStringFromClass(type(of: self)).replacingOccurrences(of: "\(targetName).", with: "")
    }
}
