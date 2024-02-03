//
//  MapViewModel.swift
//  RedFinTestSwiftUI
//
//  Created by Jael on 02/02/2024.
//

import Foundation
import CoreLocation

final class MapViewModel: ObservableObject {
    
    @Published private(set) var foodTruckAnnotations: [Place] = []
    @Published var selectedFoodTruck: Place?
    
    @MainActor func retrieveNearFoodTrucks() async {
        guard let url = URL(string: "https://data.sfgov.org/resource/bbb8-hzi6.json") else {
            self.manageRetriveError(error: .invalidURL)
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let foodTrucks = try JSONDecoder().decode([FoodTruckModel].self, from: data)
            let filteredFoodTrucks = self.filterFoodTrucks(foodTrucks)
            foodTruckAnnotations.append(contentsOf:createPinPlaces(filteredFoodTrucks))
        } catch {
            self.manageRetriveError(error: .other(error))
        }
    }
    
    private func filterFoodTrucks(_ foodTrucks: [FoodTruckModel]) -> [FoodTruckModel] {
        let currentDate = Date().dayOfWeek()!
        let currentHour = Date.currentHour
        
        guard let pacificTimeZone = TimeZone(identifier: "America/Los_Angeles") else {
            print("Error to obtain Pacífico zone")
            return []
        }
        var calendar = Calendar.current
        calendar.timeZone = pacificTimeZone
        
        let dayFilter =  foodTrucks.filter { $0.dayOfWeekStr == currentDate}
        let amFilter = dayFilter.filter{ currentHour >= $0.start24?.toHour() ?? 0 }
        let fmFilter = amFilter.filter{ currentHour <= $0.end24?.toHour() ?? 0 }
        return fmFilter
    }
    
    private func createPinPlaces(_ foodTrucksInfo:[FoodTruckModel]) -> [Place] {
        var retrievePlaces = [Place]()
        foodTrucksInfo.forEach { foodTruck in
            let place = Place(name: foodTruck.optionalText ?? "", coordinate: CLLocationCoordinate2D(latitude: Double(foodTruck.latitude ?? "") ?? 0.0, longitude: Double(foodTruck.longitude ?? "") ?? 0.0), startHour: foodTruck.start24 ?? "" , endHour: foodTruck.end24 ?? "" , placeDescription: foodTruck.locationdesc, street: foodTruck.location ?? "")
             retrievePlaces.append(place)
         }
        return retrievePlaces
    }
    
    private func manageRetriveError(error: FoodTruckError) {
        switch error {
        case .invalidURL:
            print("Invalid URL")
        case .noData:
            print("No Data")
        case .decodingError(let decodingError):
            switch decodingError {
            case .typeMismatch(let type, let context):
                let errorDescription = "Type mismatch: Expected \(type) at \(context.codingPath)"
                print(errorDescription)
            default:
                let errorDescription = "An unexpected decoding error occurred: \(decodingError)"
                print(errorDescription)
            }
        case .other(let otherError):
            print(otherError.localizedDescription)
        }
    }
}

