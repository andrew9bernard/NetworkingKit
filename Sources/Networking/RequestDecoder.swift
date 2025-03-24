//
//  Parser.swift
//  Networking
//
//  Created by Andrew Bernard on 3/23/25.
//
import Foundation

public protocol RequestDecodable {
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}

public struct RequestDecoder {
    public init() {}
    public func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.internalError(.couldNotParse)
        }
    }
}
