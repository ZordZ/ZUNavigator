//
//  Module: Navigator
//  Created by: MrTrent on 18.10.2022
//  Copyright (c) 2022 Zordz Union
//  


import Foundation

extension Sequence where Iterator.Element == Navigator.UpdateState {
    /// Reports if it contains at least one positive status. As positive status: NoNeed, Issue, Done. That means we have found view controller with target url.
    internal func haveSuccessful() -> Bool {
        for state in self {
            switch state {
            case .NoNeed(_), .Issue(_), .Done(_):
                return true
            default:
                break
            }
        }
        return false
    }
}
