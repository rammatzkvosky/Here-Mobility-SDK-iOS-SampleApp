//
// Copyright © 2018 HERE Global B.V. All rights reserved.
//

import UIKit
import HereSDKMapKit
import HereSDKDemandKit

class GetRidesViewController : UIViewController{

    //MARK : HereSDKMapKit related

    // mapkit services client
    internal let mapService = HereSDKMapService()

    //data presented in geocode results table view
    internal var geocodeResults = [HereSDKGeocodeResult]()
    // origin geocode result
    internal var originGeocodeResult : HereSDKGeocodeResult?
    // destination geocode result
    internal var destinationGeocodeResult : HereSDKGeocodeResult?

    // mapView presented in view
    @IBOutlet weak var mapView: HereSDKMapView!
    // annotation that represent origin location
    internal var originAnnotation :  HereSDKPointAnnotation?
    // annotation that represent destination location
    internal var destinationAnnotation :  HereSDKPointAnnotation?
    // displayed route if origin & destination geocode results exist
    internal var displayedRoutePolyline : HereSDKPolyline?

    @IBOutlet weak var showFutureRidesButton: UIButton!

    internal var prebookedRides : [HereSDKDemandRide] = []

    @IBOutlet weak var originTextView: UITextView!
    @IBOutlet weak var destinationTextView: UITextView!
    private var currentTextView = UITextView()

    @IBOutlet weak var geocodeResultsTableView: UITableView!

    internal var locationInLondon : CLLocation?
    static var londonCoordinate =  CLLocationCoordinate2D(latitude: 51.509865, longitude: -0.118092)

    override func viewDidLoad() {
        super.viewDidLoad()

        originTextView.delegate = self
        destinationTextView.delegate = self

        self.locationInLondon = CLLocation(latitude : GetRidesViewController.londonCoordinate.latitude, longitude : GetRidesViewController.londonCoordinate.longitude)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true

        getRides()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard let segueIdentifier = segue.identifier else { return }
        switch segueIdentifier {
        case RideDetailsViewController.segueId:
            let controller = segue.destination as! RideDetailsViewController
            controller.originGeocodeResult = self.originGeocodeResult
            controller.destinationGeocodeResult = self.destinationGeocodeResult

        default:
            break
        }
    }

    func addAnnotationToMap(geocodeResult : HereSDKGeocodeResult, isOrigin : Bool){
        let coordinate = CLLocationCoordinate2D(latitude : geocodeResult.center.latitude, longitude : geocodeResult.center.longitude)
        // update exist annotation
        if let annotation = isOrigin ? self.originAnnotation : self.destinationAnnotation{
            annotation.coordinate = coordinate
        }
        else{
            //create new annotation
            let annotation = HereSDKPointAnnotation(coordinate: coordinate)
            if (isOrigin){
                self.originAnnotation = annotation
                self.mapView.setCenter(annotation.coordinate, animated: true)
            }
            else{
                self.destinationAnnotation = annotation
            }
            // add new annotation to map
            self.mapView.addAnnotation(annotation)
        }
    }

    @IBAction func futureRidesButtonPressed(_ sender: UIButton) {
        if (self.prebookedRides.count > 0){
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let futureRidesVC : FutureRideOffersViewControllers = storyboard.instantiateViewController(withIdentifier: "FutureRideOffersViewController") as! FutureRideOffersViewControllers
            self.navigationController?.pushViewController(futureRidesVC, animated: true)
            futureRidesVC.rides = self.prebookedRides
        }
    }
}

extension GetRidesViewController : UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        currentTextView = textView
        textView.text = ""
    }

    func textViewDidChange(_ textView: UITextView) {
        requestGeocodeResults(query : textView.text)
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

extension GetRidesViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.geocodeResultsTableView.isHidden = self.geocodeResults.count == 0
        return geocodeResults.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        currentTextView.text = geocodeResults[indexPath.row].address
        if currentTextView == originTextView
        {
            originGeocodeResult = geocodeResults[indexPath.row]
            self.addAnnotationToMap(geocodeResult: originGeocodeResult!, isOrigin: true)
        }
        else
        {
            destinationGeocodeResult = geocodeResults[indexPath.row]
            self.addAnnotationToMap(geocodeResult: destinationGeocodeResult!, isOrigin: false)
        }
        tryDisplayRoute()
        geocodeResults = []
        geocodeResultsTableView.reloadData()
        currentTextView.resignFirstResponder()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GeocodeResultTableViewCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = geocodeResults[indexPath.row].address
        return cell
    }
}


