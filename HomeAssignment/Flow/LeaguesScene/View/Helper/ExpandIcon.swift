struct ExpandIcon: View {
    let isExpanded: Bool
    
    private enum Constants {
        static let iconColor = Color.gray
        static let animationDuration = 0.2
        static let rotationAngle: Double = 180
    }
    
    var body: some View {
        Image(systemName: iconName)
            .foregroundColor(Constants.iconColor)
            .rotationEffect(.degrees(rotation))
            .animation(.easeInOut(duration: Constants.animationDuration), value: isExpanded)
    }
    
    private var iconName: String {
        isExpanded ? "chevron.up" : "chevron.down"
    }
    
    private var rotation: Double {
        isExpanded ? Constants.rotationAngle : 0
    }
}