struct PrimeStory: Codable {
    let title: String
    let storyThumbnailSquare: String
    let publishDate: String
    let storyThumbnail: String
    let storyID: String
    let pages: [Page]

    enum CodingKeys: String, CodingKey {
        case title, storyThumbnailSquare, publishDate, storyThumbnail
        case storyID = "storyId"
        case pages
    }
}