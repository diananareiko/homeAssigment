struct TeamView: View {
    let team: Team

    var body: some View {
        VStack {
            KFImage(URL(string: team.logo))
                .resizable()
                .scaledToFit()
                .frame(width: Constants.logoSize, height: Constants.logoSize)
            Text(team.name)
                .font(.headline)
                .bold()
                .multilineTextAlignment(.center)
        }
    }
}