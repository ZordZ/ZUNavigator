//
//  Module: Navigator
//  Created by: MrTrent on 22.10.2022
//  Copyright (c) 2022 Zordz Union
//  


import Foundation

// MARK: url short cases
extension Navigator {
    
    /** Pseudo url. You can use it as short case to pop to root. */
    static let rootURL: URL = URL(string: "POP_ROOT")!
    
    /** Pseudo url. You can use it as short case to pop to root. */
    static let rootSlashURL: URL = URL(string: "/")!
    
    /** Pseudo url. You can use it as short case to pop one view controller */
    static let popURL: URL = URL(string: "POP_ONE")!
}
