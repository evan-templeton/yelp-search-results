//
//  NearbyViewModel.swift
//  WeedmapsChallenge
//
//  Created by Evan Templeton on 11/29/24.
//  Copyright © 2024 Weedmaps, LLC. All rights reserved.
//

import SwiftUI
import CoreLocation
import class Combine.AnyCancellable

final class NearbyViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    private let searchService: SearchServiceProtocol
    
    @Published var searchInput = ""
    private var searchCancellable: AnyCancellable?
    
    @Published var businesses = [Business]()
    @Published var suggestions = [String]()
    @State private var coords: LatLong
    @Published var city: String = "Irvine"
    
    @Published var errorMessage: String?
    
    init(searchService: SearchServiceProtocol) {
        self.searchService = searchService
        if let currentLocation = locationManager.location {
            coords = LatLong(clLocation: currentLocation.coordinate)
        } else {
            coords = .irvine
        }
        super.init()
        locationManager.delegate = self
        setUpDebouncedSearchInput()
    }
    
    @MainActor
    func getAutocompleteSuggestions(input: String) async {
        do {
            suggestions = try await searchService.fetchAutocompleteSuggestions(input: input, coords: coords, city: city)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func getBusinesses(input: String) async {
        do {
            businesses = try await searchService.fetchBusinesses(term: input, coords: coords, city: city)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func requestLocation() {
        switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                errorMessage = "Your location is restricted."
            case .denied:
                errorMessage = "You have denied access to location services."
            case .authorizedAlways, .authorizedWhenInUse:
                updateCurrentLocation()
            @unknown default:
                break
        }
    }
    
    private func updateCurrentLocation(last: CLLocation? = nil) {
        let latest = last ?? locationManager.location
        if let latest {
            Task {
                let cityName = await getCityName(for: latest)
                await MainActor.run {
                    coords = LatLong(clLocation: latest.coordinate)
                    city = cityName ?? city
                }
            }
        }
    }
    
    private func getCityName(for location: CLLocation) async -> String? {
        return await withCheckedContinuation { continuation in
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                if let error {
                    self.errorMessage = "Error in reverse geocoding: \(error.localizedDescription)"
                    continuation.resume(returning: nil)
                    return
                }
                
                if let placemark = placemarks?.first, let city = placemark.locality {
                    continuation.resume(returning: city)
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
    }
    
    private func setUpDebouncedSearchInput() {
        searchCancellable = $searchInput
            .debounce(for: .seconds(0.75), scheduler: RunLoop.main)
            .sink { [weak self] newValue in
                if !newValue.isEmpty {
                    self?.businesses = []
                    Task {
                        await self?.getAutocompleteSuggestions(input: newValue)
                    }
                }
            }
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        updateCurrentLocation(last: locations.last)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        errorMessage = error.localizedDescription
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if [.authorizedAlways, .authorizedWhenInUse].contains(manager.authorizationStatus) {
            updateCurrentLocation()
        }
    }
}

private extension LatLong {
    static let irvine = LatLong(latitude: 33.669445, longitude: -117.823059)
    
    init(clLocation: CLLocationCoordinate2D) {
        self.latitude = clLocation.latitude
        self.longitude = clLocation.longitude
    }
}
