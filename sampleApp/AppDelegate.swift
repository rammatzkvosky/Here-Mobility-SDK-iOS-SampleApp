//
// Copyright © 2018 HERE Global B.V. All rights reserved.
//

import UIKit
import HereSDKCoreKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // optional - Default is false, uses WiFi network only.
        HereSDKManager.allowCellularAccess(true)

        // optional = Configures the global log level setting, which determines the level of logs that are printed to the console.
        HereSDKManager.configureLoggingLevel(.warning)

        // required - Configures the HereSDK and starts its services. This method should be called after the app is launched and before using HereSDK services.
        HereSDKManager.configure()

        return true
    }
}

