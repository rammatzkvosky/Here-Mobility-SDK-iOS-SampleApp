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

    @IBOutlet weak var rideRouteLabel: UILabel!
    @IBOutlet private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func updateUI(for offers: [HereSDKDemandRideOfferProtocol]) {
        rideRouteLabel.text = getTaxiRideRouteMessage(offers: offers)
        rideRouteLabel.sizeToFit()
        tableView.reloadData()
    }
}


//checks if there is a taxi offer in the offers list, and if there is, gets the confirmed route
//(in taxis the ride route may be slightly different from the requested route).
private func getTaxiRideRouteMessage (offers : [HereSDKDemandRideOfferProtocol]) -> String? {
    guard let taxiOffer = ( offers.first { $0.getTransitType() == .taxi} ) as? HereSDKDemandTaxiRideOffer,
        let pickupAddress = taxiOffer.route.pickup.address?.stringAddress,
        let destinationAddress = taxiOffer.route.destination.address?.stringAddress
        else { return nil }

    return "The confirmed route for taxis may be slightly different from the requested route, the confirmed route is from \(pickupAddress) to \(destinationAddress)"
}

fileprivate extension HereSDKAddressData {
    var stringAddress : String? {
        guard let street = self.street, let number = self.houseNumber else { return nil }
        return "street: \(street), number:\(number)"
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
