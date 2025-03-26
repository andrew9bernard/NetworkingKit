//
//  HTTPParameter.swift
//  Networking
//
//  Created by Andrew Bernard on 3/26/25.
//


import Foundation

public struct HTTPParameter: Equatable {
    let key: String
    let value: String

    public init(key: String, value: String) {
        self.key = key
        self.value = value
    }
}