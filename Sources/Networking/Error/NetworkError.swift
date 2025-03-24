//
//  NetworkStackError.swift
//  Networking
//
//  Created by Andrew Bernard on 3/23/25.
//
import Foundation

// Define a more detailed error type
enum NetworkError: Error {
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
    case urlError(URLError) 
}
