//
//  URLRequestBuilder.swift
//  Networking
//
//  Created by Andrew Bernard on 3/23/25.
//
import Foundation

public typealias EndpointRequest = URLRequestBuilder

public struct URLRequestBuilder: Sendable {
    public private(set) var buildURLRequest: @Sendable (inout URLRequest) -> Void
    public private(set) var urlComponents: URLComponents

    private init(urlComponents: URLComponents) {
        self.buildURLRequest = { _ in }
        self.urlComponents = urlComponents
    }

    // MARK: - Starting point

    public init(path: String) {
        var components = URLComponents()
        components.path = path
        self.init(urlComponents: components)
    }

    public static func customURL(_ url: URL) -> URLRequestBuilder {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            print("can't make URLComponents from URL")
            return URLRequestBuilder(urlComponents: .init())
        }
        return URLRequestBuilder(
            urlComponents: components
        )
    }

    // MARK: - Building Blocks
    public func modifyURL(_ modifyURL: @escaping (inout URLComponents) -> Void) -> URLRequestBuilder {
        var copy = self
        var newComponents = copy.urlComponents // Ensure we work on a new copy
        modifyURL(&newComponents)
        copy.urlComponents = newComponents
        return copy
    }
    public func modifyRequest(_ modifyRequest: @escaping @Sendable (inout URLRequest) -> Void) -> URLRequestBuilder {
        var copy = self
        let existing = buildURLRequest
        copy.buildURLRequest = { request in
            existing(&request)
            modifyRequest(&request)
        }
        return copy
    }

    public func method(_ method: Method) -> URLRequestBuilder {
        modifyRequest { $0.httpMethod = method.rawValue }
    }

    public func body(_ body: Data, setContentLength: Bool = false) -> URLRequestBuilder {
        let updated = modifyRequest { $0.httpBody = body }
        if setContentLength {
            return updated.contentLength(body.count)
        } else {
            return updated
        }
    }

    public static let jsonEncoder = JSONEncoder()

    public func jsonBody<Content: Encodable>(_ body: Content, encoder: JSONEncoder = URLRequestBuilder.jsonEncoder, setContentLength: Bool = false) throws -> URLRequestBuilder {
        let body = try encoder.encode(body)
        return self.body(body)
    }

    // MARK: Query

    public func queryItems(_ queryItems: [URLQueryItem]) -> URLRequestBuilder {
        modifyURL { urlComponents in
            var items = urlComponents.queryItems ?? []
            items.append(contentsOf: queryItems)
            urlComponents.queryItems = items
        }
    }

    public func queryItems(_ queryItems: KeyValuePairs<String, String>) -> URLRequestBuilder {
        self.queryItems(queryItems.map { .init(name: $0.key, value: $0.value) })
    }

    public func queryItem(name: String, value: String) -> URLRequestBuilder {
        queryItems([name: value])
    }

    public func contentType(_ contentType: ContentType) -> URLRequestBuilder {
        header(name: ContentType.header, value: contentType.rawValue)
    }
    
    public func accept(_ contentType: ContentType) -> URLRequestBuilder {
        header(name: .accept, value: contentType.rawValue)
    }

    // MARK: Other

    public func contentLength(_ length: Int) -> URLRequestBuilder {
        header(name: .contentLength, value: String(length))
    }

    public func header(name: HeaderName, value: String) -> URLRequestBuilder {
        modifyRequest { $0.addValue(value, forHTTPHeaderField: name.rawValue) }
    }

    public func header(name: HeaderName, values: [String]) -> URLRequestBuilder {
        var copy = self
        for value in values {
            copy = copy.header(name: name, value: value)
        }
        return copy
    }

    public func timeout(_ timeout: TimeInterval) -> URLRequestBuilder {
        modifyRequest { $0.timeoutInterval = timeout }
    }
}

// MARK: - Finalizing

extension URLRequestBuilder {
    public func makeRequest(withBaseURL baseURL: URL) -> URLRequest {
        makeRequest(withConfig: .baseURL(baseURL))
    }

    public func makeRequest(withConfig config: RequestConfiguration) -> URLRequest {
        config.configureRequest(self)
    }
}

extension URLRequest {
    public init(baseURL: URL, endpointRequest: URLRequestBuilder) {
        self = endpointRequest.makeRequest(withBaseURL: baseURL)
    }
}

extension URLRequestBuilder {
    public struct RequestConfiguration: Sendable {
        public init(configureRequest: @escaping @Sendable (URLRequestBuilder) -> URLRequest) {
            self.configureRequest = configureRequest
        }
        
        public let configureRequest: @Sendable (URLRequestBuilder) -> URLRequest
    }
}

extension URLRequestBuilder.RequestConfiguration {
    public static func baseURL(_ baseURL: URL) -> URLRequestBuilder.RequestConfiguration {
        return URLRequestBuilder.RequestConfiguration { request in
            let finalURL = request.urlComponents.url(relativeTo: baseURL) ?? baseURL

            var urlRequest = URLRequest(url: finalURL)
            request.buildURLRequest(&urlRequest)

            return urlRequest
        }
    }
    
    public static func base(scheme: String?, host: String?, port: Int?) -> URLRequestBuilder.RequestConfiguration {
        URLRequestBuilder.RequestConfiguration { request in
            var request = request
            request.urlComponents.scheme = scheme
            request.urlComponents.host = host
            request.urlComponents.port = port
            
            if !request.urlComponents.path.starts(with: "/") {
                request.urlComponents.path = "/" + request.urlComponents.path
            }
            
            guard let finalURL = request.urlComponents.url else {
                preconditionFailure()
            }
            
            var urlRequest = URLRequest(url: finalURL)
            request.buildURLRequest(&urlRequest)
            
            return urlRequest
        }
    }
}
