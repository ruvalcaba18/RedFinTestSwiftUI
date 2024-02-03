//
//  MainView.swift
//  RedFinTestSwiftUI
//
//  Created by Jael on 02/02/2024.
//

import SwiftUI

struct MainView: View {
    
    @StateObject private var viewModel = MainViewModel()
    
    @ViewBuilder private func renderFoodTruckList() -> some View {
        List {
            ForEach(viewModel.foodTruckListModel){ foodTruck in
                HStack {
                    VStack(spacing: 10) {
                        Text(foodTruck.optionalText ?? "" )
                            .font(.headline)
                        Text(foodTruck.location ?? "")
                            .font(.subheadline)
                        Text(foodTruck.locationdesc ?? "" )
                            .font(.body)
                    }
                    Text("\(foodTruck.start24 ?? "" ) AM - \(foodTruck.end24 ?? "") PM")
                        .font(.body)
                        .frame(width: 75)
                    
                }
            }
        }
        .listStyle(.plain)
        .task {
            await viewModel.retrieveNearFoodTrucks()
        }
        
    }
    
    var body: some View {
        NavigationView {
            renderFoodTruckList()
                .navigationTitle("Food Truck")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Map") {
                            viewModel.isMoveToMapView = true
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .background(
                    NavigationLink(isActive: $viewModel.isMoveToMapView) {
                        MapView( isBackToList: $viewModel.isMoveToMapView)
                    } label: {
                        EmptyView()
                    }
                )
        }
        
    }
}

#Preview {
    MainView()
}
