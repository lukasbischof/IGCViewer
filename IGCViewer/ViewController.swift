//
//  ViewController.swift
//  IGCViewer
//
//  Created by Lukas Bischof on 26.04.17.
//  Copyright © 2017 Lukas Bischof. All rights reserved.
//

import Cocoa
import MapKit
import Charts

enum ViewControllerError: Error {
    case noRecordingDateSpecified
}

class ViewController: NSViewController, MKMapViewDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var titleTextField: NSTextField!
    @IBOutlet weak var pilotTextField: NSTextField!
    @IBOutlet weak var coPilotTextField: NSTextField!
    @IBOutlet weak var aircraftTextField: NSTextField!
    @IBOutlet weak var registrationTextField: NSTextField!
    @IBOutlet weak var classificationTextField: NSTextField!
    @IBOutlet weak var startTextField: NSTextField!
    @IBOutlet weak var endTextField: NSTextField!
    @IBOutlet weak var durationTextField: NSTextField!
    @IBOutlet weak var avgSpeedTextField: NSTextField!
    @IBOutlet weak var distanceTextField: NSTextField!
    
    @IBOutlet weak var pressureAltTextField: NSTextField!
    @IBOutlet weak var gnssAltTextField: NSTextField!
    @IBOutlet weak var varioTextField: NSTextField!
    @IBOutlet weak var latitudeTextField: NSTextField!
    @IBOutlet weak var longitudeTextField: NSTextField!
    @IBOutlet weak var timeTextField: NSTextField!
    
    @IBOutlet weak var slider: NSSlider!
    @IBOutlet weak var backButton: NSButton!
    @IBOutlet weak var forwardButton: NSButton!

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var chartsView: LineChartView!
    
    // MARK: Instance Vars
    var document: IGCDocument!
    var occurredError: Error?
    var annotation: MKPointAnnotation!
    var currentWaypointIndex: Int = 0
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        mapView.delegate = self
        mapView.layer?.borderColor = NSColor.lightGray.cgColor
        mapView.layer?.borderWidth = 1.0
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        if let doc = self.view.window?.windowController?.document as? IGCDocument {
            document = doc
        } else {
            #if DEBUG
                print(">>> Can't access document!")
            #else
                assert(false)
            #endif
        }
        
        // *** DRAW LINE
        var points: [CLLocationCoordinate2D] = []
        for waypoint in document.igcFile.waypoints {
            let coord = CLLocationCoordinate2D(latitude: CLLocationDegrees(waypoint.latitude), longitude: CLLocationDegrees(waypoint.longitude))
            points.append(coord)
        }
        
        let polyline = MKGeodesicPolyline(coordinates: points, count: points.count)
        mapView.add(polyline)
        
        // *** CENTER PATH
        let padding = CGFloat(10.0)
        let insets = NSEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        self.mapView.setVisibleMapRect(polyline.boundingMapRect, edgePadding: insets, animated: true)
        
        // *** COMPUTE ADDITIONAL FLIGHT INFORMATION
        // TODO: Async with loading indicator
        document.igcFile.process()
        updateStaticInformationLabels()
        
        
        // *** UI SETUP
        slider.minValue = 0
        slider.maxValue = Double(document.igcFile.waypoints.count - 1)
        
        // Chart
        let dataEntries = document.igcFile.waypoints.map { (waypoint) -> ChartDataEntry in
            return ChartDataEntry(x: waypoint.date.timeIntervalSince1970, y: Double(waypoint.pressureAltitude))
        }
        
        let data = LineChartData()
        let ds1 = LineChartDataSet(values: dataEntries, label: nil)
        ds1.colors = [NSUIColor.red]
        ds1.mode = .linear
        ds1.drawCirclesEnabled = false
        ds1.drawValuesEnabled = false
        ds1.lineWidth = 2
        data.addDataSet(ds1)
        
        chartsView.data = data
        chartsView.gridBackgroundColor = NSUIColor.white
        chartsView.chartDescription?.text = ""
        chartsView.xAxis.valueFormatter = CustomXAxisTimeFormatter()
        chartsView.leftYAxisRenderer.axis?.valueFormatter = CustomYAxisTimeFormatter()
        
        // *** CREATE ANNOTATION
        annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(document.igcFile.waypoints[0].latitude), longitude: CLLocationDegrees(document.igcFile.waypoints[0].longitude))
        annotation.title = "You"
        mapView.addAnnotation(annotation)
        
        changeCurrentWaypointIndex(0)
    }
    
    // MARK: - UI Methods
    func updateStaticInformationLabels() {
        guard let recordingDate = document.igcFile.header.recordingDate else {
            occurredError = ViewControllerError.noRecordingDateSpecified
            return
        }
        
        // WARNING: Check if there are at least two waypoints
        let firstEntry = document.igcFile.waypoints[0]
        let lastEntry = document.igcFile.waypoints[document.igcFile.waypoints.count - 1]
        let duration = lastEntry.date.timeIntervalSince1970 - firstEntry.date.timeIntervalSince1970
        
        titleTextField.stringValue = "Flight on \(formatDate(date: recordingDate))"
        pilotTextField.stringValue = document.igcFile.header.pic ?? "???"
        coPilotTextField.stringValue = document.igcFile.header.secondPilot ?? "-"
        aircraftTextField.stringValue = document.igcFile.header.gliderType ?? "?"
        registrationTextField.stringValue = document.igcFile.header.gliderRegistration ?? "?"
        classificationTextField.stringValue = document.igcFile.header.gliderClassification ?? "?"
        startTextField.stringValue = formatTime(date: firstEntry.date)
        endTextField.stringValue = formatTime(date: lastEntry.date)
        durationTextField.stringValue = duration.getFormattedTime()
        distanceTextField.stringValue = "\(String(format: "%.1f", document.igcFile.totalDistance.kilometers))km"
    }
    
    func changeCurrentWaypointIndex(_ newIndex: Int) {
        currentWaypointIndex = newIndex
        let currentWaypoint = document.igcFile.waypoints[currentWaypointIndex]
        
        annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(currentWaypoint.latitude), longitude: CLLocationDegrees(currentWaypoint.longitude))
        
        pressureAltTextField.stringValue = "\(String(format: "%.1f", currentWaypoint.pressureAltitude))m.ü.M"
        gnssAltTextField.stringValue = "\(String(format: "%.1f", currentWaypoint.gnssAltitude))m.ü.M"
        timeTextField.stringValue = formatTime(date: currentWaypoint.date)
        
        if newIndex == 0 {
            backButton.isEnabled = false
        } else if !backButton.isEnabled {
            backButton.isEnabled = true
        }
        
        if newIndex == document.igcFile.waypoints.count - 1 {
            forwardButton.isEnabled = false
        } else if !forwardButton.isEnabled {
            forwardButton.isEnabled = true
        }
    }
    
    // MARK: - MKMapView delegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = NSColor.blue
            polylineRenderer.lineWidth = 2
            return polylineRenderer
        }
        
        return MKOverlayRenderer(overlay: overlay)
    }
    
    // MARK: - User interaction
    @IBAction func sliderValueChanged(_ sender: NSObject) {
        if sender is NSSlider {
            changeCurrentWaypointIndex((sender as! NSSlider).integerValue)
        } else if #available(macOS 10.12.2, *), sender is NSSliderTouchBarItem {
            let newValue = (sender as! NSSliderTouchBarItem).slider.integerValue
            changeCurrentWaypointIndex(newValue)
            self.slider.integerValue = newValue
        }
    }
    
    @IBAction func backButtonPressed(_ sender: NSButton) {
        changeCurrentWaypointIndex(max(currentWaypointIndex - 1, 0))
    }
    
    @IBAction func forwardButtonPressed(_ sender: NSButton) {
        changeCurrentWaypointIndex((currentWaypointIndex + 1) % document.igcFile.waypoints.count)
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}
