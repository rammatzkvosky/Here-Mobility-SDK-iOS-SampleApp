//
// Copyright © 2018 HERE Global B.V. All rights reserved.
//

import UIKit
import HereSDKDemandKit

class PublicTransportDetailTableViewCell: UITableViewCell {

    static let storyboardIdentifier = "PublicTransportDetailTableViewCell"
    var sectionData : HereSDKDemandPublicTransportRouteLeg?

    @IBOutlet weak var transportTypeLabel: UILabel!
    @IBOutlet weak var transportTypeDetailLabel: UILabel!

    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var durationDetailLabel: UILabel!

    @IBOutlet weak var lineLabel: UILabel!
    @IBOutlet weak var lineDetailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func populateData(){
        if let typeDetail = sectionData?.transportModeDescription(){
            self.transportTypeDetailLabel.text = typeDetail
        }
        if let durationValue = sectionData?.duration?.stringValue {
            self.durationDetailLabel.text = "\(durationValue) minutes"
        }
        if let publicTransportLine = sectionData?.line, publicTransportLine != ""{
            self.lineDetailLabel.text = publicTransportLine
        }
        else{
            self.lineDetailLabel.text = "N/A"
        }
    }

}
