//
// Copyright © 2018 HERE Global B.V. All rights reserved.
//

import UIKit

class TextField: UITextField {

    private var clearButton: UIButton!

    // MARK: - UITextField override
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonSetup()
    }

    override func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        updateClearButtonVisibility()
        return result
    }

    override func resignFirstResponder() -> Bool {
        rightViewMode = .never
        return super.resignFirstResponder()
    }

    override var text: String? {
        didSet {
            updateClearButtonVisibility()
        }
    }

    override var placeholder: String? {
        didSet {
            attributedPlaceholder = NSAttributedString(string: placeholder ?? "",
                        attributes: [NSAttributedStringKey.font: UIFont.plainTextMediumLeftGray,
                                    NSAttributedStringKey.foregroundColor: UIColor.charcoalGrey50])
        }
    }

    // MARK: -
    func updateClearButtonVisibility() {
        let visibilityMode: UITextFieldViewMode = (isFirstResponder && text?.isEmpty == false) ? .always : .never
        rightViewMode = visibilityMode
    }


    // MARK: - Utils
    private func commonSetup() {
        setupDesignStyle()
        setupClearButton()
        updateClearButtonVisibility()
    }

    private func setupDesignStyle() {
        font = .plainTextMediumLeft
        textColor = .gray
    }

    private func setupClearButton() {
        clearButton = UIButton(type: .custom)
        clearButton.setImage(#imageLiteral(resourceName: "closeIcon"), for: .normal)
        clearButton.bounds = CGRect(x: 0, y: 0, width: 12, height: 22)

        clearButton.addTarget(self, action: #selector(clearButtonTapped(_:)), for:  .touchUpInside)

        rightView = clearButton
        rightViewMode = .always
    }

    @objc private func clearButtonTapped(_ sender: UIButton) {
        if true == delegate?.textFieldShouldClear?(self) {
            text = ""
            rightViewMode = .never
            _ = becomeFirstResponder()
        }
    }

}
