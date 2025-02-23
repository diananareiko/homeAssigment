import UIKit
import Combine

final class StoriesViewController: UICollectionViewController {
    
    // MARK: - Constants
    private enum Constants {
        
        static let closeButtonSize: CGFloat = 30
        static let verticalStackSpacing: CGFloat = 16
        static let topStackSpacing: CGFloat = 8
        static let progressViewHeight: CGFloat = 4
    }
    
    // MARK: - Properties
    
    private let viewModel: StoryViewModel
    private var stories: [StoryEvent] = []
    private var currentIndex: Int = 0
    
    private var storyProgressView: StoryProgressView!
    
    // MARK: - UI Elements
    
    private let closeButton = UIButton(type: .system)
    private let verticalStack: UIStackView = createVerticalStack()
    private let topHorizontalStack: UIStackView = createTopStack()
    private let leftButton = createInteractiveButton()
    private let centerView = createCenterView()
    private let rightButton = createInteractiveButton()
    
    // MARK: - Init
    
    init(viewModel: StoryViewModel) {
        self.viewModel = viewModel
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stories = viewModel.stories
        configureView()

        guard !stories.isEmpty else {
            return
        }
        scrollToStory(at: currentIndex, animated: false)
        startCurrentStory()
    }
}

// MARK: - Private Methods

private extension StoriesViewController {
    
    func configureView() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupCollectionView()
        setupUI()
        storyProgressView = StoryProgressView(storiesCount: stories.count)
        setupProgressView()
        bindViewModel()
    }
    
    func bindViewModel() {
        viewModel.onClose = { [weak self] in
            self?.dismiss(animated: true)
        }
    }
    
    func loadStories() {
        guard !stories.isEmpty else {
            return
        }
        scrollToStory(at: currentIndex, animated: false)
        startCurrentStory()
    }
    
    func setupCollectionView() {
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .black
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(StoryCell.self, forCellWithReuseIdentifier: StoryCell.reuseId)
    }
    
    func setupUI() {
        view.backgroundColor = .black
        setupCloseButton()
        setupInteractiveButtons()
        setupVerticalStack()
    }
    
    func setupCloseButton() {
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .white
        closeButton.addTarget(self, action: #selector(closeStories), for: .touchUpInside)
    }
    
    func setupVerticalStack() {
        topHorizontalStack.addArrangedSubview(UIView())
        topHorizontalStack.addArrangedSubview(closeButton)
        verticalStack.addArrangedSubview(topHorizontalStack)
        view.addSubview(verticalStack)
        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.verticalStackSpacing),
            verticalStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.verticalStackSpacing),
            verticalStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.verticalStackSpacing),
            closeButton.widthAnchor.constraint(equalToConstant: Constants.closeButtonSize),
            closeButton.heightAnchor.constraint(equalToConstant: Constants.closeButtonSize)
        ])
    }
    
    func setupProgressView() {
        storyProgressView = StoryProgressView(storiesCount: stories.count)
        verticalStack.addArrangedSubview(storyProgressView)
        storyProgressView.heightAnchor.constraint(equalToConstant: Constants.progressViewHeight).isActive = true
    }
    
    func setupInteractiveButtons() {
        [leftButton, centerView, rightButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        NSLayoutConstraint.activate([
            leftButton.topAnchor.constraint(equalTo: view.topAnchor),
            leftButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            leftButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            leftButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3),
            centerView.topAnchor.constraint(equalTo: view.topAnchor),
            centerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            centerView.leadingAnchor.constraint(equalTo: leftButton.trailingAnchor),
            centerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3),
            rightButton.topAnchor.constraint(equalTo: view.topAnchor),
            rightButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            rightButton.leadingAnchor.constraint(equalTo: centerView.trailingAnchor),
            rightButton.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        leftButton.addTarget(self, action: #selector(didTapLeft), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(didTapRight), for: .touchUpInside)
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        centerView.addGestureRecognizer(longPress)
    }
    
    @objc
    func didTapLeft() {
        showPreviousStory()
    }
    
    @objc
    func didTapRight() {
        showNextStory()
    }
    
    @objc
    func handleLongPress(_ recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
        case .began:
            pauseCurrentStory()
        case .ended, .cancelled, .failed:
            resumeCurrentStory()
        default:
            break
        }
    }
    
    @objc
    func closeStories() {
        viewModel.onClose?()
    }
    
    func pauseCurrentStory() {
        if let cell = currentStoryCell() {
            cell.pauseVideo()
        }
    }
    
    func resumeCurrentStory() {
        if let cell = currentStoryCell() {
            cell.playVideo()
        }
    }
    
    func showNextStory() {
        guard currentIndex + 1 < stories.count else {
            closeStories()
            return
        }
        currentIndex += 1
        navigateToStory(at: currentIndex)
    }
    
    func showPreviousStory() {
        guard currentIndex > 0 else { return }
        currentIndex -= 1
        navigateToStory(at: currentIndex)
    }
    
    /// Общий метод для перехода к сториз по индексу
    func navigateToStory(at index: Int) {
        scrollToStory(at: index, animated: false)
        startCurrentStory()
    }
    
    func scrollToStory(at index: Int, animated: Bool) {
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
    }
    
    func startCurrentStory() {
        storyProgressView.resetProgress(currentIndex: currentIndex)
        currentStoryCell()?.restartVideo()
    }
    
    func currentStoryCell() -> StoryCell? {
        collectionView.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as? StoryCell
    }
}

// MARK: - UICollectionViewDataSource

extension StoriesViewController {
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        stories.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: StoryCell.reuseId,
            for: indexPath
        ) as? StoryCell else {
            return UICollectionViewCell()
        }
        
        let story = stories[indexPath.item]
        cell.configure(with: story)
        cell.delegate = self
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension StoriesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.bounds.size
    }
}

// MARK: - StoryCellDelegate

extension StoriesViewController: StoryCellDelegate {
    
    func storyCell(_ cell: StoryCell, didUpdateProgress progress: Double) {
        guard let indexPath = collectionView.indexPath(for: cell),
              indexPath.item == currentIndex
        else {
            return
        }
        storyProgressView.updateProgress(progress, for: currentIndex)
    }
    
    func storyCellDidFinishPlaying(_ cell: StoryCell) {
        showNextStory()
    }
}

// MARK: - Helpers

private extension StoriesViewController {
    
    static func createVerticalStack() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Constants.verticalStackSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
    
    static func createTopStack() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = Constants.topStackSpacing
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
    
    static func createInteractiveButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        return button
    }
    
    static func createCenterView() -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
}
