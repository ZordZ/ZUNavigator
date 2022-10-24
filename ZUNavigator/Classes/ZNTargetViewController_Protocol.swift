//
//  Module: Navigator
//  Created by: MrTrent on 06.10.2022
//  Copyright (c) 2022 Zordz Union
//  


import Foundation

/// Implement this protocol to full support Navigator.
public protocol ZNTargetViewController_Protocol: UIViewController {
    
    /// View controller url which should be used in Navigator.
    var url: URL? {set get}
    
    /// Used to update data on pop. URL path used as uniq, but query part can be changed to transfer new data to target view controller.
    func update(via url: URL)
}
