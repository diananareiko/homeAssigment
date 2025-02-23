class StoryViewModel {

    private(set) var stories: [StoryEvent]

    var currentIndex: Int = 0 {
        didSet {
            onStoryChanged?(stories[currentIndex])
        }
    }
    
    var onStoryChanged: ((StoryEvent) -> Void)?
    var onClose: (() -> Void)?
    
    init(stories: [StoryEvent]) {
        self.stories = stories
    }
    
    func start() {
        onStoryChanged?(stories[currentIndex])
    }
    
    func nextStory() {
        if currentIndex + 1 < stories.count {
            currentIndex += 1
        } else {
            onClose?()
        }
    }
    
    func previousStory() {
        if currentIndex > 0 {
            currentIndex -= 1
        }
    }
}
