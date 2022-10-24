//
//  Module: Navigator_Example
//  Created by: MrTrent on 13.10.2022
//  Copyright (c) 2022 Zordz Union
//  


import Foundation
import UIKit
import ZUNavigator

extension Date {
    /// Time as string representation - HH:mm:ss.SSS
    var timeAsString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter.string(from: self)
    }
}



protocol EnumTextRepresenntation {
    var text: String {get}
}
extension Navigator.IdenticalLinksPolicy: EnumTextRepresenntation {
    /// String representation for policy options
    var text: String {
        switch self {
        case .Open:
            return "Open"
        case .PopTo:
            return "PopTo"
        case .PopToOrOpenTab:
            return "PopTo|OpenTab"
        }
    }
}
extension Navigator.UpdatePolicy: EnumTextRepresenntation {
    var text: String {
        switch self {
        case .FirstMatch:
            return "First"
        case .EveryMatch:
            return "Every"
        case .EveryMatchAndNearBy:
            return "Every&NearBy"
        }
    }
}

extension UISegmentedControl {
    func addSegemnts(_ items: [EnumTextRepresenntation]) {
        items.forEach({insertSegment(withTitle: $0.text, at: numberOfSegments, animated: false)})
    }
}

extension String {
    func dropFirstAndUppercasedFirst() -> String {
        let str = String(dropFirst())
        return str.prefix(1).uppercased() + str.lowercased().dropFirst()
    }
    
    func uppercasedFirstLetter() -> String {
        return prefix(1).uppercased() + lowercased().dropFirst()
    }
}
