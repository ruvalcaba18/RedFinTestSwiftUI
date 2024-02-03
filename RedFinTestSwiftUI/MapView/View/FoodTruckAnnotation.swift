//
//  FoodTruckAnnotation.swift
//  RedFinTestSwiftUI
//
//  Created by Jael on 02/02/2024.
//

import Foundation
import SwiftUI

struct PlaceAnnotationView: View {
    var place: Place
  var body: some View {
    VStack(spacing: 0) {
      Image(systemName: "mappin.circle.fill")
        .font(.title)
        .foregroundColor(.red)
      
      Image(systemName: "arrowtriangle.down.fill")
        .font(.caption)
        .foregroundColor(.red)
        .offset(x: 0, y: -5)
    }
  }
}
