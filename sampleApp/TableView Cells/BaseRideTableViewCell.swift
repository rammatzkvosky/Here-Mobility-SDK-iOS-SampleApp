//
// Copyright © 2018 HERE Global B.V. All rights reserved.
//

import UIKit

class BaseRideTableViewCell: UITableViewCell {

    @IBOutlet internal var container: UIView!
    @IBOutlet internal var supplierImage: UIImageView!
    @IBOutlet internal var supplierName: UILabel!
    @IBOutlet internal var offerPriceLabel: UILabel!
    @IBOutlet internal var estimatedPriceButton: UIButton!
    @IBOutlet internal var offerETALabel: UILabel!
    @IBOutlet internal var offerETAButton: UIButton!
    @IBOutlet internal var bookButton: UIButton!
    @IBOutlet internal var bookingProgressView: UIView!


    override func awakeFromNib() {
        super.awakeFromNib()

        setupDesignStyle()
        container.setRoundedBorder()
        bookButton.setRoundedBorder(shadow: false)
    }

    private func setupDesignStyle() {
        supplierName.font = .plainTextBigLeft
        offerETALabel.font = .plainTextMediumCenter
        offerPriceLabel.font = .plainTextMediumCenter
        offerETAButton.titleLabel?.font = .plainTextSmallCenterGray
        estimatedPriceButton.titleLabel?.font = .plainTextSmallCenterGray
        bookButton.titleLabel?.font = .buttonsMediumCenterWhite

        supplierName.textColor = .charcoalGrey
        offerETAButton.titleLabel?.textColor = .charcoalGrey50
        estimatedPriceButton.titleLabel?.textColor = .charcoalGrey50
        bookButton.titleLabel?.textColor = .white
    }

    private func updateUI(for booking: Bool) {
        bookButton.isHidden = booking
        bookingProgressView.isHidden = !booking
    }

    @IBAction private func bookButtonTapped(_ sender: Any) {
        actionButtonTapped()
    }

    func actionButtonTapped(){
        // should not get here
    }
}
