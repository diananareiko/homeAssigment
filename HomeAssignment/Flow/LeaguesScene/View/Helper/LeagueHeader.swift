struct LeagueHeader: View {
    let league: LeagueItem
    @Binding var expandedLeague: Int?
    
    var body: some View {
        Button(action: {
            withAnimation {
                expandedLeague = expandedLeague == league.id ? nil : league.id
            }
        }) {
            HStack {
                KFImage(URL(string: league.logo))
                    .resizable()
                    .placeholder { ProgressView() }
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .clipShape(RoundedRectangle(cornerRadius: 5))

                Text(league.name)
                    .font(.headline)
                    .foregroundColor(.primary)

                Spacer()
                Image(systemName: expandedLeague == league.id ? "chevron.up" : "chevron.down")
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
        }
    }
}