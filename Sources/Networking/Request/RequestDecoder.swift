//
//  RequestDecoder.swift
//  Networking
//
//  Created by Andrew Bernard on 3/23/25.
//
import Foundation

public protocol RequestDecodableProtocol: Sendable {
    func decode<T: Codable>(_ type: T.Type, from data: Data) throws -> T
}

public struct RequestDecoder: RequestDecodableProtocol {
    public init() {}
    public func decode<T: Codable>(_ type: T.Type, from data: Data) throws -> T {
        do {
            print("📦 Raw JSON Data:", String(data: data, encoding: .utf8) ?? "Invalid JSON")
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("❌ Decoding Error:", error)
            throw NetworkError.internalError(.couldNotParse)
        }
    }
}
