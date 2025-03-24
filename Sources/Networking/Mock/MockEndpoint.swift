//
//  MockEndpoint.swift
//  Networking
//
//  Created by Andrew Bernard on 3/23/25.
//
import Foundation

// MARK: - Mock Endpoint

protocol MockEndpoint: Endpoint {
    var mockFilename: String? { get }
    var mockExtension: String? { get }
}

extension MockEndpoint {
    func mockData() -> Data? {
        guard let mockFileUrl = Bundle.main.url(forResource: mockFilename, withExtension: mockExtension),
              let mockData = try? Data(contentsOf: mockFileUrl) else {
            return nil
        }
        return mockData
    }
    
    var mockExtension: String? {
        return "json"
    }
}


// MARK: - UserEndpoint
//
//enum UserEndpoint {
//    case all
//    case get(userId: Int)
//}
//
//extension UserEndpoint: Endpoint {
//    var scheme: String {
//        return ""
//    }
//
//    var host: String {
//        return ""
//    }
//
//    var request: URLRequest? {
//        switch self {
//        case .all:
//            return request(forEndpoint: "/users")
//        case .get(let userId):
//            return request(forEndpoint: "/users/\(userId)")
//        }
//    }
//
//    var httpMethod: String { "GET" }
//
//    var queryItems: [URLQueryItem]? {
//        switch self {
//        case .all:
//            return nil
//        case .get(let userId):
//            return [URLQueryItem(name: "userId", value: String(userId))]
//        }
//    }
//
//    var httpHeaders: [String: String]? {
//        return ["Content-Type": "application/json"]
//    }
//}
//
//extension UserEndpoint: MockEndpoint {
//    var mockFilename: String? {
//        switch self {
//        case .all:
//            return "users"
//        case .get:
//            return "user"
//        }
//    }
//}
//
//// MARK: - Models
//
//struct User: Codable {
//    let id: Int
//    let username: String
//    let email: String
//}

// MARK: - Usage Example
//
//task {
//    let networking = Networking()
//    let mockNetworking = MockNetworking()
//
//    do {
//        let users: [User] = try await networking.request(UserEndpoint.all)
//        print(users)
//
//        let user: User = try await networking.request(UserEndpoint.get(userId: 10))
//        print(user)
//
//        let mockUser: User = try await mockNetworking.request(UserEndpoint.get(userId: 10))
//        print(mockUser)
//
//        let mockUsers: [User] = try await mockNetworking.request(UserEndpoint.all)
//        print(mockUsers)
//
//    } catch {
//        print("Error: \(error)")
//    }
//}
