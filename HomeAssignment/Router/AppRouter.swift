import UIKit
import SwiftUI

protocol AppRouterProtocol {

    func start()
    func navigate(to route: AppRoute)
}

enum AppRoute {

    case root
    case stories(stories: [StoryEvent])
}

class AppRouter: AppRouterProtocol {

    private let window: UIWindow
    private let navigationController: UINavigationController
    private let factory: ViewControllerFactoryProtocol
    
    init(window: UIWindow, factory: ViewControllerFactoryProtocol) {
        self.window = window
        self.navigationController = UINavigationController()
        self.factory = factory
    }
    
    func start() {
        let leaguesViewController = factory.createLeaguesViewController(viewModel: LeaguesViewModel(router: self))
        navigationController.viewControllers = [leaguesViewController]
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func navigate(to route: AppRoute) {
        switch route {
        case .root:
            navigationController.popToRootViewController(animated: true)
        case .stories(let stories):
            let storiesVC = factory.createStoriesViewController(viewModel: StoryViewModel(stories: stories))
            navigationController.present(storiesVC, animated: true)
        }
    }
}
