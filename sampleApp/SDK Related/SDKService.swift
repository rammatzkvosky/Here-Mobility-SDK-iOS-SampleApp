//
// Copyright © 2018 HERE Global B.V. All rights reserved.
//

import Foundation

protocol SDKErrorObserver: class {
    func didReceiveSDKError(_ error: Error?)
}

protocol SDKErrorHandler: class {
    func willHandleError(_ error: Error) -> Bool
    func handleError(_ error: Error)
}

protocol SDKErrorReporter {
    var errorObserver: SDKErrorObserver? { get set }
}

protocol SDKService: SDKErrorReporter {
    
}

extension SDKService {
    typealias responseErrorHandler = (_ error: Error?) -> Void
    func handleResponseError(_ error: Error?, completion: responseErrorHandler? = nil) {
        DispatchQueue.main.async {
            self.errorObserver?.didReceiveSDKError(error)
            completion?(error)
        }
    }
}
