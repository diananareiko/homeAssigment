//
//  VideoPlayerManagerDelegate.swift
//  HomeAssignment
//
//  Created by Nareyko, Diana on 23.02.25.
//


protocol VideoPlayerManagerDelegate: AnyObject {
    func videoDidFinishPlaying()
    func videoProgressUpdated(progress: Double)
}

final class VideoPlayerManager {
    
    weak var delegate: VideoPlayerManagerDelegate?
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var timeObserver: Any?
    
    var playerLayerInstance: AVPlayerLayer? {
        return playerLayer
    }
    
    init(delegate: VideoPlayerManagerDelegate, frame: CGRect, videoUrl: String) {
        self.delegate = delegate
        setupVideoPlayer(with: videoUrl, frame: frame)
    }
    
    func play() {
        player?.play()
    }
    
    func pause() {
        player?.pause()
    }
    
    func restart() {
        player?.seek(to: .zero)
        player?.play()
    }
    
    func removeObservers() {
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupVideoPlayer(with urlString: String, frame: CGRect) {
        guard let url = URL(string: urlString) else { return }
        
        removeObservers()
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = frame
        playerLayer?.videoGravity = .resizeAspectFill
        
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidFinish), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        
        timeObserver = player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: Constants.timeUpdateInterval, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: .main) { [weak self] currentTime in
            self?.updateProgress(currentTime: currentTime)
        }
        
        player?.play()
    }
    
    @objc private func videoDidFinish() {
        delegate?.videoDidFinishPlaying()
    }
    
    private func updateProgress(currentTime: CMTime) {
        guard let player = player, let item = player.currentItem else { return }
        let duration = item.duration.seconds
        if duration > 0 {
            let progress = currentTime.seconds / duration
            delegate?.videoProgressUpdated(progress: progress)
        }
    }
}