import SwiftUI

struct LeagueHeader: View {
    let league: LeagueItem
    @Binding var expandedLeagues: Set<Int> // Используем множество

    var body: some View {
        Button(action: toggleExpansion) {
            HStack {
                Logo(url: league.logo)
                LeagueTitle(name: league.name)
                Spacer()
                ExpandIcon(isExpanded: expandedLeagues.contains(league.id)) // Исправлено
            }
            .padding()
            .background(backgroundStyle)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Private Methods & Styles

private extension LeagueHeader {

    func toggleExpansion() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            if expandedLeagues.contains(league.id) {
                expandedLeagues.remove(league.id)
            } else {
                expandedLeagues.insert(league.id)
            }
        }
    }
    
    var backgroundStyle: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color(.systemBackground))
            .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
    }
}
