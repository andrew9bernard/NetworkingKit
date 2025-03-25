import Foundation


// MARK: - NetworkingProtocol
public protocol AsyncRequestProtocol {
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

//public struct Networking: NetworkingProtocol {
//    private let urlSession: URLSession
//    private let parser: Parser
//    
//    init(urlSession: URLSession = .shared, parser: Parser = Parser()) {
//        self.urlSession = urlSession
//        self.parser = parser
//    }
//    
//    private func request<T: Decodable>(_ endpoint: Endpoint, decodeTo decodableObject: T.Type) async throws -> T {
//        guard let request = endpoint.request() else {
//            throw NetworkError.invalidRequest
//        }
//        
//        let (data, response) = try await urlSession.data(for: request)
//        
//        guard let httpResponse = response as? HTTPURLResponse else {
//            throw NetworkError.responseError(statusCode: -1)
//        }
//        
//        switch httpResponse.statusCode {
//        case 200...299:
//            return try parser.json(data: data)
//        case 400...499:
//            throw NetworkError.clientError(statusCode: httpResponse.statusCode)
//        case 500...599:
//            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
//        default:
//            throw NetworkError.unexpectedStatusCode(statusCode: httpResponse.statusCode)
//        }
//    }
//    
//    func requestGraphQL<T: Decodable>(_ endpoint: Endpoint, query: String, variables: [String: Any]?) async throws -> T {
//        guard var request = endpoint.request() else {
//            throw NetworkError.invalidRequest
//        }
//        
//        let body: [String: Any] = [
//            "query": query,
//            "variables": variables ?? [:]
//        ]
//        
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
//        
//        let (data, response) = try await urlSession.data(for: request)
//        
//        guard let httpResponse = response as? HTTPURLResponse else {
//            throw NetworkError.responseError(statusCode: -1)
//        }
//        
//        switch httpResponse.statusCode {
//        case 200...299:
//            return try parser.json(data: data)
//        case 400...499:
//            throw NetworkError.clientError(statusCode: httpResponse.statusCode)
//        case 500...599:
//            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
//        default:
//            throw NetworkError.unexpectedStatusCode(statusCode: httpResponse.statusCode)
//        }
//    }
//}




// MARK: - Endpoint
public protocol Endpoint {
    func request() -> URLRequest?
}
