//
// Copyright © 2018 HERE Global B.V. All rights reserved.
//

import UIKit
import HereSDKDemandKit

class FutureRideOffersViewControllers: UIViewController {

    @IBOutlet weak var futureRidesTableView: UITableView!

    internal var rides : [HereSDKDemandRide]?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let rides = self.rides{
            self.updateUI(for: rides)
        }
    }

    private func updateUI(for rides: [HereSDKDemandRide]) {
        self.navigationController?.isNavigationBarHidden = false
        futureRidesTableView.reloadData()
    }
}

extension FutureRideOffersViewControllers: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return rides?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FutureRideTableViewCell.storyboardIdentifier, for: indexPath) as? FutureRideTableViewCell  else { return UITableViewCell() }

        let ride = rides?[indexPath.row]
        cell.delegate = self
        cell.ride = ride
        return cell
    }
}

extension FutureRideOffersViewControllers: FutureRideTableCellDelegate {

   func futureRideCell(_ cell: FutureRideTableViewCell, didCancelRide ride: HereSDKDemandRide) {
        let cancelRequest = HereSDKDemandCancelRideRequest.cancelRide(withRideId: ride.rideId, cancelReason: "")
        HereSDKDemandManager.shared.cancelRide(with: cancelRequest) { [weak self] error in
            if error != nil {

            } else {
                self?.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}


