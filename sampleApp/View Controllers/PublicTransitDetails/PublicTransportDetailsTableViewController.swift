//
// Copyright © 2018 HERE Global B.V. All rights reserved.
//

import UIKit
import HereSDKDemandKit

class PublicTransportDetailsTableViewController: UITableViewController {

    var offer : HereSDKDemandPublicTransportRideOffer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let _ = offer{
            self.tableView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offer!.sectionsArray.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard offer!.sectionsArray.count > indexPath.row else { return UITableViewCell() }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: PublicTransportDetailTableViewCell.storyboardIdentifier, for: indexPath) as? PublicTransportDetailTableViewCell  else { return UITableViewCell() }

        let section = offer?.sectionsArray[indexPath.row]
        cell.sectionData = section
        cell.populateData()
        return cell
    }

}
