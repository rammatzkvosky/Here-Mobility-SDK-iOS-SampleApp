//
// Copyright © 2018 HERE Global B.V. All rights reserved.
//

import UIKit
import HereSDKDemandKit

class SDKRideStatusViewController: RideStatusViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
         //register to this delegate in order to get updates of the ride (driver allocation, ride status, ETA)
        HereSDKDemandManager.shared.registerForRidesUpdates(with: self)
    }
}

extension SDKRideStatusViewController: HereSDKDemandRidesUpdatesDelegate {

    // updates about ride status
    func didReceiveUpdate(_ statusLog: HereSDKDemandRideStatusLog!, for ride: HereSDKDemandRide!) {
        guard let rideId = ride.rideId else { return }
        if self.ride?.rideId == rideId{
            debugPrint("SDK Ride \(rideId) updated status: \(statusLog.currentStatus.rawValue) at \(statusLog.lastUpdateTime)")
            updateStatusesArray(statusLog: statusLog)
            self.updateActionButton(status: statusLog.currentStatus)
            self.updateUI(for: ride)
        }
    }

    // updates about driver location once assigned
    func didReceive(_ location: HereSDKDemandRideLocation!, for ride: HereSDKDemandRide!) {
        debugPrint("SDK Ride \(ride.rideId) updated location: \(location.vehicleLocation.coordinate)")
        guard let rideId = ride.rideId else { return }
        if self.ride?.rideId == rideId{
            self.updateUI(for: location)
        }
    }

    func didReceiveUpdateError(_ error: Error!, forRideId rideId: String!) {
        debugPrint("SDK Ride \(rideId) status update failed with error: \(error.localizedDescription)")
    }
}
