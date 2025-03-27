//
//  MockTests.swift
//  Networking
//
//  Created by Daniel K. Wester on 3/26/25.
//

import Testing
import Foundation
@testable import Networking

struct MockUrlSession: URLSessionProtocol {
    let data: Data
    
    init(_ str: String) {
        self.data = str.data(using: .utf8)!
    }
    
    init (_ data: Data) {
        self.data = data
    }
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        // just mock a successful call for now
        let urlResponse = HTTPURLResponse()
        return (data, urlResponse)
    }
    
    func invalidateAndCancel() { }
}


@Test
func mockAsyncRequestAlbums() async throws {
    let dataString = """
[{"album_id":1,"title":"1989","artist_id":1,"release_date":"2014-10-27"},
{"album_id":2,"title":"Taylor Swift","artist_id":1,"release_date":"2006-10-24"},
{"album_id":3,"title":"Fearless","artist_id":1,"release_date":"2021-04-09"}]
"""
    
    let requestor: AsyncRequestProtocol = AsyncRequest(urlSession: MockUrlSession(dataString))
    
    // Should this pass? TSwift has hardcoded query params
    let response = try await requestor.perform(request: TSwiftRequestModel.getAlbums(), decodeTo: [Album].self)
    #expect(response.isEmpty == false)
    let album = response.first(where: { $0.title == "1989" } )
    #expect(album != nil)
}
