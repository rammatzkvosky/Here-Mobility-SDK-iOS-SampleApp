//
// Copyright © 2018 HERE Global B.V. All rights reserved.
//

import UIKit
import HereSDKMapKit
import HereSDKDemandKit

class SDKGetRidesViewController: GetRidesViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // optional - if not specified default coordinate is Berlin
        self.mapView.centerCoordinate = GetRidesViewController.londonCoordinate;
        // optional - if not specified default zoom is 15.3999996
        self.mapView.zoom = 17;
        // required - map updates
        self.mapView.delegate = self;
        // set self.mapView.showUserLocation(true) to show user location on map
        // self.mapView.showUserLocation(true)
    }

    // example of adding annotation to map
    func addAnnotationToMapView(coordinate : CLLocationCoordinate2D){
        self.mapView.addAnnotation(HereSDKPointAnnotation (coordinate: coordinate))
    }
}

extension GetRidesViewController {

    func getRides(){
        HereSDKDemandManager.shared.getRides(getHereSDKDemandRideQuery()) { [weak self] (result, error ) in
            if (error == nil){
                if result.ridesArray.count > 0{
                    print("Got \(result.ridesArray.count) rides from getRides")
                    self?.prebookedRides = result.ridesArray
                    self?.showFutureRidesButton.isHidden = false
                }
                else{
                    print("Got 0 rides from getRides")
                    self?.showFutureRidesButton.isHidden = true
                }
            }
            else{
                if (error?.code == -1){ //user authentication required
                    self?.showUserNameMissingAlert()
                }
            }
        }
    }

    func getHereSDKDemandRideQuery() -> HereSDKDemandRideQuery{
        // we set time Interval to the past - in case a new prebook was generated
        return HereSDKDemandRideQuery.init(updateTime: Date().addingTimeInterval(60 * 30 * -1), limit: 100, statusFilter: .future,  sortBy: .createTimeAsc)
    }

    func requestGeocodeResults(query: String) {
        guard let locationInLondon = locationInLondon else { return }
        mapService.geocodeQuery(query,
                                forlocation: locationInLondon,
                                resultType: .place,
                                countryCode: "") { [weak self] (results, error) in
                                    if error == nil {
                                        debugPrint("SDK Request [GeocodeQuery] succeed with \(String(describing: results?.count)) routes")
                                        if let results = results{
                                            guard let strongSelf = self else { return }
                                            strongSelf.geocodeResults = results
                                            strongSelf.geocodeResultsTableView.reloadData()
                                        }
                                    }
                                    else {
                                        debugPrint("SDK Request [GeocodeQuery] failed with error: \(String(describing: error))")
                                    }
        }
    }

    func tryDisplayRoute(){
        if let originGeocodeResult = self.originGeocodeResult, let destinationGeocodeResult = self.destinationGeocodeResult{

            let startLocation = CLLocation(latitude: originGeocodeResult.center.latitude , longitude: originGeocodeResult.center.longitude)
            let endLocation = CLLocation(latitude: destinationGeocodeResult.center.latitude , longitude: destinationGeocodeResult.center.longitude)
            // set to get multiple routes
            // routeRequest.requestAlternativeRoutes = true

            // add location/s to add stop/s
            if let routeRequest = HereSDKRouteRequest(points: [startLocation, endLocation]){
                mapService.getRoutesWith(routeRequest, andHandler: {  [weak self] routes, error in
                    if (error == nil){
                        if let firstRoute = routes?.first{
                            if let polylines = self?.mapView.polylines, let displayedPolyline = self?.displayedRoutePolyline{
                                if polylines.contains(displayedPolyline)
                                {
                                    self?.mapView.removePolyline(displayedPolyline)
                                }
                            }
                            self?.mapView.addPolyline(firstRoute.polyline)
                            self?.displayedRoutePolyline = firstRoute.polyline
                            // bounding box of the route is the rect that contains the polyline
                            let edgeInsets : UIEdgeInsets = UIEdgeInsets(top: 180, left: 20, bottom: 70, right: 10)
                            self?.mapView.setVisibleMapRect(firstRoute.polyline.boundingBox, edgePadding: edgeInsets, animated: true)
                        }
                    }
                    else{
                        debugPrint(error.debugDescription)
                    }
                })
            }
        }
    }

    func showUserNameMissingAlert(){
        let alertViewController = UIAlertController(title: "HereSDK require credentials", message: "Please enter user name", preferredStyle: UIAlertControllerStyle.alert)
        alertViewController.addTextField { (textField) in
            textField.placeholder = "user name"
        }
        let action = UIAlertAction(title: "OK", style: .default) { (alertAction) in
            let textField = alertViewController.textFields![0] as UITextField
            if let username = textField.text{
                let userExpirationInterval: Int32 = 60 * 60 * 24 * 365 // 1 year
                let date = Date().addingTimeInterval(TimeInterval(userExpirationInterval))

                // Generating user token with expiration time of one year from the current date.
                self.generateUserCredentialsWithUser(userId: username, expiration: UInt32(date.timeIntervalSince1970))
            }
        }
        alertViewController.addAction(action)
        self.present(alertViewController, animated: true, completion: nil)

    }

    private func generateHash(appKey: String, userId: String, expiration:UInt32, key: String) -> String? {
        return HMACGenerator.hmacSHA256(from: appKey, userId: userId, expiration: Int32(expiration), withKey: key)
    }

    private func generateUserCredentialsWithUser(userId : String, expiration : UInt32){
        if let infoDictionary = Bundle.main.infoDictionary{
            if let appKey = infoDictionary["HereMobilitySDKAppId"] as? String, let appSecret = infoDictionary["HereMobilitySDKAppSecret"] as? String {
                let hashString = generateHash(appKey: appKey, userId: userId, expiration: expiration, key: appSecret)
                HereSDKManager.shared?.user = HereSDKUser(id: userId, expiration: Date(timeIntervalSince1970 : TimeInterval(expiration)), verificationHash: hashString!)
                getRides()
            }
        }
    }
}

extension SDKGetRidesViewController : HereSDKMapViewDelegate{

    /// indicates that mapview scene (map layout) has been loaded, annotations will be visible on map from that point and map start to load tiles from network.
    //  if there's no network - this still called
    /// - Parameter mapView: HereSDKMapView
    func mapViewDidFinishLoadingMap(_ mapView: HereSDKMapView) {
        debugPrint("SDK MapView finished map loading")
    }

    /// you can enable user location on map with mapView.showUserLocation(true) and get informative description in this callback
    ///
    /// - Parameters:
    ///   - mapView: HereSDKMapView
    ///   - userLocation: userLocationAnnotation that specifies user location
    func mapView(_ mapView: HereSDKMapView, didUpdate userLocationAnnotation: HereSDKUserLocationAnnotation) {
        // handle user location update
    }

    ///  used to set annotation layout after adding annotation to map
    ///
    /// - Parameters:
    ///   - mapView: HereSDKMapView
    ///   - annotation: HereSDKAnnotation
    /// - Returns: HereSDKAnnotationStyle that can customize annotation
    func mapView(_ mapView: HereSDKMapView, styleFor annotation: HereSDKAnnotation) -> HereSDKAnnotationStyle? {
        if annotation === originAnnotation {
            return HereSDKImageAnnotationStyle(image: #imageLiteral(resourceName: "CurrentLocation"))
        } else if annotation === destinationAnnotation {
            let annotationStyle = HereSDKImageAnnotationStyle(image: #imageLiteral(resourceName: "Destination"))
            annotationStyle.anchor = .top
            return annotationStyle
        }

        return nil
    }
}
