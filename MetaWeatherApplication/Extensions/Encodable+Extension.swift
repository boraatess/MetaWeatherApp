//
//  Encodable+Extension.swift
//  MetaWeatherApplication
//
//  Created by bora on 16.09.2021.
//

import Foundation

struct JSON {
    static let encoder = JSONEncoder()
}

extension Encodable {
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSON.encoder.encode(self))) as? [String: Any] ?? [:]
    }
    var string: String {
        return (try? JSONSerialization.jsonObject(with: JSON.encoder.encode(self))) as? String ?? ""
    }
}
