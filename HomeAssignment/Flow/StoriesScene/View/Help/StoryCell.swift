import UIKit
import AVFoundation

final class StoryCell: UICollectionViewCell {
    
    static let reuseId = Constants.reuseIdentifier
    
    private var videoPlayerManager: VideoPlayerManager?
    weak var delegate: StoryCellDelegate?
    
    private enum Constants {

        static let reuseIdentifier = "StoryCell"
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        videoPlayerManager?.removeObservers()
        videoPlayerManager = nil
    }
    
    func configure(with story: StoryEvent) {
        videoPlayerManager = VideoPlayerManager(delegate: self, frame: bounds, videoUrl: story.videoUrl)
        if let playerLayer = videoPlayerManager?.playerLayer {
            layer.addSublayer(playerLayer)
        }
    }
    
    func pauseVideo() {
        videoPlayerManager?.pause()
    }
    
    func playVideo() {
        videoPlayerManager?.play()
    }
    
    func restartVideo() {
        videoPlayerManager?.restart()
    }
}

// MARK: - VideoPlayerManagerDelegate

extension StoryCell: VideoPlayerManagerDelegate {

    func videoDidFinishPlaying() {
        delegate?.storyCellDidFinishPlaying(self)
    }
    
    func videoProgressUpdated(progress: Double) {
        delegate?.storyCell(self, didUpdateProgress: progress)
    }
}
