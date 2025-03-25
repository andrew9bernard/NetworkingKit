//
//  RequestDecoder.swift
//  Networking
//
//  Created by Andrew Bernard on 3/23/25.
//
import Foundation

public protocol RequestDecodableProtocol {
    func decode<T: Codable>(_ type: T.Type, from data: Data) throws -> T
}

public struct RequestDecoder: RequestDecodableProtocol {
    public init() {}
    public func decode<T: Codable>(_ type: T.Type, from data: Data) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.internalError(.couldNotParse)
        }
    }
}
