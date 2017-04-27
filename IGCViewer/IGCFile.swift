//
//  IGCFile.swift
//  IGCViewer
//
//  Created by Lukas Bischof on 26.04.17.
//  Copyright © 2017 Lukas Bischof. All rights reserved.
//

import Cocoa
import CoreLocation

class IGCHeader: NSObject {
    var pic: String?
    var secondPilot: String?
    var gliderType: String?
    var gliderRegistration: String?
    var gpsDate: String?
    var gpsModelDesc: String?
    var loggerFirmwareRevision: String?
    var loggerHardwareRevisionNumber: String?
    var loggerType: String?
    var pressureSensorDesc: String?
    var finNumber: String?
    var gliderClassification: String?
    var recordingDate: Date?
    var fixAccuracy: Int = 500
    
    override var description: String {
        get {
            return  "<IGCHeader: \n\t\t" +
                    "PIC: \(String(describing: pic)), \n\t\t" +
                    "second pilot: \(String(describing: secondPilot)), \n\t\t" +
                    "gliderType: \(String(describing: gliderType)), \n\t\t" +
                    "gliderRegistration: \(String(describing: gliderRegistration)), \n\t\t" +
                    "gpsDate: \(String(describing: gpsDate)), \n\t\t" +
                    "gpsModelDesc: \(String(describing: gpsModelDesc)), \n\t\t" +
                    "loggerFirmwareRevision: \(String(describing: loggerFirmwareRevision)), \n\t\t" +
                    "loggerHardwareRevisionNumber: \(String(describing: loggerHardwareRevisionNumber)), \n\t\t" +
                    "loggerType: \(String(describing: loggerType)), \n\t\t" +
                    "pressureSensorDesc: \(String(describing: pressureSensorDesc)), \n\t\t" +
                    "finNumber: \(String(describing: finNumber)), \n\t\t" +
                    "recordingDate: \(String(describing: recordingDate)), \n\t\t" +
                    "fixAccuracy: \(fixAccuracy)m, \n\t\t" +
                    "gliderClassification: \(String(describing: gliderClassification)), \n\t" +
                    ">";
        }
    }
}

class IGCFile: NSObject {
    var manufacutrerCode: String = "XXX"
    var header: IGCHeader = IGCHeader()
    var waypoints: [IGCWaypoint] = []
    var totalDistance: DistanceUnit = 0.m
    
    func process() {
        for i in 1..<waypoints.count {
            let waypoint = waypoints[i]
            let previousWaypoint = waypoints[i-1]
            
            let previousCoord = CLLocation(latitude: CLLocationDegrees(previousWaypoint.latitude), longitude: CLLocationDegrees(previousWaypoint.longitude))
            let currentCoord = CLLocation(latitude: CLLocationDegrees(waypoint.latitude), longitude: CLLocationDegrees(waypoint.longitude))
            let distance = currentCoord.distance(from: previousCoord)
            waypoint.distanceSinceLastWaypoint = distance.m
            
            totalDistance += distance.m
        }
    }
    
    override var description: String {
        get {
            return  "<IGCFile: \n\t" +
                    "manufacturerCode: \(String(describing: manufacutrerCode)), \n\t" +
                    "header: \(String(describing: header)), \n\t" +
                    //"waypoints: \(String(describing: waypoints)), \n" +
                    ">";
        }
    }
}
