struct MatchRow: View {
    let match: LeagueMatch

    var body: some View {
        VStack {
            HStack {
                Text(formatDate(match.time, format: "dd/MM/yyyy"))
                    .font(.caption)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            HStack {
                // 🏆 Логотип и название первой команды
                VStack {
                    KFImage(URL(string: match.team1.logo))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                    Text(match.team1.name)
                        .font(.headline)
                        .bold()
                        .multilineTextAlignment(.center)
                }

                Spacer()
                
                // 🕒 Время
                VStack {
                    Text(formatDate(match.time, format: "HH:mm"))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    if match.isLive {
                        Text("Started")
                            .font(.subheadline)
                            .foregroundColor(.red)
                            .bold()
                    }
                    Text(match.score ?? "")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                VStack {
                    KFImage(URL(string: match.team2.logo))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                    Text(match.team2.name)
                        .font(.headline)
                        .bold()
                        .multilineTextAlignment(.center)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
        .listRowSeparator(.hidden)
    }
}