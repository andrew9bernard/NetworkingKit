//
//  RequestBuilder.swift
//  Networking
//
//  Created by Andrew Bernard on 3/23/25.
//
import Foundation

public struct QueryPayload: Codable {
    var query: String
    var variables: [String: AnyCodable]?
}

public protocol RequestBuilderProtocol {
    func setHttpMethod(_ method: HTTPMethod) -> RequestBuilderProtocol
    func setBaseUrl(_ baseUrl: String) -> RequestBuilderProtocol
    func setParameters(_ parameters: [HTTPParameter]) -> RequestBuilderProtocol
    func setHeaders(_ headers: [HTTPHeader]) -> RequestBuilderProtocol
    func setBody(_ body: HTTPBody) -> RequestBuilderProtocol
    func setTimeoutInterval(_ timeoutInterval: TimeInterval) -> RequestBuilderProtocol
    func setCachePolicy(_ cachePolicy: URLRequest.CachePolicy) -> RequestBuilderProtocol
    func build() -> Request
}

public class RequestBuilder: RequestBuilderProtocol {
   
    private var httpMethod: HTTPMethod = .get
    private var baseUrlString: String = ""
    private var parameters: [HTTPParameter]?
    private var headers: [HTTPHeader]?
    private var body: HTTPBody? = nil
    private var timeoutInterval: TimeInterval = 60
    private var cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy

    private let headerEncoder: HTTPHeaderEncoder
    private let paramEncoder: HTTPParameterEncoder

    public init(headerEncoder: HTTPHeaderEncoder = HTTPHeaderEncoderImpl(),
                paramEncoder: HTTPParameterEncoder = HTTPParameterEncoderImpl()) {
        self.headerEncoder = headerEncoder
        self.paramEncoder = paramEncoder
    }

    public func setHttpMethod(_ method: HTTPMethod) -> RequestBuilderProtocol {
        self.httpMethod = method
        return self
    }

    public func setBaseUrl(_ baseUrl: String) -> RequestBuilderProtocol {
        self.baseUrlString = baseUrl
        return self
    }

    public func setParameters(_ parameters: [HTTPParameter]) -> RequestBuilderProtocol {
        self.parameters = parameters
        return self
    }

    public func setHeaders(_ headers: [HTTPHeader]) -> RequestBuilderProtocol {
        self.headers = headers
        return self
    }

    public func setBody(_ body: HTTPBody) -> RequestBuilderProtocol {
        self.body = body
        return self
    }

    public func setTimeoutInterval(_ timeoutInterval: TimeInterval) -> RequestBuilderProtocol {
        self.timeoutInterval = timeoutInterval
        return self
    }
    
    public func setCachePolicy(_ cachePolicy: URLRequest.CachePolicy) -> RequestBuilderProtocol {
        self.cachePolicy = cachePolicy
        return self
    }

    public func build() -> Request {
        return BaseRequest(httpMethod: httpMethod, baseUrlString: baseUrlString, parameters: parameters, headers: headers, body: body, timeoutInterval: timeoutInterval, cachePolicy: cachePolicy)
    }
}
