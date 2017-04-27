//
//  DistanceUnit.swift
//  IGCViewer
//
//  Created by Lukas Bischof on 27.04.17.
//  Copyright © 2017 Lukas Bischof. All rights reserved.
//

import Cocoa

infix operator ~

class DistanceUnit: NSObject {
    fileprivate static let FOOT = 3.280839895
    fileprivate static let SEAMILE = 0.000539956803
    fileprivate static let MILE = 0.000621371192
    
    private var _meters: Double = 0.0
    
    init(meters: Double) {
        self._meters = meters
    }
    
    init(feet: Double) {
        _meters = feet / DistanceUnit.FOOT
    }
    
    init(seamiles: Double) {
        _meters = seamiles / DistanceUnit.SEAMILE
    }
    
    init(miles: Double) {
        _meters = miles / DistanceUnit.MILE
    }
    
    var meters: Double {
        get {
            return self._meters
        }
    }
    
    var feet: Double {
        get {
            return self._meters * DistanceUnit.FOOT
        }
    }
    
    var seamiles: Double {
        get {
            return self._meters * DistanceUnit.SEAMILE
        }
    }
    
    var miles: Double {
        get {
            return self._meters * DistanceUnit.MILE
        }
    }
    
    var kilometers: Double {
        get {
            return (self._meters / 1_000.0)
        }
    }
    
    static public func +(left: DistanceUnit, right: DistanceUnit) -> DistanceUnit {
        return DistanceUnit(meters: left.meters + right.meters)
    }
    
    static public func -(left: DistanceUnit, right: DistanceUnit) -> DistanceUnit {
        return DistanceUnit(meters: left.meters - right.meters)
    }
    
    static public func *(left: DistanceUnit, right: DistanceUnit) -> DistanceUnit {
        return DistanceUnit(meters: left.meters * right.meters)
    }
    
    static public func /(left: DistanceUnit, right: DistanceUnit) -> DistanceUnit {
        return DistanceUnit(meters: left.meters / right.meters)
    }
    
    static prefix func -(unit: DistanceUnit) -> DistanceUnit {
        return DistanceUnit(meters: -unit.meters)
    }
    
    static func ==(left: DistanceUnit, right: DistanceUnit) -> Bool {
        return left.meters == right.meters
    }
    
    static func !=(left: DistanceUnit, right: DistanceUnit) -> Bool {
        return left.meters != right.meters
    }
    
    static public func +=(left: inout DistanceUnit, right: DistanceUnit) -> Void {
        left = left + right
    }
    
    static public func ~(left: DistanceUnit, right: DistanceUnit) -> Bool {
        return round(left.meters) == round(right.meters)
    }
}

extension Double {
    var m: DistanceUnit {
        get {
            return DistanceUnit(meters: self)
        }
    }
    
    var ft: DistanceUnit {
        get {
            return DistanceUnit(feet: self)
        }
    }
    
    var mi: DistanceUnit {
        get {
            return DistanceUnit(miles: self)
        }
    }
    
    var nm: DistanceUnit {
        get {
            return DistanceUnit(seamiles: self)
        }
    }
}
