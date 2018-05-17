//
// Copyright © 2018 HERE Global B.V. All rights reserved.
//

import UIKit
import HereSDKDemandKit

class RideOffersViewController: UIViewController {

    static let segueId = "RideOffersViewController"

    var rideRequest: HereSDKDemandRideOffersRequest?
    var passengerDetails : HereSDKDemandPassenger?
    var passengerNotes : String?
    var isPrebook : Bool = false

    internal var offers = [HereSDKDemandRideOfferProtocol]() {
        didSet {
            updateUI(for: offers)
        }
    }

    @IBOutlet private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func updateUI(for offers: [HereSDKDemandRideOfferProtocol]) {
        tableView.reloadData()
    }
}

extension RideOffersViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard offers.count > indexPath.row else { return UITableViewCell() }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: RideOfferTableCell.storyboardIdentifier, for: indexPath) as? RideOfferTableCell  else { return UITableViewCell() }

        let offer = offers[indexPath.row]
        cell.delegate = self
        cell.offer = offer
        return cell
    }
}

extension RideOffersViewController: RideOfferTableCellDelegate {
    func offerCell(_ cell: RideOfferTableCell, showRideOfferDetails offer: HereSDKDemandPublicTransportRideOffer) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let publicOfferDetailsVC : PublicTransportDetailsTableViewController = storyboard.instantiateViewController(withIdentifier: "PublicTransportDetailsTableViewController") as! PublicTransportDetailsTableViewController
        publicOfferDetailsVC.offer = offer

        self.navigationController?.pushViewController(publicOfferDetailsVC, animated: true)
    }
    
    func offerCell(_ cell: RideOfferTableCell, didBookOffer offer: HereSDKDemandTaxiRideOffer) {
        book(offer)
    }
}
