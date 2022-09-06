//
//  Decodable.swift
//  RaiffeisenTest
//
//  Created by Oleh Petrenko on 06.09.2022.
//

import Foundation

public struct SafeDecodable<Base: Decodable>: Decodable {
    
    public let value: Base?
    
    public init(from decoder: Decoder) throws {
        do {
            let container = try decoder.singleValueContainer()
            self.value = try container.decode(Base.self)
        } catch {
            self.value = nil
        }
    }
    
}

public extension Decodable {
    
    static func decode(from data: Data, dateFormatter: DateFormatter? = nil) -> Self? {
        let decoder = JSONDecoder()
        if let dateFormatter = dateFormatter {
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
        }
        return try? decoder.decode(Self.self, from: data)
    }
    
    static func decodeToArray(from data: Data, dateFormatter: DateFormatter? = nil) -> [Self]? {
        do {
            let decoder = JSONDecoder()
            if let dateFormatter = dateFormatter {
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
            }
            return try decoder.decode([SafeDecodable<Self>].self, from: data).compactMap { $0.value }
        } catch {
            print(error)
            return nil
        }
    }
    
    static func typelessDecode(from data: Data) -> Any? { decode(from: data) ?? decodeToArray(from: data) }
    
    static func decode(from string: String) -> Self? {
        guard let data = string.data(using: .utf8) else { return nil }
        
        return Self.self.decode(from: data)
    }
    
    static func decodeFromJSON(_ json: Any?) -> Self? {
        guard let json = json, let data = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed) else { return nil }
        
        return Self.self.decode(from: data)
    }
    
}
