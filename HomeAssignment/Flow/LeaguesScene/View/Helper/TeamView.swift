import SwiftUI
import Kingfisher

struct TeamView: View {
    let team: Team

    var body: some View {
        VStack {
            Logo(url: team.logo)
            Text(team.name)
                .font(.headline)
                .bold()
                .multilineTextAlignment(.center)
        }
    }
}

