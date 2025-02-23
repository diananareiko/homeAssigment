import SwiftUI

struct LeagueTitle: View {
    let name: String
    
    var body: some View {
        Text(name)
            .font(.headline)
            .foregroundColor(.primary)
            .lineLimit(1)
            .truncationMode(.tail)
    }
}
