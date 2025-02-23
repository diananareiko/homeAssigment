import UIKit
import AVFoundation

class StoryCell: UICollectionViewCell {
    
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    weak var delegate: StoryViewControllerDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with story: StoryEvent) {
        setupVideoPlayer(with: story.videoUrl)
    }

    private func setupVideoPlayer(with urlString: String) {
        guard let url = URL(string: urlString) else { return }

        player?.pause()
        playerLayer?.removeFromSuperlayer()

        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = bounds
        playerLayer?.videoGravity = .resizeAspectFill
        if let playerLayer = playerLayer {
            layer.addSublayer(playerLayer)
        }

        NotificationCenter.default.addObserver(self, selector: #selector(videoDidFinish), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)

        player?.play()
    }

    @objc private func videoDidFinish() {
        delegate?.storyDidFinishPlaying(self)
    }

    func restartVideo() {
        player?.seek(to: .zero)
        player?.play()
    }
}
