# HERE Mobility SDK iOS - Sample App

HERE Mobility offers technological solutions to all transportation service providers, businesses, and consumers through the creation of a revolutionary mobility marketplace.
The HERE Mobility SDK enables developers to create and enrich apps with a variety of mobility functionalities while relying on data from the HERE’s leading location platform, and connection to the HERE Mobility Marketplace.
Here Mobility sample app presents a simple workflow for creating mobile applications that offers a variety of mobility services to your users within the application context.



## This repository contains the Sample application showing the use of the HERE Mobility SDK for iOS.

[HereSDKMapKit documentation](#here-sdk-map-kit)

[HereSDKDemandKit documentation](#here-sdk-demand-kit)

[Sample app flow](#sample-app-flow)

# Pre-request

App ID key and App secret key are mandatory for using Demand SDK, contact us by [mobility_developers@here.com]()

# Getting Started


```bash
# Clone this repository
$ git clone https://github.com/HereMobilityDevelopers/Here-Mobility-SDK-iOS-SampleApp.git
# Run pod update
$ pod update
# Set HereMobilitySDKAppId & HereMobilitySDKAppSecret at Info.plist
# Run sampleApp.xcworkspace 
```

# Sample App Flow

 |`UseCase` | `Description` | `Documentation` |
 | ------------- |-------------| -----|
 |forward geocoding & routing | get geocoding results and add route to map | [example](#forward-geocoding--route)|
 |get demand offers | get demand or public transit offers| [example](#get-demand-offers)|
 |book a ride| book received demand offer| [example](#book-demand-ride-based-on-demand-offer)|
 |get ride updates | receive updates about the ride| [example](#get-updates-based-on-booked-ride)|
 
 



## Forward geocoding & route

MapKit features Geocoding (the computational process of transforming a address description to a location on the Earth's surface), and Route (Polyline added to mapview that represent the suggested route from origin to destination).

![Forward GeoCode Location And Route](Assets/ForwardGeolocationAndRoute.gif)

### Receive geocode result based on text query and location coordinate.


```swift 
func requestGeocodeResults(query: String) {
        guard let lastLocation = lastLocation else { return }
        mapService.geocodeQuery(query,
                                forlocation: lastLocation,
                                resultType: .place, 
                                countryCode: "") { [weak self] (results, error) in
                                    if error != nil {
                                    	// handle error
                                    }
                                    else {
                                    	// handle geocode result
                                    }
        }
    }
```

### Receive route based on geocode results.

```swift
if let originGeocodeResult = self.originGeocodeResult, let destinationGeocodeResult = self.destinationGeocodeResult{
	let startLocation = CLLocation(latitude: originGeocodeResult.center.latitude , longitude: originGeocodeResult.center.longitude)
	let endLocation = CLLocation(latitude: destinationGeocodeResult.center.latitude , longitude: destinationGeocodeResult.center.longitude{
            if let routeRequest = HereSDKRouteRequest(points: [startLocation, endLocation]){
                mapService.getRoutesWith(routeRequest, andHandler: {  [weak self] routes, error in
                    if (error == nil){
                        if let firstRoute = routes?.first{
                        	// handle route
                        }
                    }
                    else{
                    	// handle error
                    }
                })
            }
        }
    
```

## Get demand offers

DemandKit features various transportation offers based on requested route.

![Get Demand Offers](Assets/GetOffers.gif)

### Get full address data based on geocode address id 

```swift
mapService.getAddressData(withAddressId: originAddressId, andHandler: { (addressData, error) in
            if (error != nil){
            	// handle error
            }
            else{
            	// handle address data
            }
        })
```

### Create demand route with geocode & address data results

```swift
let originDemandLocation = HereSDKDemandLocation(location: originCLLocation,
						  address: originAddressData, 
						 freeText: nil)
let destinationDemandLocation = HereSDKDemandLocation(location: destinationCLLocation,
 	 					       address: destinationAddressData, 
						      freeText: nil)
return HereSDKDemandRoute(pickupLocation: originDemandLocation,
		     destinationLocation: destinationDemandLocation)
```

### Create demand offers request with demand route 

```swift
HereSDKDemandRideOffersRequest(offersWith: demandRoute, 
			      constraints: nil,
			prebookPickupTime: nil, 
			       priceRange: nil, 
				 sortType: .unknown, 
			    passengerNote: "",
			   transitOptions: nil 
							  	)
```

###  Get demand offers based on demand offers request.

```swift
HereSDKDemandManager.shared.requestRide(rideRequest) { [weak self] offers, error in
                if (error != nil){
                    // handle error
                }
                if let offers = offers{
                    // handle offers
                }
            }
```


### Choose between demand ride offers and public transport offers


```swift 
switch offer.getTransitType() {
        case .taxi:
            // handle demand ride offer
        case .publicTransport:
           // handle public transport
        }
```

## Book demand ride based on demand offer

### Create passenger note details

```swift
 HereSDKDemandPassenger(name: "Passenger name",
                 phoneNumber: "+9721234567",
                    photoUrl: "",
		      email : "")
```

### Book ride based on ride offer & passenger details

```swift
let demandRideRequest = HereSDKDemandRideRequest(offerId: rideOffer.offerId,
                                        passengerDetails: passengerDetails)
        HereSDKDemandManager.shared.createRide(with: demandRideRequest) { [weak self] ride, error in
            if error != nil {
		//handle error
            }
            else{
            	//handle booked ride
            }
        }
```

## Get updates based on booked ride

### receive rides updates (ride status, ride location updates, ETA...)

![Ride Updates](Assets/RideUpdates.gif)

### register for ride updates

```swift
 HereSDKDemandManager.shared.registerForRidesUpdates(with: self)
```

```swift
extension UIViewController: HereSDKDemandRidesUpdatesDelegate {
func didReceiveUpdate(_ statusLog: HereSDKDemandRideStatusLog!, for ride: HereSDKDemandRide!) {
	// handle ride updates stasusses
}

func didReceive(_ location: HereSDKDemandRideLocation!, for ride: HereSDKDemandRide!) {
 	//handle ride location update
}

 func didReceiveUpdateError(_ error: Error!, forRideId rideId: String!) {
 	// handle error
 }
```


## Here Sdk Map Kit

[Documentation](https://heremobilitydevelopers.github.io/Here-Mobility-SDK-iOS/HereSDKMapKit/)

## Here SDK Demand Kit

[Documentation](https://heremobilitydevelopers.github.io/Here-Mobility-SDK-iOS/HereSDKDemandKit/)

# Getting Help

contact our support team [mobility_support_internal@here.com](mailto:mobility_support_internal@here.com)

# Licence

[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)