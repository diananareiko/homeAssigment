struct LeagueItem: Identifiable {
    let id: Int
    let name: String
    let logo: String
    let matches: [LeagueMatch]
}
