//
//  File.swift
//  
//
//  Created by Oliver Krakora on 04.11.21.
//

import XCTest
import MapKit
@testable import GooglePolyline

class GooglePolylineTests: XCTestCase {
    
    func testCoordinateEncoding() {
        let coordinates = [CLLocationCoordinate2D(latitude: 38.5, longitude: -120.2)]
        XCTAssertEqual(coordinates.googlePolyline, "_p~iF~ps|U")
    }
    
    func testSingleCoordinateDecoding() throws {
        let coordinates = CLLocationCoordinate2D.coordinates(fromPolyline: "_p~iF~ps|U")
        XCTAssertTrue(coordinates.count == 1)
        let firstCoordinate = try XCTUnwrap(coordinates.first)
        XCTAssertEqual(firstCoordinate.latitude, 38.5)
        XCTAssertEqual(firstCoordinate.longitude, -120.2)
    }
    
    func testPolylineDecoding() {
        let coordinates = CLLocationCoordinate2D.coordinates(fromPolyline: "_keeHmx`cB??iDtH??")
        XCTAssertTrue(coordinates.count == 4)
        XCTAssertTrue(isEqual(coordinates[0], CLLocationCoordinate2D(latitude: 48.20160, longitude: 16.39319)))
        XCTAssertTrue(isEqual(coordinates[1], CLLocationCoordinate2D(latitude: 48.20160, longitude: 16.39319)))
        XCTAssertTrue(isEqual(coordinates[2], CLLocationCoordinate2D(latitude: 48.20245, longitude: 16.39164)))
        XCTAssertTrue(isEqual(coordinates[3], CLLocationCoordinate2D(latitude: 48.20245, longitude: 16.39164)))
    }
    
    func testPolylineEncoding() {
        let points: [CLLocationCoordinate2D] = [
            CLLocationCoordinate2D(latitude: 48.20160, longitude: 16.39319),
            CLLocationCoordinate2D(latitude: 48.20160, longitude: 16.39319),
            CLLocationCoordinate2D(latitude: 48.20245, longitude: 16.39164),
            CLLocationCoordinate2D(latitude: 48.20245, longitude: 16.39164)
        ]
        let encoded = points.googlePolyline
        XCTAssertEqual(encoded, "_keeHmx`cB??iDtH??")
    }
    
    private func isEqual(_ lhs: CLLocationCoordinate2D, _ rhs: CLLocationCoordinate2D) -> Bool {
        return isEqual(lhs.latitude, rhs.latitude) && isEqual(lhs.longitude, rhs.longitude)
    }
    
    private func isEqual(_ lhs: CLLocationDegrees, _ rhs: CLLocationDegrees) -> Bool {
        let lhsInt = Int(lhs * 1E5)
        let rhsInt = Int(rhs * 1E5)
        return lhsInt == rhsInt
    }
}
