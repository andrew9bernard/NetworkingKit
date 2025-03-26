//
//  TSwift.swift
//  Networking
//
//  Created by Andrew Bernard on 3/24/25.
//
import Foundation

struct TSwift: RequestModel {
    func  getRequest(auth: String) -> Request {
        
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

//let queryPayload = QueryPayload(
//    query: """
//        query GetUser($id: ID!) {
//            user(id: $id) {
//                id
//                name
//                email
//            }
//        }
//    """,
//    variables: ["id": AnyCodable("12345")]
//)
//
//let requestBuilder = URLRequestBuilder(path: "/graphql")
//let graphQLRequest = try requestBuilder.graphQLRequestBody(queryPayload)
//
//let baseURL = URL(string: "https://api.example.com")!
//let urlRequest = graphQLRequest.makeRequest(withBaseURL: baseURL)
//
//print(urlRequest)

//or

//let requestBuilder = URLRequestBuilder(path: "/graphql")
//let graphQLRequest = try requestBuilder.graphQLQuery(
//    "query { user(id: \"123\") { name } }"
//)
//
//let urlRequest = graphQLRequest.makeRequest(withBaseURL: baseURL)
//print(urlRequest)



// MARK: - ViewModel
@MainActor
class ExampleViewModel: ObservableObject {
    private let networking: AsyncRequestProtocol
    
    @Published var data: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    init(networking: AsyncRequestProtocol = AsyncRequest()) {
        self.networking = networking
    }
    
    func fetchData() {
        isLoading = true
        errorMessage = nil

        // Use detached to avoid capturing self in a non-sendable context
        Task.detached(priority: .background) {
            await self.performRequest()
        }
    }
    
    private func performRequest() async {
        defer { Task { @MainActor in self.isLoading = false } }

        do {
            let request = TSwift().getRequest(auth: "AuthorizationKey12334445")
            let result = try await networking.perform(request: request, decodeTo: [Album].self)
           
        } catch {
            Task { @MainActor in self.errorMessage = error.localizedDescription }
        }
    }
}
