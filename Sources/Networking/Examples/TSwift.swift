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

