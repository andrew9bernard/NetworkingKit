//
//  ResponseValidator.swift
//  Networking
//
//  Created by Andrew Bernard on 3/24/25.
//

import Foundation

public struct URLResponseHeaders: Sendable, Equatable {
    private var headers: [String: String]

    public init(headers: [String: String]) {
        self.headers = headers
    }

    public subscript(key: String) -> String? {
        get { headers[key] }
        set { headers[key] = newValue }
    }

    public var allHeaders: [String: String] {
        return headers
    }
}

public protocol ResponseValidatorProtocol: Sendable {
    func validateNoError(_ error: Error?) throws
    func validateStatus(from urlResponse: URLResponse?) throws
    func validateData(_ data: Data?) throws -> Data
    func validateUrl(_ url: URL?) throws -> URL
}

public struct ResponseValidator: ResponseValidatorProtocol {
    public init() {}
    
    public func validateNoError(_ error: (any Error)?) throws {
        if let error = error {
            if let urlError = error as? URLError {
                throw NetworkError.urlError(urlError)
            }
            throw NetworkError.internalError(.requestFailed(error))
        }
    }
    
    public func validateStatus(from urlResponse: URLResponse?) throws {
        guard let urlResponse else {
            throw NetworkError.internalError(.noResponse)
        }
        guard let httpURLResponse = urlResponse as? HTTPURLResponse else {
            throw NetworkError.internalError(.noHTTPURLResponse)
        }
        try validateStatusCodeAccepability(from: httpURLResponse)
    }
    
    public func validateData(_ data: Data?) throws -> Data {
        guard let data else {
            throw NetworkError.internalError(.noData)
        }
        return data
    }
    
    public func validateUrl(_ url: URL?) throws -> URL {
        guard let url else {
            throw NetworkError.internalError(.noURL)
        }
        return url
    }
    
    private func validateStatusCodeAccepability(from httpURLResponse: HTTPURLResponse) throws {
        let statusCodeType = HTTPStatusCodeType.evaluate(from: httpURLResponse.statusCode)
        let urlResponseHeaders = httpURLResponse.allHeaderFields
        let headersAsStrings = urlResponseHeaders.reduce(into: [String: String]()) { result, pair in
            if let key = pair.key as? String, let value = pair.value as? String {
                result[key] = value
            }
        }
        let responseHeaders = URLResponseHeaders(headers: headersAsStrings)
        
        switch statusCodeType {
        case .information(let status):
            throw NetworkError.information(status, responseHeaders)
        case .success(_):
            return
        case .redirectionMessage(let status):
            guard status == .notModified else {
                throw NetworkError.redirect(status, responseHeaders)
            }
            return
        case .clientSideError(let error):
            throw NetworkError.httpClientError(error, responseHeaders)
        case .serverSideError(let error):
            throw NetworkError.httpServerError(error, responseHeaders)
        case .unknown:
            throw NetworkError.internalError(.unknown)
        }
    }
}
