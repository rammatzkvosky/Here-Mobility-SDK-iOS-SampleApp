//
// Copyright © 2018 HERE Global B.V. All rights reserved.
//

import UIKit

protocol SwitchViewDelegate: class {

    func state(of switch: SwitchView, is on: Bool)
}

class SwitchView: UIView {

    weak var delegate: SwitchViewDelegate?

    var onText: String = "YES" {
        didSet {
            onLabel.text = onText
        }
    }

    var offText: String = "NO" {
        didSet {
            offLabel.text = offText
        }
    }

    func setIsOn(_ value: Bool, animated: Bool = false) {
        isOn = value
        updateUI(animated: animated)
    }

    var isOn: Bool = false {
        didSet {
            updateUI(animated: true)
        }
    }

    // MARK: - IBOutlets
    @IBOutlet private var contentView: UIView!
    @IBOutlet private var backgroundView: UIView!
    @IBOutlet private var thumbView: UIView!
    @IBOutlet private var thumbViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private var onLabel: UILabel!
    @IBOutlet private var offLabel: UILabel!

    // MARK: - UIView override
    override init(frame: CGRect) {
        super.init(frame: frame)

        commonSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonSetup()
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        setupInitialUI()

        onLabel.text = onText
        offLabel.text = offText
    }

    // MARK: - IBActions

    @IBAction private func viewTapped(_ sender: Any) {

        isOn = !isOn
        delegate?.state(of: self, is: isOn)
    }

    private func setupInitialUI() {
        setupDesignStyle()

        backgroundView.setRoundedBorder(shadow: false)
        thumbView.setRoundedBorder(shadow: false)
    }

    private func commonSetup() {
        self.fromNib()
    }

    private func setupDesignStyle() {
        [offLabel, onLabel].forEach {
            $0?.font = .plainTextMediumLeft
            $0?.textColor = .charcoalGrey
        }
    }

    private func updateUI(animated: Bool) {

        let updateHandler = { [weak self] in

            guard let stronSelf = self else {return}

            stronSelf.onLabel.alpha = stronSelf.isOn ? 1 : 0
            stronSelf.offLabel.alpha = stronSelf.isOn ? 0 : 1
            stronSelf.thumbViewLeadingConstraint?.isActive = !stronSelf.isOn

            stronSelf.layoutIfNeeded()
        }

        if !animated {
            updateHandler()
        } else {
            UIView.animate(withDuration: 0.25) { updateHandler() }
        }

    }

}
