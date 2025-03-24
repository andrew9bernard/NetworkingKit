//
//  Parser.swift
//  Networking
//
//  Created by Andrew Bernard on 3/23/25.
//
import Foundation

struct Parser {
    private let jsonDecoder = JSONDecoder()
    
    func json<T: Decodable>(data: Data) throws -> T {
        do {
            return try jsonDecoder.decode(T.self, from: data)
        } catch let error {
            throw NetworkError.parserError(error: error, data: data)
        }
    }
}
