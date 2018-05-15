//
// Copyright © 2018 HERE Global B.V. All rights reserved.
//

import UIKit

protocol NumberPickerViewDelegate: class {

    func didUpdate(_ picker: NumberPickerView, to value: Int)
}

class NumberPickerView: UIView {

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 110, height: 30)
    }

    var minValue = 0 {
        didSet {
            updateState()
        }
    }

    var maxValue = 0 {
        didSet {
            updateState()
        }
    }

    var currentValue = 0 {
        didSet {
            label.text = "\(currentValue)"
            updateState()
        }
    }
    weak var delegate: NumberPickerViewDelegate?

    fileprivate var plusButton: UIButton = {

        let b = UIButton(type: .custom)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(#imageLiteral(resourceName: "NumberPickerPlusEnabled"), for: .normal)
        b.setImage(#imageLiteral(resourceName: "NumberPickerPlusDisabled"), for: .disabled)
        return b
    }()
    fileprivate var minusButton: UIButton = {

        let b = UIButton(type: .custom)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(#imageLiteral(resourceName: "NumberPickerMinusEnabled"), for: .normal)
        b.setImage(#imageLiteral(resourceName: "NumberPickerMinusDisabled"), for: .disabled)
        return b
    }()
    fileprivate var label: UILabel = {

        let lbl = UILabel()
        lbl.textColor = .gray
        lbl.font = .plainTextMediumCenter
        lbl.backgroundColor = .clear
        lbl.textAlignment = .center
        lbl.layer.borderColor = UIColor.white.cgColor
        lbl.layer.borderWidth = 1.0
        return lbl
    }()

    init(min:Int, max: Int, delegate: NumberPickerViewDelegate? = nil) {

        super.init(frame: CGRect.zero)
        self.minValue = min
        self.currentValue = min
        self.maxValue = max
        self.delegate = delegate
        commonSetup()
    }

    override init(frame: CGRect) {

        super.init(frame: frame)
        commonSetup()
    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        commonSetup()
    }

    fileprivate func commonSetup() {

        plusButton.addTarget(self,
                             action: #selector(plusButtonTouchUpInside(_:)),
                             for: .touchUpInside)
        minusButton.addTarget(self,
                              action: #selector(minusButtonTouchUpInside(_:)),
                              for: .touchUpInside)

        addSubview(plusButton)
        addSubview(minusButton)
        addSubview(label)
        backgroundColor = .white
        layer.cornerRadius = 5.0
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1.0
        label.text = "\(currentValue)"

        [minusButton, label, plusButton].forEach { (v: UIView) in v.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            minusButton.topAnchor.constraint(equalTo: topAnchor),
            minusButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            minusButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            minusButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3),

            plusButton.topAnchor.constraint(equalTo: topAnchor),
            plusButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            plusButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            plusButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3),

            label.leadingAnchor.constraint(equalTo: minusButton.trailingAnchor),
            label.trailingAnchor.constraint(equalTo: plusButton.leadingAnchor),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])

        updateState()
    }
}

extension NumberPickerView {

    fileprivate func updateState() {

        if currentValue <= minValue {

            minusButton.alpha = 0.5
            minusButton.isEnabled = false

        } else {
            minusButton.alpha = 1.0
            minusButton.isEnabled = true
        }

        if currentValue >= maxValue {

            plusButton.alpha = 0.5
            plusButton.isEnabled = false

        } else {
            plusButton.alpha = 1.0
            plusButton.isEnabled = true
        }
    }

    @objc fileprivate func plusButtonTouchUpInside(_ sender: UIButton) {

        currentValue += 1

        delegate?.didUpdate(self, to: currentValue)
        updateState()
    }

    @objc fileprivate func minusButtonTouchUpInside(_ sender: UIButton) {

        currentValue -= 1

        delegate?.didUpdate(self, to: currentValue)
        updateState()
    }
}
