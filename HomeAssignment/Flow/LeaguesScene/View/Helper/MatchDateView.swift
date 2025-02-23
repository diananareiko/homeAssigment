import SwiftUI

struct MatchDateView: View {
    let date: Date

    private enum Constants {

        static let textColor = Color.gray
        static let font = Font.caption
        static let alignment: Alignment = .trailing
    }

    var body: some View {
        HStack {
            Text(date, format: .dateTime)
                .font(Constants.font)
                .foregroundColor(Constants.textColor)
                .frame(maxWidth: .infinity, alignment: Constants.alignment)
        }
    }
}

