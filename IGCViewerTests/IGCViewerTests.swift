//
//  IGCViewerTests.swift
//  IGCViewerTests
//
//  Created by Lukas Bischof on 26.04.17.
//  Copyright © 2017 Lukas Bischof. All rights reserved.
//

import XCTest
@testable import IGCViewer

class IGCViewerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDistanceUnit() {
        let h = 3.0.m + 2.0.m
        XCTAssert(h.meters == 5.0, "3m + 2m != 5m")
        
        XCTAssert(2.0.m * 3.0.m == 6.0.m, "2m * 3m != 6m")
        XCTAssert(25.0.nm ~ 46300.0.m, "25NM != 46300m")
        XCTAssert(752.0.ft ~ 229.21.m, "752ft != 229.21m")
        XCTAssert(2000.m.kilometers == 2.0, "2000m != 2km")
    }
    
    func testStringRegexExtension() {
        /** FIRST **/
        var matches = "FDTE230417" ~> "FDTE(\\d{2})(\\d{2})(\\d{2})"
        print(matches)
        
        XCTAssert(matches.count == 3, "Matches count != 3")
        
        XCTAssert(matches[0] == "23", "First match is not 23")
        XCTAssert(matches[1] == "04", "Second match is not 04")
        XCTAssert(matches[2] == "17", "Third match is not 17")
        
        
        
        /** SECOND **/
        matches = "1budu8Wie2Gehts" ~> "\\d([^\\d]+)"
        XCTAssert(matches.count == 3, "Matches count != 3")
        
        XCTAssert(matches[0] == "budu", "First match is not budu")
        XCTAssert(matches[1] == "Wie", "Second match is not Wie")
        XCTAssert(matches[2] == "Gehts", "Third match is not Gehts")
        
        
        /** THIRD **/
        matches = "Dies ist ein Test. Ein normaler Test. " ~> "(Test)"
        XCTAssert(matches.count == 2, "Matches count != 2")
        
        XCTAssert(matches[0] == "Test", "First match is not Test")
        XCTAssert(matches[1] == "Test", "Second match is not Test")
        
        
        /** FOURTH **/
        matches = "FGPSMarconi,SuperX,12ch,10000m" ~> "^FGPS(.+)"
        XCTAssert(matches[0] == "Marconi,SuperX,12ch,10000m", "First match is not Marconi,SuperX,12ch,10000m")
    }
}
