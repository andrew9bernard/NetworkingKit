//
//  TSwift.swift
//  Networking
//
//  Created by Andrew Bernard on 3/24/25.
//
import Foundation

struct TSwift: RequestModel {
    func request() -> URLRequest? {
        guard let baseURL = URL(string: "https://taylor-swift-api.sarbo.workers.dev") else { return nil }
        let urlRequest =  RequestBuilder(path: "albums")
            .method(.get)
           // .jsonBody(user)
            .contentType(.applicationJSON)
            .accept(.applicationJSON)
            .timeout(60)
            .queryItem(name: "song", value: "bad blood")
          //  .header(name: "Auth-Token", value: authToken)
            .makeRequest(withBaseURL: baseURL)
    
        return urlRequest
    }
    
    
    let query = """
        query GetUser($id: ID!) {
            user(id: $id) {
                id
                name
                email
            }
        }
    """

    let variables: [String: Any] = ["id": "12345"]
    
    func graphQLRequest() throws -> URLRequest? {
        guard let baseURL = URL(string: "https://swapi-graphql.netlify.app/.netlify/functions") else { return nil }
        
        let queryPayload = QueryPayload(
            query: """
                query GetFilms {
                    allFilms {
                        films {
                            title
                            director
                        }
                    }
                }
            """,
            variables: [:]
        )
        do {
            let urlRequest =  try RequestBuilder(path: "index")
                .graphQLRequestBody(queryPayload)
                .makeRequest(withBaseURL: baseURL)
            return urlRequest
        } catch {
            throw NetworkError.graphQLError(error: error)
        }
    
    }
}

struct Album: Decodable {
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
            let result: ExampleResponse = try await networking.perform(request: ExampleEndpoint(), decodeTo: ExampleResponse.self)
            Task { @MainActor in self.data = result.title }
        } catch {
            Task { @MainActor in self.errorMessage = error.localizedDescription }
        }
    }
}

// MARK: - Example Endpoint
struct ExampleEndpoint: RequestModel {
    func request() -> URLRequest? {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1") else { return nil }
        return URLRequest(url: url)
    }
}

// MARK: - Example Response Model
struct ExampleResponse: Codable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}
