import Foundation


// MARK: - NetworkingProtocol
protocol NetworkingProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
    func requestGraphQL<T: Decodable>(_ endpoint: Endpoint, query: String, variables: [String: Any]?) async throws -> T
}

class Networking: NetworkingProtocol {
    private let urlSession: URLSession
    private let parser: Parser
    
    init(urlSession: URLSession = .shared, parser: Parser = Parser()) {
        self.urlSession = urlSession
        self.parser = parser
    }
    
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
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
protocol Endpoint {
    func request() -> URLRequest?
}
