//
// Copyright © 2018 HERE Global B.V. All rights reserved.
//

import UIKit
import HereSDKMapKit
import HereSDKDemandKit

class RideDetailsViewController: UITableViewController {

    @IBOutlet weak var nameCell: RideDetailsTextFieldCell!
    @IBOutlet weak var phoneNumberCell: RideDetailsTextFieldCell!
    @IBOutlet weak var noteCell: RideDetailsTextFieldCell!
    @IBOutlet weak var passengersCell: RideDetailsNumberPickerCell!
    @IBOutlet weak var suitcasesCell: RideDetailsNumberPickerCell!
    @IBOutlet weak var bookNowCell: RideDetailsSwitchCell!

    static let segueId = "toRideDetailsViewController"

    internal struct RideDetailsDefaultValues {
        static let name = "Your name"
        static let phoneNumber = "9725454545"
        static let note = ""
        static let passengersCount = 1
        static let suitcasesCount = 0
        static let bookNow = true
    }

    //MARK : HereSDKMapKit related

    // mapkit services client
    internal let mapService = HereSDKMapService()

    // origin & destination geocode result passed from getRidesViewController
    var originGeocodeResult : HereSDKGeocodeResult?
    var destinationGeocodeResult : HereSDKGeocodeResult?

    lazy var prebookRideDatePickerView : UIDatePicker = UIDatePicker(frame: CGRect(x: 5, y: 40, width: 250, height: 180))
    var prebookRideDate : Date?

    override func viewDidLoad() {
        super.viewDidLoad()
        bookNowCell.delegate = self

        setupCellsInitialValues()
        setEndViewEditingOnTap()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    @IBAction private func backButtonTapped(_ sender: Any) {
        view.endEditing(true)
        navigationController?.popViewController(animated: true)
    }

    private func setupCellsInitialValues() {
        nameCell.contentType = .name
        nameCell.value = RideDetailsDefaultValues.name

        phoneNumberCell.contentType = .phoneNumber
        phoneNumberCell.value = RideDetailsDefaultValues.phoneNumber

        noteCell.contentType = .note
        noteCell.value = RideDetailsDefaultValues.note

        passengersCell.maxValue = 8
        passengersCell.minValue = 1
        passengersCell.value = RideDetailsDefaultValues.passengersCount

        suitcasesCell.maxValue = 4
        suitcasesCell.value = RideDetailsDefaultValues.suitcasesCount

        bookNowCell.on = RideDetailsDefaultValues.bookNow
    }

    @IBAction func showRidesTapped(_ sender: Any) {
        showRides()
    }

    //helper for finishing editing view
    func setEndViewEditingOnTap() {
        let gestureRecognizer = UITapGestureRecognizer(target: view, action: #selector(view.endEditing(_:)))
        gestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(gestureRecognizer)

        if let gestureDelegate = self as? UIGestureRecognizerDelegate {
            gestureRecognizer.delegate = gestureDelegate
        }
    }
}

extension RideDetailsViewController : RideDetailsSwitchCellDelegate{
    func state(of rideDetailsSwitchCell: RideDetailsSwitchCell, is on: Bool) {
        if (rideDetailsSwitchCell == bookNowCell && !on){
            let alert = UIAlertController(title: "Choose date & time", message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
            alert.isModalInPopover = true

            prebookRideDatePickerView.minimumDate = Date().addingTimeInterval(40 * 60)
            alert.view.addSubview(prebookRideDatePickerView)

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak self] (UIAlertAction) in
                self?.bookNowCell.on = true
            }))
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] (UIAlertAction) in
                self?.prebookRideDate = self?.prebookRideDatePickerView.date
            }))
            self.present(alert,animated: true, completion: nil )
        }
    }
}
