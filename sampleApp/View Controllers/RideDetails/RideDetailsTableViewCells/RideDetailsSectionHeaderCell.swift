//
// Copyright © 2018 HERE Global B.V. All rights reserved.
//

import UIKit

class RideDetailsSectionHeaderCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet private var titleLabel: UILabel!

    // MARK: - UIView Override
    override func awakeFromNib() {
        super.awakeFromNib()

        setupDesignStyle()
    }

    // MARK: - Utils
    private func setupDesignStyle() {
        titleLabel.font = .titleTitle3LeftGray
        titleLabel.textColor = .charcoalGrey50
    }

}
