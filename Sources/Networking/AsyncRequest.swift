import Foundation


// MARK: - NetworkingProtocol
public protocol AsyncRequestProtocol {
    func perform<T: Decodable>(endpoint: Endpoint, decodeTo decodableObject: T.Type) async throws -> T
    //func perform(endpoint: Endpoint) async throws
    //func requestGraphQL<T: Decodable>(_ endpoint: Endpoint, query: String, variables: [String: Any]?) async throws -> T
}

public struct AsyncRequest: AsyncRequestProtocol {
    
    private let urlSession: URLSession
    private let parser: Parser
    
    public init(urlSession: URLSession = .shared, parser: Parser = Parser()) {
        self.urlSession = urlSession
        self.parser = parser
    }
    
    // MARK: perform request with Async Await and return Decodable using Request Protocol
    public func perform<T: Decodable>(endpoint: Endpoint, decodeTo decodableObject: T.Type) async throws -> T {
        return try await performRequest(endpoint: endpoint, decodeTo: decodableObject)
    }
    
//    // MARK: perform request with Async Await using Request protocol
//    public func perform(request: Request) async throws {
//        try await performRequest(request: request, decodeTo: EmptyResponse.self)
//    }
    
    private func performRequest<T: Decodable>(endpoint: Endpoint, decodeTo decodableObject: T.Type) async throws -> T {
        do {
            guard let request = endpoint.request() else {
                throw NetworkError.invalidRequest
            }
            
            let (data, response) = try await urlSession.data(for: request)
            
            //need to validate the response
            //need to validate the data
            
            let result = try parser.json(data: data)
        }
    }
    
}

public struct Networking: NetworkingProtocol {
    private let urlSession: URLSession
    private let parser: Parser
    
    init(urlSession: URLSession = .shared, parser: Parser = Parser()) {
        self.urlSession = urlSession
        self.parser = parser
    }
    
    private func request<T: Decodable>(_ endpoint: Endpoint, decodeTo decodableObject: T.Type) async throws -> T {
        guard let request = endpoint.request() else {
            throw NetworkError.invalidRequest
        }
        
        let (data, response) = try await urlSession.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.responseError(statusCode: -1)
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return try parser.json(data: data)
        case 400...499:
            throw NetworkError.clientError(statusCode: httpResponse.statusCode)
        case 500...599:
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        default:
            throw NetworkError.unexpectedStatusCode(statusCode: httpResponse.statusCode)
        }
    }
    
    func requestGraphQL<T: Decodable>(_ endpoint: Endpoint, query: String, variables: [String: Any]?) async throws -> T {
        guard var request = endpoint.request() else {
            throw NetworkError.invalidRequest
        }
        
        let body: [String: Any] = [
            "query": query,
            "variables": variables ?? [:]
        ]
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        let (data, response) = try await urlSession.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.responseError(statusCode: -1)
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return try parser.json(data: data)
        case 400...499:
            throw NetworkError.clientError(statusCode: httpResponse.statusCode)
        case 500...599:
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        default:
            throw NetworkError.unexpectedStatusCode(statusCode: httpResponse.statusCode)
        }
    }
}




// MARK: - Endpoint
public protocol Endpoint {
    func request() -> URLRequest?
}
