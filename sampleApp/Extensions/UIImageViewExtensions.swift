//
// Copyright © 2018 HERE Global B.V. All rights reserved.
//

import UIKit

extension UIImageView {

    func setImage(url: URL?, placeholder: UIImage? = nil) {
        guard let imageURL = url else {
            return
        }

        let task = URLSession.shared.dataTask(with: imageURL) { [weak self] data, response, error in
            if let resultImage = (data.map { UIImage(data: $0) } ?? placeholder) {
                DispatchQueue.main.async {
                    self?.image = resultImage
                }
            }
        }
        task.resume()
    }
}
