//
//  Request.swift
//  Networking
//
//  Created by Andrew Bernard on 3/26/25.
//


import Foundation

public protocol Request {
    var httpMethod: HTTPMethod { get }
    var baseUrlString: String { get }
    var parameters: [HTTPParameter]? { get }
    var headers: [HTTPHeader]? { get }
    var body: HTTPBody? { get }
    var timeoutInterval: TimeInterval { get }
    var cachePolicy: URLRequest.CachePolicy { get }
}

// default values
public extension Request {
    var timeoutInterval: TimeInterval { 60 }
    var cachePolicy: URLRequest.CachePolicy { .useProtocolCachePolicy }
}

// additions
public extension Request {
    var urlRequest: URLRequest? {
        guard let url = URL(string: baseUrlString) else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.httpBody = body?.data
        request.timeoutInterval = timeoutInterval
        request.cachePolicy = cachePolicy

        if let parameters = parameters {
            try? HTTPParameterEncoderImpl().encodeParameters(for: &request, with: parameters)
        }

        if let headers = headers {
            HTTPHeaderEncoderImpl().encodeHeaders(for: &request, with: headers)
        }

        return request
    }
}

internal struct BaseRequest: Request {
    var httpMethod: HTTPMethod
    var baseUrlString: String
    var parameters: [HTTPParameter]?
    var headers: [HTTPHeader]?
    var body: HTTPBody?
    var timeoutInterval: TimeInterval
    var cachePolicy: URLRequest.CachePolicy
}
