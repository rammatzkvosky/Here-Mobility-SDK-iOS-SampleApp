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

        // required - Set user for sdk use
        generateUserCredentialsWithUser(userId: "HereSDKUser", expiration: 230948092)

        CLLocationManager().requestWhenInUseAuthorization()


        return true
    }

    func generateHash(appKey: String, userId: String, expiration:UInt32, key: String) -> String? {
        return HMACGenerator.hmacSHA256(from: appKey, userId: userId, expiration: Int32(expiration), withKey: key)
    }

    func generateUserCredentialsWithUser(userId : String, expiration : UInt32){
        if let infoDictionary = Bundle.main.infoDictionary{
            if let appKey = infoDictionary["HereMobilitySDKAppId"] as? String, let appSecret = infoDictionary["HereMobilitySDKAppSecret"] as? String {
                let hashString = generateHash(appKey: appKey, userId: userId, expiration: expiration, key: appSecret)
                HereSDKManager.shared?.user = HereSDKUser(id: userId, expiration: Date(timeIntervalSince1970 : TimeInterval(expiration)), verificationHash: hashString!)
            }
        }
    }
}

