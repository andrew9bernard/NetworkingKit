
import Networking

struct BadRequest {
    func getRequest(auth: String) -> any Networking.Request {
        return RequestBuilder().build()
    }
}


struct TSwiftRequestModel {
    private static let baseTSwiftUrl = "https://taylor-swift-api.sarbo.workers.dev"
    
    static func getAlbums() -> Request {
        return RequestBuilder()
            .setHttpMethod(.get)
            .setBaseUrl("\(baseTSwiftUrl)/albums")
            .setTimeoutInterval(60)
            .setHeaders([
                .contentType(.json),
                .accept(.json)
            ])
            .build()
    }
    
    static func getAlbumSongs(albumId: Int) -> any Networking.Request {
        return RequestBuilder()
            .setHttpMethod(.get)
            .setBaseUrl("\(baseTSwiftUrl)/albums/\(albumId)")
            .setTimeoutInterval(60)
            .setHeaders([
                .contentType(.json),
                .accept(.json)
            ])
            .build()
    }
    
    static func getLyrics(songId: Int) -> any Networking.Request {
        return RequestBuilder()
            .setHttpMethod(.get)
            .setBaseUrl("\(baseTSwiftUrl)/lyrics/\(songId)")
            .setTimeoutInterval(60)
            .setHeaders([
                .contentType(.json),
                .accept(.json)
            ])
            .build()
    }
}
