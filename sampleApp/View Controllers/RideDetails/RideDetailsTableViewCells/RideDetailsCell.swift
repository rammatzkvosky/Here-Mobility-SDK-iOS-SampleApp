//
// Copyright © 2018 HERE Global B.V. All rights reserved.
//

import UIKit

class RideDetailsCell: UITableViewCell {

    func markValid(_ isValid: Bool) {
        setBorderColor(isValid ? .white2 : .rose)
        if !isValid {

            // Perform subview re-layout as currently cells border overlaps each other
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(10)) {
                self.superview?.bringSubview(toFront: self)
            }
        }
    }

    // MARK: - IBOutlet
    @IBOutlet var borderView: UIView!
    @IBOutlet private var titleLabel: UILabel!

    // MARK: - UIView Override
    override func awakeFromNib() {
        super.awakeFromNib()

        setupDesignStyle()
        setBorderColor(.white2)

        selectionStyle = .none
    }

    // MARK: - Utils
    private func setupDesignStyle() {
        titleLabel?.font = UIFont.plainTextMediumLeft
        titleLabel?.textColor = UIColor.charcoalGrey
    }

    private func setBorderColor(_ color: UIColor) {
        borderView?.layer.borderColor = color.cgColor
        borderView?.layer.borderWidth = 1
    }
}
