//
//  MapKit+Utilities.swift
//  Canvass
//
//  Created by Bryan on 2/12/19.
//  Copyright © 2019 Bryan Lloyd Anderson. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

extension CLLocation {
    public convenience init(_ coordinate: CLLocationCoordinate2D) {
        self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}
