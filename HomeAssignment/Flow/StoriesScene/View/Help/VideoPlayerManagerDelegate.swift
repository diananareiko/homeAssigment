protocol VideoPlayerManagerDelegate: AnyObject {
    func videoDidFinishPlaying()
    func videoProgressUpdated(progress: Double)
}