//
//  HTTPHeaderEncoder.swift
//  Networking
//
//  Created by Andrew Bernard on 3/26/25.
//


import Foundation

public protocol HTTPHeaderEncoder {
   func encodeHeaders(for urlRequest: inout URLRequest, with headers: [HTTPHeader])
}

public struct HTTPHeaderEncoderImpl: HTTPHeaderEncoder {
    public init() {}

    public func encodeHeaders(for urlRequest: inout URLRequest, with headers: [HTTPHeader]) {
        for header in headers {
            urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
        }
    }
}
