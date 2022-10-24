//
//  Module: Navigator
//  Created by: MrTrent on 03.10.2022
//  Copyright (c) 2022 Zordz Union
//  


import Foundation
import ZUCore

internal extension UIViewController {
    /// URL impelemented with ZNTargetViewController_Protocol or replacement based on memory address "/0x..."
    var _url: URL {
        guard let vc = self as? ZNTargetViewController_Protocol, let url = vc.url else {
            return URL(string: "/\(MemoryAddressUtils.getAddress(self))")!
        }
        return url
    }
}
