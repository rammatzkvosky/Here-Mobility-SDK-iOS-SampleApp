//
// Copyright © 2018 HERE Global B.V. All rights reserved.
//

import UIKit

extension UIViewController {
    func showDismissableAlert(title: String?, message: String?, handler:(() -> Swift.Void)? = nil) {
        showDismissableAlert(title: title, message: message, actionTitle: "OK", handler: handler)
    }

    func showDismissableAlert(title: String?, message: String?, actionTitle: String, handler:(() -> Swift.Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let action = UIAlertAction(title: actionTitle, style: .default) { _ in
            if let handler = handler {
                handler()
            }
        }

        alert.addAction(action)

        self.present(alert, animated: true, completion: nil)
    }
}
