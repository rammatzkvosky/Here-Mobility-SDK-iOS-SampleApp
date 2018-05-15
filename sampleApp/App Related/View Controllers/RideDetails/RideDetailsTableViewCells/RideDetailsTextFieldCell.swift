//
// Copyright © 2018 HERE Global B.V. All rights reserved.
//

import UIKit

protocol RideDetailsTextFieldCellDelegate: class {
    func rideDetailsTextFieldCell(cell: RideDetailsTextFieldCell, didEnter value: String)
}

class RideDetailsTextFieldCell: RideDetailsCell {

    weak var delegate: RideDetailsTextFieldCellDelegate?

    enum ContentType {
        case name
        case phoneNumber
        case note
    }

    var contentType = ContentType.name {
        didSet {
            setupTextField(for: contentType)
        }
    }

    var value: String = "" {
        didSet {
            textField?.text = value
        }
    }

    // MARK: - IBOutlet
    @IBOutlet private var textField: TextField!

    // MARK: - UIView Override
    override func awakeFromNib() {
        super.awakeFromNib()

        textField.delegate = self
        setupTextField(for: contentType)

        isBeingEdited = false
    }

    // MARK: - Utils
    private var isBeingEdited: Bool = false {
        didSet {
            updateBackgroundColor(isBeingEdited)
        }
    }

    private func setupTextField(for contentType: ContentType) {
        textField?.keyboardType = contentType.keyboardType()
        textField.placeholder = contentType.placeholder()
    }

    private func updateBackgroundColor(_ isBeingEdited: Bool) {
        borderView.backgroundColor = isBeingEdited ? .lightTeal20 : .white
    }
}

// MARK: - UITextFieldDelegate
extension RideDetailsTextFieldCell: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        value = ""
        delegate?.rideDetailsTextFieldCell(cell: self, didEnter: value)
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        isBeingEdited = true
    }

    func textFieldDidEndEditing(_ textField: UITextField){
        isBeingEdited = false
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        // Reload suggestions after textField content will be updated and its text will be ready as queryText
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(10)) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.value = textField.text ?? ""
            strongSelf.delegate?.rideDetailsTextFieldCell(cell: strongSelf, didEnter: strongSelf.value)
        }

        return true
    }

}

// MARK: -
extension RideDetailsTextFieldCell.ContentType {
    fileprivate func keyboardType() -> UIKeyboardType {
        switch self {
        case .name, .note:
            return .default
        case .phoneNumber:
            return .phonePad
        }
    }

    fileprivate func placeholder() -> String {
        switch self {
        case .name:
            return "Name (Mandatory)"
        case .phoneNumber:
            return "Phone Number (Mandatory)"
        case .note:
            return "Notes for the driver"
        }
    }
}
