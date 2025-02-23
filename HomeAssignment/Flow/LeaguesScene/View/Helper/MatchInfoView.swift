struct MatchInfoView: View {
    let time: Date
    let score: String?
    let isLive: Bool

    var body: some View {
        VStack {
            Text(time, format: .dateTime.hour().minute())
                .font(.subheadline)
                .foregroundColor(Constants.textColor)

            if isLive {
                Text("Started")
                    .font(.subheadline)
                    .foregroundColor(Constants.liveTextColor)
                    .bold()
            }

            Text(score ?? "")
                .font(.title2)
                .bold()
                .foregroundColor(.black)
        }
    }
}