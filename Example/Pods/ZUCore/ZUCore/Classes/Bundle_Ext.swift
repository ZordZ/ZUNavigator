//
//  Module: ZUCore
//  Created by: MrTrent on 21.08.2022
//  Copyright (c) 2022 Zordz Union
//


import Foundation

public extension Bundle {
    var displayName: String {
        return (object(forInfoDictionaryKey: "CFBundleDisplayName") ?? object(forInfoDictionaryKey: "CFBundleName")) as? String ?? "unknown"
    }
    var appVersion: String {
        return object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "unknown"
    }
    var buildVersion: String {
        return object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "unknown"
    }
    var targetName: String? {
        return object(forInfoDictionaryKey: "CFBundleName") as? String
    }
}
