//
//  HeaderName.swift
//  Networking
//
//  Created by Andrew Bernard on 3/23/25.
//
import Foundation

public struct HeaderName: Sendable {
    public var rawValue: String
    
    public static let userAgent: HeaderName = "User-Agent"
    public static let cookie: HeaderName = "Cookie"
    public static let authorization: HeaderName = "Authorization"
    public static let accept: HeaderName = "Accept"
    public static let contentLength: HeaderName = "Content-Length"
    
    public static let contentType = ContentType.header
}

extension HeaderName: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.init(rawValue: value)
    }
}
