import Foundation

// MARK: Overrides to see if URLSession can be protocolled for mock
public protocol URLSessionProtocol: Sendable {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
    func invalidateAndCancel()
}

extension URLSession: URLSessionProtocol { }



// MARK: - NetworkingProtocol
public protocol AsyncRequestProtocol: Sendable {
    func perform<T: Codable>(request: Request, decodeTo decodableObject: T.Type) async throws -> T
    func perform(request: Request) async throws
}

public struct AsyncRequest: AsyncRequestProtocol {
    
    private let urlSession: URLSessionProtocol
    private let validator: ResponseValidatorProtocol
    private let requestDecoder: RequestDecodableProtocol
    
    public init(urlSession: URLSessionProtocol = URLSession.shared, validator: ResponseValidatorProtocol = ResponseValidator(), requestDecoder: RequestDecodableProtocol = RequestDecoder()) {
        
        self.urlSession = urlSession
        self.validator = validator
        self.requestDecoder = requestDecoder
    }
    
    
    // MARK: perform request with Async Await and return Decodable using Request Protocol
    public func perform<T: Codable>(request: Request, decodeTo decodableObject: T.Type) async throws -> T {
        return try await performRequest(request: request, decodeTo: decodableObject)
    }
    
//    // MARK: perform request with Async Await using Request protocol
    public func perform(request: Request) async throws {
        try await performRequest(request: request, decodeTo: EmptyResponse.self)
    }
    
    @discardableResult
    private func performRequest<T: Codable>(request: Request, decodeTo decodableObject: T.Type) async throws -> T {
        do {
            guard let request = request.urlRequest else {
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

//// MARK: - RequestModel
//public protocol RequestModel {
//    func request() -> URLRequest?
//}
