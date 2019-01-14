//
// Copyright © 2018 HERE Global B.V. All rights reserved.
//

import HereSDKDemandKit

extension HereSDKDemandCancellationInfo {
    var cancellationInfo: String {
        get {
            let reason = self.cancelReason.isEmpty ? "None" : self.cancelReason

            return "Canncelled by: \(self.cancellingParty.string)\nReason: \(reason)\nStatus: \(self.cancellationStatus.string)"
        }
    }
}

fileprivate extension HereSDKDemandCancellationStatus {
    var string: String {
        switch self {
        case .processing:
            return "Processing"
        case .accepted:
            return "Accepted"
        case .rejected:
            return "Rejected"
        case .unknown:
            return "Unknown"
        }
    }
}

fileprivate extension HereSDKDemandCancellationInfoParty {
    var string: String {
        switch self {
        case .demander:
            return "Demander"
        case .supplier:
            return "Supplier"
        case .unknown:
            return "Unknown"
        }
    }
}
