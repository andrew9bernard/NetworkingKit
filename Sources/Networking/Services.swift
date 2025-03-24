//
//  Services.swift
//  Networking
//
//  Created by Andrew Bernard on 3/23/25.
//

import Foundation
//
//// Define a more detailed error type
//enum NetworkStackError: Error {
//    case invalidRequest
//    case dataMissing
//    case endpointNotMocked
//    case mockDataMissing
//    case responseError(statusCode: Int)
//    case clientError(statusCode: Int)
//    case serverError(statusCode: Int)
//    case unexpectedStatusCode(statusCode: Int)
//    case parserError(error: Error, data: Data?)
//    case imageProcessingError
//    case graphQLError(error: Error)
//}
//
//// MARK: - NetworkingProtocol
//protocol NetworkingProtocol {
//    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
//    func requestGraphQL<T: Decodable>(_ endpoint: Endpoint, query: String, variables: [String: Any]?) async throws -> T
//}
//
// MARK: - Networking
//
//// MARK: - MockNetworking
//class MockNetworking: NetworkingProtocol {
//    private let parser: Parser
//    
//    init(parser: Parser = Parser()) {
//        self.parser = parser
//    }
//    
//    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
//        guard let endpoint = endpoint as? MockEndpoint else {
//            throw NetworkStackError.endpointNotMocked
//        }
//        
//        guard let data = endpoint.mockData() else {
//            throw NetworkStackError.mockDataMissing
//        }
//        
//        return try parser.json(data: data)
//    }
//    
//    func requestGraphQL<T: Decodable>(_ endpoint: Endpoint, query: String, variables: [String: Any]?) async throws -> T {
//        throw NetworkStackError.endpointNotMocked
//    }
//}
//
//// MARK: - Parser
//struct Parser {
//    private let jsonDecoder = JSONDecoder()
//    
//    func json<T: Decodable>(data: Data) throws -> T {
//        do {
//            return try jsonDecoder.decode(T.self, from: data)
//        } catch let error {
//            throw NetworkStackError.parserError(error: error, data: data)
//        }
//    }
//}
//
//// MARK: - Endpoint
//protocol Endpoint {
//    func request() -> URLRequest?
//}
//
////extension Endpoint {
////    func request(forEndpoint endpoint: String) -> URLRequest {
////        var urlComponents = URLComponents()
////        urlComponents.scheme = scheme
////        urlComponents.host = host
////        urlComponents.path = endpoint
////        urlComponents.queryItems = queryItems
////        
////        guard let url = urlComponents.url else { return nil }
////        
////        var request = URLRequest(url: url)
////        request.httpMethod = httpMethod
////        
////        httpHeaders?.forEach { key, value in
////            request.setValue(value, forHTTPHeaderField: key)
////        }
////        
////        return request
////    }
////}
//
//struct AT: Endpoint {
//    
//    func request() -> URLRequest? {
//        let urlRequest =  URLRequestBuilder(path: "users/submit")
//            .method(.post)
//            .contentType(.applicationJSON)
//            .accept(.applicationJSON)
//            .timeout(20)
//            .queryItem(name: "city", value: "San Francisco")
//            .makeRequest(withBaseURL: URL(string: "")!)
//        return urlRequest
//    }
//    
//}
//

