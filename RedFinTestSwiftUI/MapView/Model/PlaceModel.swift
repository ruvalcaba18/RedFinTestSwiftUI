//
//  PlaceModel.swift
//  RedFinTestSwiftUI
//
//  Created by Jael on 02/02/2024.
//

import Foundation
import CoreLocation

struct Place: Identifiable {
    let id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
    var startHour:String?
    var endHour:String?
    var placeDescription:String?
    var street:String?
}
