import Foundation

struct LeagueMatch: Identifiable, Codable {

    let id: String 
    let team1: Team
    let team2: Team
    let score: String?
    let time: Date
    let isLive: Bool
    let primeStory: PrimeStory?
}
