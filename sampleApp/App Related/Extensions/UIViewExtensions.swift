//
// Copyright © 2018 HERE Global B.V. All rights reserved.
//

import UIKit

//MARK: Load from nib
extension UIView {

    @discardableResult
    func fromNib<T>() -> T? where T:UIView {

        //todo - check if static nib available via nibLoadableView protocol and replace this line, curr
        guard let nibName = String(describing: type(of: self)).components(separatedBy: ".").last else {
            return nil
        }

        guard let view = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?[0] as? T else {
            return nil
        }

        addSubview(view)
        return view
    }

    class func loadFromNib<T: UIView>(owner: AnyObject? = nil) -> T {
        let bundle = Bundle(for: self)
        let nibName = String(describing: self)
        let nib = UINib(nibName: nibName, bundle: bundle)

        guard let result = nib.instantiate(withOwner: owner, options: nil).first as? T else {
            fatalError("Failed to instantiate nib named \(nibName) in bundle \(bundle)")
        }

        return result
    }
}


extension UIView{
    var width:      CGFloat { return self.frame.size.width }
    var height:     CGFloat { return self.frame.size.height }
    var size:       CGSize  { return self.frame.size}

    var origin:     CGPoint { return self.frame.origin }
    var x:          CGFloat { return self.frame.origin.x }
    var y:          CGFloat { return self.frame.origin.y }
    var centerX:    CGFloat { return self.center.x }
    var centerY:    CGFloat { return self.center.y }

    var left:       CGFloat { return self.frame.origin.x }
    var right:      CGFloat { return self.frame.origin.x + self.frame.size.width }
    var top:        CGFloat { return self.frame.origin.y }
    var bottom:     CGFloat { return self.frame.origin.y + self.frame.size.height }

    func setRoundedBorder(shadow hasShadow: Bool = true) {
        layer.borderColor = UIColor.offWhite.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 5

        if hasShadow {
            layer.shadowRadius = 4
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 0.2
            layer.shadowOffset = CGSize(width: 0, height: 0)
        } else {
            layer.masksToBounds = true
        }
    }
}


