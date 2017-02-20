//
//  SetupAnnotation.swift
//  GeoFence FrameWork
//
//  Created by Killvak on 16/02/2017.
//  Copyright © 2017 Killvak. All rights reserved.
//

import Foundation
import CoreLocation
extension SetUpAnnotations :CLLocationManagerDelegate{

    /**
     With the location manager properly configured, the next order of business is to allow your app to register user geofences for monitoring.
     In your app, the user geofence information is stored within your custom Geotification model. However, Core Location requires each geofence to be represented as a CLCircularRegion instance before it can be registered for monitoring. To handle this requirement, you’ll create a helper method that returns a CLCircularRegion from a given Geotification object.
     */
    func region(withGeotification geotification: Geotification) -> CLCircularRegion {
        // 1
        let region = CLCircularRegion(center: geotification.coordinate, radius: geotification.radius, identifier: geotification.identifier)
        // 2
        region.notifyOnEntry = (geotification.eventType == .onEntry)
        region.notifyOnExit = region.notifyOnEntry
        return region
    }
    
    /**
     method to start monitoring a given geotification whenever the user adds one
     - isMonitoringAvailableForClass(_:) determines if the device has the required hardware to support the monitoring of geofences. If monitoring is unavailable, you bail out entirely and alert the user accordingly. showSimpleAlertWithTitle(_:message:viewController) is a helper function in Utilities.swift that takes in a title and message and displays an alert view.
     - Next, you check the authorization status to ensure that the app has also been granted the required permission to use Location Services. If the app isn’t authorized, it won’t receive any geofence-related notifications.
     However, in this case, you’ll still allow the user to save the geotification, since Core Location lets you register geofences even when the app isn’t authorized. When the user subsequently grants authorization to the app, monitoring for those geofences will begin automatically.
     - You create a CLCircularRegion instance from the given geotification using the helper method region(:)->CLCircularRegion.
     - Finally, you register the CLCircularRegion instance with Core Location for monitoring.
     */
    func startMonitoring(geotification: Geotification,locationManager : CLLocationManager) {
        // 1
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            print( "Geofencing is not supported on this device!")
            return
        }
        // 2
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            print( "Your geotification is saved but will only be activated once you grant Geotify permission to access the device location.")
        }
        // 3
        let region = self.region(withGeotification: geotification)
        // 4
        locationManager.startMonitoring(for: region)
    }
    /**
     The method simply instructs the locationManager to stop monitoring the CLCircularRegion associated with the given geotification
     */
    func stopMonitoring(geotification: Geotification,locationManager : CLLocationManager) {
        for region in locationManager.monitoredRegions {
            guard let circularRegion = region as? CLCircularRegion, circularRegion.identifier == geotification.identifier else { continue }
            locationManager.stopMonitoring(for: circularRegion)
        }
    }


}