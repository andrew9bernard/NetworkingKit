import Foundation


// MARK: - NetworkingProtocol
public protocol AsyncRequestProtocol: Sendable {
    func perform<T: Codable>(endpoint: Endpoint, decodeTo decodableObject: T.Type) async throws -> T
    func perform(endpoint: Endpoint) async throws
}

public struct AsyncRequest: AsyncRequestProtocol {
    
    private let urlSession: URLSession
    private let validator: ResponseValidatorProtocol
    private let requestDecoder: RequestDecodableProtocol
    
    public init(urlSession: URLSession = .shared, validator: ResponseValidatorProtocol = ResponseValidator(), requestDecoder: RequestDecodableProtocol = RequestDecoder()) {
        
        self.urlSession = urlSession
        self.validator = validator
        self.requestDecoder = requestDecoder
    }
    
    
    // MARK: perform request with Async Await and return Decodable using Request Protocol
    public func perform<T: Codable>(endpoint: Endpoint, decodeTo decodableObject: T.Type) async throws -> T {
        return try await performRequest(endpoint: endpoint, decodeTo: decodableObject)
    }
    
//    // MARK: perform request with Async Await using Request protocol
    public func perform(endpoint: Endpoint) async throws {
        try await performRequest(endpoint: endpoint, decodeTo: EmptyResponse.self)
    }
    
    @discardableResult
    private func performRequest<T: Codable>(endpoint: Endpoint, decodeTo decodableObject: T.Type) async throws -> T {
        do {
            guard let request = endpoint.request() else {
                throw NetworkError.internalError(.noRequest)
            }
            
            let (data, response) = try await urlSession.data(for: request)
            
            try validator.validateStatus(from: response)
            let validData = try validator.validateData(data)
            
            let result = try requestDecoder.decode(decodableObject, from: validData)
            return result
        } catch let error as NetworkError {
            throw error
        } catch let error as URLError {
            throw NetworkError.urlError(error)
        } catch {
            throw NetworkError.internalError(.unknown)
        }
    }
    
}

// MARK: - Endpoint
public protocol Endpoint {
    func request() -> URLRequest?
}
