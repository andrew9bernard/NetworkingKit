//
//  HTTPInformationalStatus.swift
//  Networking
//
//  Created by Andrew Bernard on 3/24/25.
//


import Foundation

public enum HTTPInformationalStatus: Int, Error {
    case continueStatus = 100
    case switchingProtocols = 101
    case processing = 102
    case unknown = -1

    public init(statusCode: Int) {
        if let error = HTTPInformationalStatus(rawValue: statusCode) {
            self = error
        } else {
            self = .unknown
        }
    }
    
    public var description: String { return "\(self)" }
    public var statusCode: Int { return self.rawValue }
}
