//
// Copyright © 2018 HERE Global B.V. All rights reserved.
//

import Foundation

extension UserDefaults {

    private static let currentRideIdKey = "currentRideId"
    private static let userNameKey = "userName"
    private static let userPhoneNumberKey = "userPhoneNumber"

    private static let enableSandboxKey = "EnableSandbox"
    private static let enableLogToFileKey = "EnableLogToFile"

    // Those are default values for the settings that are managed from the app's settings pane in system Settings app
    static let defaultAppSettingsValues: [String: Any] = [UserDefaults.enableSandboxKey: true,
                                                          UserDefaults.enableLogToFileKey: true]

    var enableSandbox: Bool {
        return bool(forKey: UserDefaults.enableSandboxKey)
    }

    var enableLogToFile: Bool {
        return bool(forKey: UserDefaults.enableLogToFileKey)
    }

    var currentRideId: String? {
        get {
            return string(forKey: UserDefaults.currentRideIdKey)
        }
        set {
            set(newValue, forKey: UserDefaults.currentRideIdKey)
            synchronize()
        }
    }

    var userName: String? {
        get {
            return string(forKey: UserDefaults.userNameKey)
        }
        set {
            set(newValue, forKey: UserDefaults.userNameKey)
            synchronize()
        }
    }

    var userPhoneNumber: String? {
        get {
            return string(forKey: UserDefaults.userPhoneNumberKey)
        }
        set {
            set(newValue, forKey: UserDefaults.userPhoneNumberKey)
            synchronize()
        }
    }

}
