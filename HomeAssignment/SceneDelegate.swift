import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appRouter: AppRouter?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }

        let window = UIWindow(windowScene: windowScene)
        let factory = ViewControllerFactory()
        let appRouter = AppRouter(window: window, factory: factory)
    
        self.window = window
        self.appRouter = appRouter
        appRouter.start()
    }
}

