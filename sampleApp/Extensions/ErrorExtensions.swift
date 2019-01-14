//
// Copyright © 2018 HERE Global B.V. All rights reserved.
//

import UIKit

extension Error {
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
}
