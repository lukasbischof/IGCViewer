//
//  ViewController.swift
//  IGCViewer
//
//  Created by Lukas Bischof on 26.04.17.
//  Copyright © 2017 Lukas Bischof. All rights reserved.
//

import Cocoa
import MapKit

class ViewController: NSViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var document: IGCDocument!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        mapView.delegate = self
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
        
        var points: [CLLocationCoordinate2D] = []
        for waypoint in document.igcFile.waypoints {
            let coord = CLLocationCoordinate2D(latitude: CLLocationDegrees(waypoint.latitude), longitude: CLLocationDegrees(waypoint.longitude))
            points.append(coord)
        }
        
        let polyline = MKGeodesicPolyline(coordinates: points, count: points.count)
        mapView.add(polyline)
        
        let padding = CGFloat(10.0)
        let insets = EdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        self.mapView.setVisibleMapRect(polyline.boundingMapRect, edgePadding: insets, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = NSColor.blue
            polylineRenderer.lineWidth = 4
            return polylineRenderer
        }
        
        return MKOverlayRenderer(overlay: overlay)
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }


}

