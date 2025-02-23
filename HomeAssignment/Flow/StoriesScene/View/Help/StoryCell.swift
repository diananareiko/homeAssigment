import UIKit
import AVFoundation

protocol StoryCellDelegate: AnyObject {

    func storyCell(_ cell: StoryCell, didUpdateProgress progress: Double)
    func storyCellDidFinishPlaying(_ cell: StoryCell)
}

class StoryCell: UICollectionViewCell {

    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var timeObserver: Any?
    
    static let reuseId = "StoryCell"
    weak var delegate: StoryCellDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        removePlayerObserver()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        removePlayerObserver()
        player?.pause()
        playerLayer?.removeFromSuperlayer()
        player = nil
        playerLayer = nil
    }

    func configure(with story: StoryEvent) {
        setupVideoPlayer(with: story.videoUrl)
    }

    func pauseVideo() {
        player?.pause()
    }

    func playVideo() {
        player?.play()
    }

    func restartVideo() {
        player?.seek(to: .zero)
        player?.play()
    }

    private func setupVideoPlayer(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        removePlayerObserver()
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = bounds
        playerLayer?.videoGravity = .resizeAspectFill
        if let layer = playerLayer {
            self.layer.addSublayer(layer)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidFinish), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        timeObserver = player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: .main) { [weak self] currentTime in
            self?.updateProgress(currentTime: currentTime)
        }
        player?.play()
    }

    @objc private func videoDidFinish() {
        delegate?.storyCellDidFinishPlaying(self)
    }

    private func updateProgress(currentTime: CMTime) {
        guard let p = player, let item = p.currentItem else { return }
        let duration = item.duration.seconds
        if duration > 0 {
            let progress = currentTime.seconds / duration
            delegate?.storyCell(self, didUpdateProgress: progress)
        }
    }

    private func removePlayerObserver() {
        if let t = timeObserver {
            player?.removeTimeObserver(t)
            timeObserver = nil
        }
        NotificationCenter.default.removeObserver(self)
    }
}
