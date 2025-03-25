//
//  NetworkStackError.swift
//  Networking
//
//  Created by Andrew Bernard on 3/23/25.
//
import Foundation

// Define a more detailed error type
public enum NetworkError: Error {
    case invalidRequest
    case dataMissing
    case endpointNotMocked
    case mockDataMissing
    case responseError(statusCode: Int)
    case clientError(statusCode: Int)
    case serverError(statusCode: Int)
    case unexpectedStatusCode(statusCode: Int)
    case parserError(error: Error, data: Data?)
    case imageProcessingError
    case graphQLError(error: Error)
    
    case internalError(InternalError)
    case urlError(URLError)
    
    // HTTP Status Code errors
    case information(HTTPInformationalStatus, URLResponseHeaders)       /// 1xx status code errors
    case redirect(HTTPRedirectionStatus, URLResponseHeaders)            /// 3xx status code errors
    case httpClientError(HTTPClientErrorStatus, URLResponseHeaders)     /// 4xx status code errors
    case httpServerError(HTTPServerErrorStatus, URLResponseHeaders)     /// 5xx status code errors
}

extension NetworkError: Equatable, Sendable {
    public static func ==(lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case let (.internalError(error1), .internalError(error2)):
            return error1 == error2
        
        case let (.information(error1, _), .information(error2, _)):
            return error1 == error2
            
        case let (.redirect(error1, _), .redirect(error2, _)):
            return error1 == error2

        case let (.httpClientError(error1, _), .httpClientError(error2, _)):
            return error1 == error2
        
        case let (.httpServerError(error1, _), .httpServerError(error2, _)):
            return error1 == error2

        case let (.urlError(error), .urlError(error2)):
            return error == error2

        default:
            return false
        }
    }
}
