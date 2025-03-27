import Testing
import Foundation
@testable import Networking



@Test("This should be a bad request.")
func asyncRequestBadRequest() async {
    let requestor: AsyncRequestProtocol = AsyncRequest()
    
    do {
        let _ = try await requestor.perform(request: BadRequest().getRequest(auth: ""))
        #expect(Bool(false))
    }
    catch {
        #expect(Bool(true))
    }
}

@Test("This should succeed but be an empty response.")
func asyncRequestNoResponseAlbums() async throws {
    let requestor: AsyncRequestProtocol = AsyncRequest()
    let response: () = try await requestor.perform(request: TSwiftRequestModel.getAlbums())
    #expect(response == ())
}

@Test
func asyncRequestAlbums() async throws {
    let requestor: AsyncRequestProtocol = AsyncRequest()
    
    // Should this pass? TSwift has hardcoded query params
    let response = try await requestor.perform(request: TSwiftRequestModel.getAlbums(), decodeTo: [Album].self)
    #expect(response.isEmpty == false)
    let album = response.first(where: { $0.title == "1989" } )
    #expect(album != nil)
}

@Test("Test how the album songs lookup flow will work.",
      arguments: [Album(albumId: 1, title: "1989", releaseDate: "2014-10-27")])
func asyncRequestAlbumSongs(album: Album) async throws {
    let requestor: AsyncRequestProtocol = AsyncRequest()
    
    let response = try await requestor.perform(request: TSwiftRequestModel.getAlbumSongs(albumId: album.albumId), decodeTo: [TSwiftSong].self)
    #expect(response.isEmpty == false)
    let song = response.first(where: { $0.title == "Wonderland" } )
    #expect(song != nil)
}

@Test("Test how the lyrics lookup flow will work.",
      arguments: [TSwiftSong(songId: 10, title: "Wonderland")])
func asyncRequestDecodeLyrics(song: TSwiftSong) async throws {
    let requestor: AsyncRequestProtocol = AsyncRequest()
    
    let response = try await requestor.perform(request: TSwiftRequestModel.getLyrics(songId: song.songId), decodeTo: TSwiftLyrics.self)
    #expect(response.lyrics.isEmpty == false)
}





@Test func graphQlRequest() async throws {
//    let gqRequest = GraphQLRequest()
//    let ts = TSwift()
//
//    let response = try! await asyncRequest.perform(endpoint: ts)
//
//    #expect(true)
}

