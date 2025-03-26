//
//  MockNetworking.swift
//  Networking
//
//  Created by Andrew Bernard on 3/23/25.
//
import Foundation

// MARK: - MockWebService
class MockNetworking: AsyncRequestProtocol, @unchecked Sendable {
    func perform(request: any RequestModel) async throws {
            guard let request = request as? MockRequest else {
                throw NetworkError.endpointNotMocked
            }
            
        guard let data = request.mockData() else {
                throw NetworkError.mockDataMissing
            }
        }
    
    func perform<T>(request: any RequestModel, decodeTo decodableObject: T.Type) async throws -> T {
//        guard let endpoint = endpoint as? MockEndpoint else {
//                   throw NetworkError.endpointNotMocked
//               }
//               
//               guard let data = endpoint.mockData() else {
//                   throw NetworkError.mockDataMissing
//               }
//               
//        return try requestDecoder.decode(data, from: endpoint)
        return T.self as! T
    }
    
    
    private let validator: ResponseValidatorProtocol
    private let requestDecoder: RequestDecodableProtocol
    
    public init(
        validator: ResponseValidatorProtocol = ResponseValidator(),
                requestDecoder: RequestDecodableProtocol = RequestDecoder()) {
        
        self.validator = validator
        self.requestDecoder = requestDecoder
    }
}
