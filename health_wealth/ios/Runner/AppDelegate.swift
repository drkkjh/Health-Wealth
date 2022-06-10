import UIKit
import Flutter
import GoogleMaps // external

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    GMSServices.provideAPIKey("AIzaSyAENvCYfXywUQoXbC8v6aKDhghNeFRdiJw")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
