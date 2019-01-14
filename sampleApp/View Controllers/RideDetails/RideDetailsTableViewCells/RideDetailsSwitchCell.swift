//
// Copyright © 2018 HERE Global B.V. All rights reserved.
//

import UIKit

protocol RideDetailsSwitchCellDelegate: class {
    func state(of rideDetailsSwitchCell: RideDetailsSwitchCell, is on: Bool)
}

class RideDetailsSwitchCell: RideDetailsCell {

    weak var delegate: RideDetailsSwitchCellDelegate?

    var on: Bool = false {
        didSet {
            switchView.setIsOn(on, animated: true)
        }
    }

    // MARK: - IBOutlet
    @IBOutlet private var switchView: SwitchView!

    // MARK: - UIView Override
    override func awakeFromNib() {
        super.awakeFromNib()
        switchView.delegate = self
    }

}

// MARK: - SwitchViewDelegate
extension RideDetailsSwitchCell: SwitchViewDelegate {
    func state(of switch: SwitchView, is on: Bool) {
        if self.on != on {
            self.on = on
        }
        self.delegate?.state(of: self, is: self.on)
    }
}
