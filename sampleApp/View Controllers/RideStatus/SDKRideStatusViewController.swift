//
// Copyright © 2018 HERE Global B.V. All rights reserved.
//

import UIKit
import HereSDKDemandKit

class SDKRideStatusViewController: RideStatusViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let rideId = self.ride?.rideId {
            RideStatusServiceImpl.shared().addObserver(self, for: rideId)
        }
    }
}

extension SDKRideStatusViewController: RideStatusObserver {
    func didUpdateStatus(for ride: HereSDKDemandRide) {
        debugPrint("(observer)SDK Ride \(ride.rideId) updated status: \(ride.statusLog.currentStatus.rawValue) at \(ride.statusLog.lastUpdateTime)")
        updateStatusesArray(statusLog: ride.statusLog)
        self.updateActionButton(status: ride.statusLog.currentStatus)
        self.updateUI(for: ride)
    }

    func didUpdateLocation(_ location: HereSDKDemandRideLocation, for ride: HereSDKDemandRide) {
        if let vehicleLocation = location.vehicleLocation?.coordinate {
            debugPrint("(observer)SDK Ride \(ride.rideId) updated location: \(vehicleLocation)")
            self.updateUI(for: location)
        }
    }
}
