//
//  Module: Navigator
//  Created by: MrTrent on 03.10.2022
//  Copyright (c) 2022 Zordz Union
//  


import Foundation

internal extension URL {
    /// URL string pattern representation
    var pattern: String {
        let components = pathComponents
        var pattern = ""
        if components.count > 0 {
            for component in components {
                pattern = pattern + preparePathComponent(component)
            }
        }
        return pattern
    }
    
    /// prepare path component to generate pattern
    func preparePathComponent(_ component: String) -> String {
        // first component for url started with '/'
        if component == "/" { return "" }
        // int check - WILL BE DEPRECATED SOON
        if let _ = Int(component) {
            return "/%i"
        }
        // check param separator ':'
        if component.first == Character(":") {
            let dropped = String(component.dropFirst())
            if let _ = Int(dropped) {
                return "/%i"
            } else {
                return "/%s"
            }
        }
        
        return "/\(component)"
    }
}



// MARK: - Extracting path parameters
public extension URL {
    /// url path params as array of strings
    var pathParams: [String] {
        let components = pathComponents
        var params: [String] = []
        for component in components {
            if component.first == Character(":") {
                let dropped = String(component.dropFirst())
                params.append(dropped)
            }
        }
        
        return params
    }
    
    // For error handling
    enum PathParamsError: Error {
        case IndexIsOutOfBounds
        case WrongTypeSelected
    }
    
    /// Returns path parameter by index.
    func parameter(index: Int) throws -> String {
        let params = pathParams
        if params.count <= index {
            throw PathParamsError.IndexIsOutOfBounds
        }
        return pathParams[index]
    }
    
    /// Returns path parameter by index as specified type.
    func parameter<T>(index: Int, as type: T.Type) throws -> T {
        guard let param = try? parameter(index: index) else {
            throw PathParamsError.IndexIsOutOfBounds
        }
        var value: Any = param
        switch type {
        case is Int.Type:
            if let valueInt = Int(param) {
                value = valueInt
            }
            break
        case is String.Type:
            // string is default type
            break
        default:
            throw PathParamsError.WrongTypeSelected
        }
        return value as! T
    }
}



// MARK: - Appending query
public extension URL {
    /// Append query item to url
    mutating func appendQueryItem(name: String, value: String?) {
        append(queryItem: URLQueryItem(name: name, value: value))
    }
    
    /// Append query item to url
    mutating func append(queryItem: URLQueryItem) {
        // creating components
        guard var urlComponents = URLComponents(string: absoluteString) else { return }
        
        // workaround to prevent forbidden chars - by default URLQueryItem accepts not allowed in query chars
        guard let name = queryItem.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let value = queryItem.value?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            assertionFailure("Query item have issues")
            return
        }
        let queryItem = URLQueryItem(name: name, value: value)
        
        // array of existing query items
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
        
        // update query item if exists
        if let index = queryItems.firstIndex(where: ({$0.name == queryItem.name})) {
            queryItems[index] = queryItem
            
        // append new query item
        } else {
            queryItems.append(queryItem)
        }
        // applying
        urlComponents.queryItems = queryItems
        
        // returns url from components
        self = urlComponents.url!
    }
    
    /// Append array of query items to url
    mutating func append(queryItems: [URLQueryItem]) {
        // creating components
        guard var urlComponents = URLComponents(string: absoluteString) else { return }
        
        // array of existing query items
        var _queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
        
        // iterating
        for queryItem in queryItems {
            // workaround to prevent forbidden chars - by default URLQueryItem accepts not allowed in query chars
            guard let name = queryItem.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let value = queryItem.value?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                assertionFailure("Query item have issues")
                return
            }
            let queryItem = URLQueryItem(name: name, value: value)
            
            // update query item if exists
            if let index = _queryItems.firstIndex(where: ({$0.name == queryItem.name})) {
                _queryItems[index] = queryItem
                
            // append new query item
            } else {
                _queryItems.append(queryItem)
            }
        }
        
        // applying
        urlComponents.queryItems = _queryItems
        
        // returns url from components
        self = urlComponents.url!
    }
    
    /// returns value of query item or nil
    func queryItemValue(_ name: String) -> String? {
        guard let urlComponents = URLComponents(string: absoluteString), let queryItems = urlComponents.queryItems else { return nil }
        return queryItems.first(where: {$0.name == name})?.value
    }
}
