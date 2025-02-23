import UIKit
import Combine

import UIKit
import Combine

final class StoryProgressView: UIView {

    private enum Constants {
        static let stackViewSpacing: CGFloat = 5.0
        static let trackTintColorAlpha: CGFloat = 0.3
        static let progressInitial: Float = 0.0
        static let progressFull: Float = 1.0
    }
    
    private let stackView = UIStackView()
    private var progressViews: [UIProgressView] = []
    private let storiesCount: Int
    
    init(storiesCount: Int) {
        self.storiesCount = storiesCount
        super.init(frame: .zero)
        setupUI()
        setupProgressViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func resetProgress(currentIndex: Int) {
        for (i, bar) in progressViews.enumerated() {
            if i < currentIndex {
                bar.setProgress(Constants.progressFull, animated: false)
            } else {
                bar.setProgress(Constants.progressInitial, animated: false)
            }
        }
    }
    
    func updateProgress(_ progress: Double, for index: Int) {
        if index >= 0 && index < progressViews.count {
            progressViews[index].setProgress(Float(progress), animated: false)
        }
    }

    private func setupUI() {
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = Constants.stackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupProgressViews() {
        for _ in 0..<storiesCount {
            let bar = UIProgressView(progressViewStyle: .default)
            bar.trackTintColor = UIColor(white: 1.0, alpha: Constants.trackTintColorAlpha)
            bar.progressTintColor = .white
            bar.progress = Constants.progressInitial
            progressViews.append(bar)
            stackView.addArrangedSubview(bar)
        }
    }
}
