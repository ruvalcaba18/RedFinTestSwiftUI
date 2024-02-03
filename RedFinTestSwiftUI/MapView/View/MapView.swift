//
//  MapView.swift
//  RedFinTestSwiftUI
//
//  Created by Jael on 02/02/2024.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @State var SanFranciscoRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @StateObject private var viewModel = MapViewModel()
    @Binding var isBackToList:Bool

    
    var body: some View {
        VStack {
            
            Map(coordinateRegion: $SanFranciscoRegion, showsUserLocation: true, annotationItems: viewModel.foodTruckAnnotations) { annotation in
                MapAnnotation(coordinate: annotation.coordinate) {
                    PlaceAnnotationView(place: annotation)
                        .onTapGesture {
                            viewModel.selectedFoodTruck = annotation
                        }
                }
            }
            if let place = viewModel.selectedFoodTruck {
                         HStack {
                             VStack(spacing: 10) {
                                 Text(place.name)
                                     .font(.headline)
                                 Text(place.street ?? "N/A")
                                     .font(.subheadline)
                                 Text(place.placeDescription ?? "N/A")
                                     .font(.body)
                             }
                             Text("\(place.startHour ?? "") AM - \(place.endHour ?? "") PM")
                                 .font(.body)
                                 .frame(width: 75)
                         }
                     }
        }
        .task {
            await viewModel.retrieveNearFoodTrucks()
        }
        .navigationTitle("Food Truck")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("List") {
                    isBackToList.toggle()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    MapView(isBackToList: .constant(false))
}
