import UIKit
import Combine

final class StoryPageViewController: UICollectionViewController {
    
    // MARK: - Properties

    private let viewModel: StoryViewModel
    private var stories: [StoryEvent] = []
    private var currentIndex: Int = 0
    
    private var storyProgressView: StoryProgressView!

    // MARK: - UI Elements
    
    private let closeButton = UIButton(type: .system)

    private let verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let topHorizontalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let leftButton: UIButton = {
        let b = UIButton(type: .custom)
        b.backgroundColor = .clear
        return b
    }()
    
    private let centerView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        return v
    }()
    
    private let rightButton: UIButton = {
        let b = UIButton(type: .custom)
        b.backgroundColor = .clear
        return b
    }()

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
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupCollectionView()
        setupUI()
        stories = viewModel.stories
        storyProgressView = StoryProgressView(storiesCount: stories.count)
        setupProgressView()

        // Привязываем коллбек закрытия
        bindViewModel()
        
        guard !stories.isEmpty else { return }
        
        scrollToStory(at: currentIndex, animated: false)
        startCurrentStory()
    }
}

// MARK: - Private Methods

private extension StoryPageViewController {
    
    func bindViewModel() {
        viewModel.onClose = { [weak self] in
            self?.dismiss(animated: true)
        }
    }
    
    func setupCollectionView() {
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .black
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(StoryCell.self, forCellWithReuseIdentifier: StoryCell.reuseId)
    }
    
    func setupUI() {
        view.backgroundColor = .black
        
        setupInteractiveButtons()
        
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .white
        closeButton.addTarget(self, action: #selector(closeStories), for: .touchUpInside)
        
        topHorizontalStack.addArrangedSubview(UIView()) // пустой вью для выравнивания
        topHorizontalStack.addArrangedSubview(closeButton)
        
        verticalStack.addArrangedSubview(topHorizontalStack)
        
        view.addSubview(verticalStack)
        
        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            verticalStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            verticalStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func setupProgressView() {
        verticalStack.addArrangedSubview(storyProgressView)
        storyProgressView.heightAnchor.constraint(equalToConstant: 4).isActive = true
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

extension StoryPageViewController {
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

extension StoryPageViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.bounds.size
    }
}

// MARK: - StoryCellDelegate

extension StoryPageViewController: StoryCellDelegate {
    
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



