//
//  CustomChartTimeFormatter.swift
//  IGCViewer
//
//  Created by Lukas Bischof on 29.05.17.
//  Copyright © 2017 Lukas Bischof. All rights reserved.
//

import Cocoa
import Charts

class CustomXAxisTimeFormatter: NSObject, IAxisValueFormatter {
    override init() {
        
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return formatTime(date: Date(timeIntervalSince1970: TimeInterval(value)), renderSeconds: false)
    }
}

class CustomYAxisAltitudeFormatter: NSObject, IAxisValueFormatter {
    override init() {
        
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return "\(Int(value))m"
    }
}
