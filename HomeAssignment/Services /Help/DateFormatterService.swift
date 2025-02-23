import Foundation

struct DateFormatterService {
    private enum Constants {
        static let inputFormat = "yyyy-MM-dd HH:mm:ss" // Формат входящей строки
        static let locale = Locale(identifier: "en_US_POSIX")
    }
    
    static func parseDate(from string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.inputFormat
        formatter.locale = Constants.locale
        return formatter.date(from: string)
    }

    static func formatDate(_ date: Date, format: Date.FormatStyle = .dateTime.day().month().year()) -> String {
        return date.formatted(format)
    }
}
