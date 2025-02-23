import SwiftUI

protocol ViewControllerFactoryProtocol {

    func createLeaguesViewController(viewModel: LeaguesViewModel) -> UIHostingController<AnyView>
    func createStoriesViewController(viewModel: StoryViewModel) -> StoriesViewController
}

class ViewControllerFactory: ViewControllerFactoryProtocol {

    func createLeaguesViewController(viewModel: LeaguesViewModel) -> UIHostingController<AnyView> {
        let swiftUIView = AnyView(LeaguesView().environmentObject(viewModel))
        let hostingController = UIHostingController(rootView: swiftUIView)
        return hostingController
    }
    
    func createStoriesViewController(viewModel: StoryViewModel) -> StoriesViewController {
        let storiesVC = StoriesViewController(viewModel: viewModel)
        return storiesVC
    }
}
