//
//  LocationAnnotationNodeModel.swift
//  ARKitCoreLocationTrial
//
//  Created by Guy Daher on 18/09/2017.
//  Copyright © 2017 OrganisationName. All rights reserved.
//

import Foundation
import MapKit

class LocationAnnotationNodeModel {
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    var altitude: CLLocationDistance
    var name: String
    
    init(latitude: CLLocationDegrees, longitude: CLLocationDegrees, altitude: CLLocationDistance, name: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
        self.name = name
    }
}
