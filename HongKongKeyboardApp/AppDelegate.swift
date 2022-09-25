import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_: UIApplication,
                     didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession,
                     options _: UIScene.ConnectionOptions) -> UISceneConfiguration
    {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
