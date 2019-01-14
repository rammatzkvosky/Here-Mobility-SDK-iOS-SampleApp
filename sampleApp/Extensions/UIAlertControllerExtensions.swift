//
// Copyright © 2018 HERE Global B.V. All rights reserved.
//

import UIKit

extension UIAlertController {
    class func show(_ message: String, from viewController: UIViewController?) {
        DispatchQueue.main.async {
            if let viewController = viewController{
                let alertViewController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                alertViewController.addAction(UIAlertAction(title: "OK", style: .default))
                viewController.present(alertViewController, animated: false, completion: nil)
            }
        }
    }
}
