
struct TSwiftSong: Codable {
    let songId: Int
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case songId = "song_id"
        case title
    }
}


struct TSwiftLyrics: Codable {
    let songId: Int
    let title: String
    let lyrics: String
    
    enum CodingKeys: String, CodingKey {
        case songId = "song_id"
        case title = "song_title"
        case lyrics
    }
}
