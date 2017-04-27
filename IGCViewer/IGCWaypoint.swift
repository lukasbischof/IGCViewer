//
//  IGCWaypoint.swift
//  IGCViewer
//
//  Created by Lukas Bischof on 26.04.17.
//  Copyright © 2017 Lukas Bischof. All rights reserved.
//

import Cocoa
import MapKit


enum ValidityFix {
    case fix3D
    case fix2D
}

class IGCWaypoint: IGCPoint {
    var date: Date
    var fixValidity: ValidityFix
    var pressureAltitude: Float
    var gnssAltitude: Float
    var distanceSinceLastWaypoint: DistanceUnit?

    init(latitude: Float, longitude: Float, date: Date, validityFix: String, pressureAltitude: Float, gnssAltitude: Float) {
        if (validityFix.lowercased() == "a") {
            self.fixValidity = .fix3D
        } else {
            self.fixValidity = .fix2D
        }
        
        self.pressureAltitude = pressureAltitude
        self.gnssAltitude = gnssAltitude
        self.date = date
        
        super.init(latitude: latitude, longitude: longitude)
    }
    
    override var description: String {
        get {
            return "<IGCWaypoint: point: \(super.description), fixValidity: \(fixValidity), pressAlt: \(pressureAltitude), gnssAlt: \(gnssAltitude)>"
        }
    }
}
