//
//  Component.swift
//  iTunesSearch
//
//  Created by Victoria Vorobyova on 23.03.2023.
//

import Foundation

struct Component {
    let host: String
    let path: String
    let headers: [String: String]
    let queryItems: [URLQueryItem]
}

extension Component {
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
}
