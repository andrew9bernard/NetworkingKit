//
//  ContentType.swift
//  Networking
//
//  Created by Andrew Bernard on 3/23/25.
//
import Foundation

// MARK: Content Type
    public struct ContentType: Sendable {
        public static let header = HeaderName(rawValue: "Content-Type")

        public var rawValue: String

        // MARK: - Application
        public static let applicationJSON = ContentType(rawValue: "application/json")
        public static let applicationOctetStream = ContentType(rawValue: "application/octet-stream")
        public static let applicationXML = ContentType(rawValue: "application/xml")
        public static let applicationZip = ContentType(rawValue: "application/zip")
        public static let applicationXWwwFormUrlEncoded = ContentType(rawValue: "application/x-www-form-urlencoded")

        // MARK: - Image
        public static let imageGIF = ContentType(rawValue: "image/gif")
        public static let imageJPEG = ContentType(rawValue: "image/jpeg")
        public static let imagePNG = ContentType(rawValue: "image/png")
        public static let imageTIFF = ContentType(rawValue: "image/tiff")

        // MARK: - Text
        public static let textCSS = ContentType(rawValue: "text/css")
        public static let textCSV = ContentType(rawValue: "text/csv")
        public static let textHTML = ContentType(rawValue: "text/html")
        public static let textPlain = ContentType(rawValue: "text/plain")
        public static let textXML = ContentType(rawValue: "text/xml")

        // MARK: - Video
        public static let videoMPEG = ContentType(rawValue: "video/mpeg")
        public static let videoMP4 = ContentType(rawValue: "video/mp4")
        public static let videoQuicktime = ContentType(rawValue: "video/quicktime")
        public static let videoXMsWmv = ContentType(rawValue: "video/x-ms-wmv")
        public static let videoXMsVideo = ContentType(rawValue: "video/x-msvideo")
        public static let videoXFlv = ContentType(rawValue: "video/x-flv")
        public static let videoWebm = ContentType(rawValue: "video/webm")

        // MARK: - Multipart Form Data
        public static func multipartFormData(boundary: String) -> ContentType {
            ContentType(rawValue: "multipart/form-data; boundary=\(boundary)")
        }
    }
