import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let response: [Response]
}

// MARK: - Response
struct Response: Codable {
    let wscGameID: String
    let score: Score
    let teams: Teams
    let goals: Goals
    let league: League
    let fixture: Fixture
    var wscGame: WscGame?
    let storifyMeHandle: String?
    let storifyMeID: Int?

    enum CodingKeys: String, CodingKey {
        case wscGameID = "WSCGameId"
        case score, teams, goals, league, fixture, wscGame, storifyMeHandle, storifyMeID
    }
}

// MARK: - Fixture
struct Fixture: Codable {
    let timezone: Timezone
    let periods: Periods
    let timestamp: Int
    let status: Status
    let date: Date
    let venue: Venue
    let id: Int
    let referee: String?

    enum CodingKeys: String, CodingKey {
        case timezone, periods, timestamp, status, date, venue, id, referee
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.timezone = try container.decode(Timezone.self, forKey: .timezone)
        self.periods = try container.decode(Periods.self, forKey: .periods)
        self.timestamp = try container.decode(Int.self, forKey: .timestamp)
        self.status = try container.decode(Status.self, forKey: .status)
        self.id = try container.decode(Int.self, forKey: .id)
        self.referee = try container.decodeIfPresent(String.self, forKey: .referee)
        self.venue = try container.decode(Venue.self, forKey: .venue)

        // Декодирование даты вручную
        let dateString = try container.decode(String.self, forKey: .date)
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        guard let parsedDate = formatter.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(forKey: .date,
                                                   in: container,
                                                   debugDescription: "Invalid date format: \(dateString)")
        }
        self.date = parsedDate
    }
}

// MARK: - Periods
struct Periods: Codable {
    let second, first: Int?
}

// MARK: - Status
struct Status: Codable {
    let long: Long
    let short: Short
    let elapsed: Int?
}

enum Long: String, Codable {
    case notStarted = "Not Started"
}

enum Short: String, Codable {
    case ns = "NS"
}

enum Timezone: String, Codable {
    case utc = "UTC"
}

// MARK: - Venue
struct Venue: Codable {
    let name: String
    let id: Int
    let city: String
}

// MARK: - Teams
struct Teams: Codable {
    let home, away: Team
}

// MARK: - Team
struct Team: Codable {
    let name: String
    let logo: String
    let id: Int
    let winner: Bool?
}

// MARK: - Goals
struct Goals: Codable {
    let home, away: Int?
}

// MARK: - League
struct League: Codable {
    let logo: String
    let season: Int
    let country: Country
    let round: String
    let id: Int
    let flag: String
    let name: Name
}

enum Country: String, Codable {
    case england = "England"
    case germany = "Germany"
    case israel = "Israel"
    case italy = "Italy"
    case spain = "Spain"
}

enum Name: String, Codable {
    case bundesliga = "Bundesliga"
    case copaDelRey = "Copa del Rey"
    case coppaItalia = "Coppa Italia"
    case faCup = "FA Cup"
    case laLiga = "La Liga"
    case ligatHaAl = "Ligat Ha'al"
    case premierLeague = "Premier League"
    case serieA = "Serie A"
}

// MARK: - Score
struct Score: Codable {
    let fulltime, halftime, extratime, penalty: Goals
}

// MARK: - WscGame
struct WscGame: Codable {
    let awayTeamName: String
    let primeStory: PrimeStory?
    let name, gameID, homeTeamName, gameTime: String
    
    var finalScoreHome: Int?
    var finalScoreAway: Int?

    enum CodingKeys: String, CodingKey {
        case awayTeamName, primeStory, name
        case gameID = "gameId"
        case homeTeamName, gameTime
    }
}

// MARK: - PrimeStory
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

// MARK: - Page
struct Page: Codable {
    let duration: Int
    let paggeID: String
    let videoURL: String
    let title: String?
    let awayScore: Int?
    let eventType: EventType?
    let gameClock: String?
    let homeScore: Int?
    let rating: Int
    let period: String?
    let actionType: ActionType?

    enum CodingKeys: String, CodingKey {
        case duration
        case paggeID = "paggeId"
        case videoURL = "videoUrl"
        case title, awayScore, eventType, gameClock, homeScore, rating, period, actionType
    }
}

enum ActionType: String, Codable {
    case booking = "Booking"
    case defensiveact = "Defensiveact"
    case disqualifiedGoal = "DisqualifiedGoal"
    case gkSave = "GKSave"
    case kickOff = "KickOff"
    case replay = "Replay"
    case shortGoal = "ShortGoal"
    case shot = "Shot"
    case varDecision = "VARDecision"
}

enum EventType: String, Codable {
    case playByPlay = "PlayByPlay"
}
