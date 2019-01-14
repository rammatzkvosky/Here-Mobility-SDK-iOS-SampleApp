//
// Copyright © 2018 HERE Global B.V. All rights reserved.
//

import UIKit
import HereSDKDemandKit

protocol FutureRideTableCellDelegate: class {
    func futureRideCell(_ cell: FutureRideTableViewCell, didCancelRide ride: HereSDKDemandRide)
}

class FutureRideTableViewCell: BaseRideTableViewCell {

    static let storyboardIdentifier = "FutureRideTableViewCell"

    weak var delegate: FutureRideTableCellDelegate?

    var ride: HereSDKDemandRide! {
        didSet {
            updateUI(for: ride)
        }
    }

    override func actionButtonTapped() {
        if let ride = self.ride{
            delegate?.futureRideCell(self, didCancelRide: ride)
        }
    }

    private func updateUI(for ride: HereSDKDemandRide) {
        supplierName.text = ride.supplier.englishName
        if let _logoURL = ride.supplier.logoURL {
            supplierImage.setImage(url: URL(string: _logoURL))
        }
        offerETALabel.text = ride.prebookPickupTime?.justTime ?? "N/A"
        if let priceRange = ride.bookingEstimatedPrice?.range {
            offerPriceLabel.text = "\(priceRange.lowerBound) - \(priceRange.upperBound)$"
        }
    }

}
