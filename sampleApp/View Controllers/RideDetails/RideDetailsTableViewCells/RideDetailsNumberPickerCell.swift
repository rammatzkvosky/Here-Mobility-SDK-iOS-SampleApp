//
// Copyright © 2018 HERE Global B.V. All rights reserved.
//

import UIKit

class RideDetailsNumberPickerCell: RideDetailsCell {

    var minValue: Int = 0 {
        didSet {
            numberPicker.minValue = minValue
        }
    }

    var maxValue: Int = 2 {
        didSet {
            numberPicker.maxValue = maxValue
        }
    }

    var value: Int = 0 {
        didSet {
            numberPicker.currentValue = value
        }
    }

    // MARK: - IBOutlet
    @IBOutlet private var numberPicker: NumberPickerView!

    // MARK: - UIView Override
    override func awakeFromNib() {
        super.awakeFromNib()

        setupNumberPickerInitialValues()
        numberPicker.delegate = self
    }

    // MARK: - Utils

    private func setupNumberPickerInitialValues() {
        numberPicker.minValue = minValue
        numberPicker.maxValue = maxValue
        numberPicker.currentValue = value
    }
}

// MARK: - NumberPickerViewDelegate
extension RideDetailsNumberPickerCell: NumberPickerViewDelegate {
    func didUpdate(_ picker: NumberPickerView, to value: Int) {
        if self.value != value {
            self.value = value
        }
    }
}
