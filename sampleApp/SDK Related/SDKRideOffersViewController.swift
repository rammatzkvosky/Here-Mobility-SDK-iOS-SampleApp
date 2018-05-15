//
// Copyright © 2018 HERE Global B.V. All rights reserved.
//

import UIKit
import HereSDKDemandKit

class SDKRideOffersViewController: RideOffersViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // get the ride offer with HereSDKDemandRideOffersRequest
        fetchRideOffers()
    }

    // get offers from ride request
    internal func fetchRideOffers() {
        if let rideRequest = self.rideRequest{
            HereSDKDemandManager.shared.requestRide(rideRequest) { [weak self] offers, error in
                if (error != nil){
                    debugPrint(error.debugDescription)
                }
                if let offers = offers{
                    self?.offers = offers
                }
            }
        }
    }
}

extension RideOffersViewController{

    internal func book(_ rideOffer: HereSDKDemandTaxiRideOffer) {
        // passenger details from RideDetailsViewController
        guard let passengerDetails = self.passengerDetails else {return}
        // create request with passenger details and offerId
        let demandRideRequest = HereSDKDemandRideRequest(offerId: rideOffer.offerId,
                                                         passengerDetails: passengerDetails)

        HereSDKDemandManager.shared.createRide(with: demandRideRequest) { [weak self] ride, error in
            guard let strongSelf = self else { return }

            if error != nil {
                debugPrint(error.debugDescription)
            }
            else if strongSelf.isPrebook{ //if prebook ride exist - it presented in future rides VC
                strongSelf.navigationController?.popToRootViewController(animated: true)
            }
            else if let demandRide = ride{
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let rideStatusViewController : RideStatusViewController = storyboard.instantiateViewController(withIdentifier: "RideStatusViewController") as! RideStatusViewController
                rideStatusViewController.ride  = demandRide
                strongSelf.navigationController?.pushViewController(rideStatusViewController, animated: true)
            }
        }
    }
}
