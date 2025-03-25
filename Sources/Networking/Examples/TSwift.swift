//
//  TSwift.swift
//  Networking
//
//  Created by Andrew Bernard on 3/24/25.
//
import Foundation

struct TSwift: Endpoint {
    func request() -> URLRequest? {
        guard let baseURL = URL(string: "https://taylor-swift-api.sarbo.workers.dev") else { return nil }
        let urlRequest =  EndpointRequest(path: "albums")
            .method(.get)
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
            let urlRequest =  try EndpointRequest(path: "index")
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
