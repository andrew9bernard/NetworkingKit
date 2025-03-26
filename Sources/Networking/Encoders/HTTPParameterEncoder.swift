//
//  HTTPParameterEncoder.swift
//  Networking
//
//  Created by Andrew Bernard on 3/26/25.
//


import Foundation

public protocol HTTPParameterEncoder {
    func encodeParameters(for urlRequest: inout URLRequest, with parameters: [HTTPParameter]) throws
}

public struct HTTPParameterEncoderImpl: HTTPParameterEncoder {
    public init() {}
    public func encodeParameters(for urlRequest: inout URLRequest, with parameters: [HTTPParameter]) throws {
        guard let url = urlRequest.url else {
            throw NetworkError.internalError(.noURL)
        }

        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
            urlRequest.url = urlComponents.url
        }
    }
}
