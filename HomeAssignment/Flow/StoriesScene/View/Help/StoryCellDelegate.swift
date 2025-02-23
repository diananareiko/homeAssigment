protocol StoryCellDelegate: AnyObject {

    func storyCell(_ cell: StoryCell, didUpdateProgress progress: Double)
    func storyCellDidFinishPlaying(_ cell: StoryCell)
}
