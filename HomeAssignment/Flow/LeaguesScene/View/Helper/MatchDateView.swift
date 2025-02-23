struct MatchDateView: View {
    let date: Date

    var body: some View {
        HStack {
            Text(formatDate(date, format: "dd/MM/yyyy"))
                .font(.caption)
                .foregroundColor(Constants.textColor)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}