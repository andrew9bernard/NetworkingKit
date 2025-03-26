//
//  TSwift.swift
//  Networking
//
//  Created by Andrew Bernard on 3/24/25.
//
import Foundation

struct TSwift {
    static func getRequest(auth: String) -> Request {
        
            let urlRequest = RequestBuilder()
                .setHttpMethod(.get)
                .setBaseUrl("https://taylor-swift-api.sarbo.workers.dev/albums")
                .setTimeoutInterval(60)
                .setHeaders([
                    .contentType(.json),
                    .authorization(.bearer(auth))
                ])
                .build()
            return urlRequest
        }
}

struct Album: Codable {
    let albumId: Int
    let title: String
    let releaseDate: String
    
    enum CodingKeys: String, CodingKey {
        case albumId = "album_id"
        case title
        case releaseDate = "release_date"
    }
}

struct TSwiftGrapgQL {
    
    static func getRequest(auth: String) -> Request {
        
        let query = """
                query GetUser($id: ID!) {
                    user(id: $id) {
                        id
                        name
                        email
                    }
                }
            """
        
        let variables = ["id": AnyCodable("12345")]
        
        let queryPayload = QueryPayload(
            query: query,
            variables: variables
        )
        
        let urlRequest = RequestBuilder()
            .setHttpMethod(.get)
            .setBaseUrl("https://taylor-swift-api.sarbo.workers.dev/albums")
            .setTimeoutInterval(60)
            .setHeaders([
                .contentType(.json),
                .authorization(.bearer(auth))
            ])
            .setBody(.graphQL(_queryPayload: queryPayload))
            .build()
        return urlRequest
    }
}

//[
//  {
//    "album_id": 1,
//    "title": "1989",
//    "release_date": "2014-10-27"
//  },
//  {
//    "album_id": 2,
//    "title": "Taylor Swift",
//    "release_date": "2006-10-24"
//  },
//  ...
//]


// MARK: - ViewModel
@MainActor
class ExampleViewModel: ObservableObject {
    private let networking: AsyncRequestProtocol
    
    init(networking: AsyncRequestProtocol = AsyncRequest()) {
        self.networking = networking
    }
    
    func fetchData() {
    
        // Use detached to avoid capturing self in a non-sendable context
        Task.detached(priority: .background) {
            try await self.performRequest()
        }
    }
    
    private func performRequest() async throws {
        do {
            let request = TSwift.getRequest(auth: "12345")
            _ = try await networking.perform(request: request, decodeTo: [Album].self)
           
        } catch {
            throw error
        }
        
        do {
            let request = TSwiftGrapgQL.getRequest(auth: "1234")
            _ = try await networking.perform(request: request, decodeTo: [Album].self)
        } catch {
            throw error
        }
    }
}
