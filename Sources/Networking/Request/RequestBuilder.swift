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
    func build() -> RequestModel
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

    public func build() -> RequestModel {
        return BaseRequest(httpMethod: httpMethod, baseUrlString: baseUrlString, parameters: parameters, headers: headers, body: body, timeoutInterval: timeoutInterval, cachePolicy: cachePolicy)
    }
}

//
////public typealias RequestModel = URLRequestBuilder
//
//public struct RequestBuilder: Sendable {
//    public private(set) var buildURLRequest: @Sendable (inout URLRequest) -> Void
//    public private(set) var urlComponents: URLComponents
//
//    private init(urlComponents: URLComponents) {
//        self.buildURLRequest = { _ in }
//        self.urlComponents = urlComponents
//    }
//
//    // MARK: - Starting point
//
//    public init(path: String) {
//        var components = URLComponents()
//        components.path = path
//        self.init(urlComponents: components)
//    }
//
//    public static func customURL(_ url: URL) -> RequestBuilder {
//        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
//            print("can't make URLComponents from URL")
//            return RequestBuilder(urlComponents: .init())
//        }
//        return RequestBuilder(
//            urlComponents: components
//        )
//    }
//
//    // MARK: - Building Blocks
//    public func modifyURL(_ modifyURL: @escaping (inout URLComponents) -> Void) -> RequestBuilder {
//        var copy = self
//        var newComponents = copy.urlComponents // Ensure we work on a new copy
//        modifyURL(&newComponents)
//        copy.urlComponents = newComponents
//        return copy
//    }
//    public func modifyRequest(_ modifyRequest: @escaping @Sendable (inout URLRequest) -> Void) -> RequestBuilder {
//        var copy = self
//        let existing = buildURLRequest
//        copy.buildURLRequest = { request in
//            existing(&request)
//            modifyRequest(&request)
//        }
//        return copy
//    }
//
//    public func method(_ method: Method) -> RequestBuilder {
//        modifyRequest { $0.httpMethod = method.rawValue }
//    }
//
//    public func body(_ body: Data, setContentLength: Bool = false) -> RequestBuilder {
//        let updated = modifyRequest { $0.httpBody = body }
//        if setContentLength {
//            return updated.contentLength(body.count)
//        } else {
//            return updated
//        }
//    }
//    
//    // MARK: GraphQL Modifier
//    /// Adds a GraphQL request body using `QueryPayload`
//    public func graphQLRequestBody(_ queryPayload: QueryPayload, encoder: JSONEncoder = RequestBuilder.jsonEncoder) throws -> RequestBuilder {
//        let jsonBody = try encoder.encode(queryPayload)
//        return self
//            .method(.post) // GraphQL typically uses POST
//            .contentType(.applicationJSON) // Ensure JSON content-type
//            .body(jsonBody, setContentLength: true)
//    }
//
//    /// Convenience method to create a GraphQL request from a query string and variables
//    public func graphQLQuery(_ query: String, variables: [String: Any]? = nil, encoder: JSONEncoder = RequestBuilder.jsonEncoder) throws -> RequestBuilder {
//        let encodedVariables = variables?.mapValues { AnyCodable($0) }
//        let payload = QueryPayload(query: query, variables: encodedVariables)
//        return try graphQLRequestBody(payload, encoder: encoder)
//    }
//
//    public static let jsonEncoder = JSONEncoder()
//
//    public func jsonBody<Content: Encodable>(_ body: Content, encoder: JSONEncoder = RequestBuilder.jsonEncoder, setContentLength: Bool = false) throws -> RequestBuilder {
//        let body = try encoder.encode(body)
//        return self.body(body)
//    }
//
//    // MARK: Query
//
//    public func queryItems(_ queryItems: [URLQueryItem]) -> RequestBuilder {
//        modifyURL { urlComponents in
//            var items = urlComponents.queryItems ?? []
//            items.append(contentsOf: queryItems)
//            urlComponents.queryItems = items
//        }
//    }
//
//    public func queryItems(_ queryItems: KeyValuePairs<String, String>) -> RequestBuilder {
//        self.queryItems(queryItems.map { .init(name: $0.key, value: $0.value) })
//    }
//
//    public func queryItem(name: String, value: String) -> RequestBuilder {
//        queryItems([name: value])
//    }
//
//    public func contentType(_ contentType: ContentType) -> RequestBuilder {
//        header(name: ContentType.header, value: contentType.rawValue)
//    }
//    
//    public func accept(_ contentType: ContentType) -> RequestBuilder {
//        header(name: .accept, value: contentType.rawValue)
//    }
//
//    // MARK: Other
//
//    public func contentLength(_ length: Int) -> RequestBuilder {
//        header(name: .contentLength, value: String(length))
//    }
//
//    public func header(name: HeaderName, value: String) -> RequestBuilder {
//        modifyRequest { $0.addValue(value, forHTTPHeaderField: name.rawValue) }
//    }
//
//    public func header(name: HeaderName, values: [String]) -> RequestBuilder {
//        var copy = self
//        for value in values {
//            copy = copy.header(name: name, value: value)
//        }
//        return copy
//    }
//
//    public func timeout(_ timeout: TimeInterval) -> RequestBuilder {
//        modifyRequest { $0.timeoutInterval = timeout }
//    }
//}
//
//// MARK: - Finalizing
//
//extension RequestBuilder {
//    public func makeRequest(withConfig config: RequestConfiguration) -> URLRequest {
//        config.configureRequest(self)
//    }
//    
//    public func makeRequest(withBaseURL baseURL: URL) -> URLRequest {
//        makeRequest(withConfig: .baseURL(baseURL))
//    }
//}
//
//extension URLRequest {
//    public init(baseURL: URL, requestBuilder: RequestBuilder) {
//        self = requestBuilder.makeRequest(withBaseURL: baseURL)
//    }
//}
//
//extension RequestBuilder {
//    public struct RequestConfiguration: Sendable {
//        public init(configureRequest: @escaping @Sendable (RequestBuilder) -> URLRequest) {
//            self.configureRequest = configureRequest
//        }
//        
//        public let configureRequest: @Sendable (RequestBuilder) -> URLRequest
//    }
//}
//
//extension RequestBuilder.RequestConfiguration {
//    public static func baseURL(_ baseURL: URL) -> RequestBuilder.RequestConfiguration {
//        return RequestBuilder.RequestConfiguration { request in
//            let finalURL = request.urlComponents.url(relativeTo: baseURL) ?? baseURL
//
//            var urlRequest = URLRequest(url: finalURL)
//            request.buildURLRequest(&urlRequest)
//
//            return urlRequest
//        }
//    }
//    
//    public static func base(scheme: String?, host: String?, port: Int?) -> RequestBuilder.RequestConfiguration {
//        RequestBuilder.RequestConfiguration { request in
//            var request = request
//            request.urlComponents.scheme = scheme
//            request.urlComponents.host = host
//            request.urlComponents.port = port
//            
//            if !request.urlComponents.path.starts(with: "/") {
//                request.urlComponents.path = "/" + request.urlComponents.path
//            }
//            
//            guard let finalURL = request.urlComponents.url else {
//                preconditionFailure()
//            }
//            
//            var urlRequest = URLRequest(url: finalURL)
//            request.buildURLRequest(&urlRequest)
//            
//            return urlRequest
//        }
//    }
//}
