//
//  Method.swift
//  Networking
//
//  Created by Andrew Bernard on 3/23/25.
//
import Foundation

public enum Method: String, Sendable {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case head = "HEAD"
        case delete = "DELETE"
        case patch = "PATCH"
        case options = "OPTIONS"
        case connect = "CONNECT"
        case trace = "TRACE"
    }
