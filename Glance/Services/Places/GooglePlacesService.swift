//
//  GooglePlacesService.swift
//  Glance
//
//  Created by Z Q on 2/23/24.
//

import Foundation
import GooglePlaces
import CoreLocation
import Combine


// MARK: - GooglePlacesServiceProtocol
protocol GooglePlacesServiceProtocol {
    
    static var shared: GooglePlacesService { get }
    
    func configure()
    
    func fetchPlaces(type: String, keyword: String?, radius: Int)
    func fetchPlaces(name: String?, types: [String])
    
    //func setupFetcher()
    //func getNearbyPlaces(type: GooglePlacesService.RequestType) async -> Result<[GMSPlace], AppError>
    //func getPlacesWithName(search: String?)
}

// MARK: - GooglePlacesService
class GooglePlacesService: NSObject, GooglePlacesServiceProtocol {
    
    enum RequestType {
        case api, url
    }
    
    static let shared: GooglePlacesService = {
        return GooglePlacesService()
    }()
    
    private var locationManager: CLLocationManager!
    private var placesClient: GMSPlacesClient!
    private var fetcher: GMSAutocompleteFetcher!
    private var fetcherPublisher: GMSAutocompleteFetcherPublisher!
    
    var fetcherSubject: AnyPublisher<[GMSAutocompletePrediction], Never> {
        return fetcherPublisher.autocompletePublisher()
    }
    
    var placesSubject = PassthroughSubject<[GooglePlacesHTTPResponse.PlaceResult], Never>()
    
    private var cancellables = [AnyCancellable]()
    
    
    // MARK: - configure
    func configure() {
        
        guard let key = PropertyListService()?.plist.GOOGLE else {
            
            app_print("Could not read Google Maps API KEY from plist")
            
            return
        }
        
        GMSPlacesClient.provideAPIKey(key)
        
        fetcherPublisher = GMSAutocompleteFetcherPublisher()
        
        placesClient = GMSPlacesClient.shared()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    /*
    // MARK: - getNearbyPlaces
    private func getNearbyPlacesWithAPI() async -> Result<[GMSPlace], AppError> {
        
        await withCheckedContinuation { continuation in
            
            DispatchQueue.main.async {
                
                let fields: GMSPlaceField = [.name, .placeID]
                
                self.placesClient.findPlaceLikelihoodsFromCurrentLocation(withPlaceFields: fields) { placesLikelihood, error in
                    
                    if let error = error {
                        
                        continuation.resume(returning: .failure(.places_couldNotGet(error: error.localizedDescription)))
                        
                    } else if let likelihoods = placesLikelihood, !likelihoods.isEmpty {
                        
                        let places = likelihoods.map { $0.place }
                        
                        continuation.resume(returning: .success(places))
                        
                    } else {
                        
                        continuation.resume(returning: .failure(.places_couldNotGet(error: "Likelihood array is empty of nil")))
                    }
                }
            }
        }
    }
    */
    
    // MARK: - fetchPlaces
    func fetchPlaces(type: String, keyword: String? = nil, radius: Int = 1000) {
        
        guard let api_key = PropertyListService()?.plist.GOOGLE else {
            
            app_print("Could not read Google Maps API KEY from plist")
            
            return
        }
        
        guard locationManager.authorizationStatus == .authorizedWhenInUse ||
              locationManager.authorizationStatus == .authorizedAlways,
              let coordinate = locationManager.location?.coordinate else {
            
            return
        }
        
        let base = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
        
        let location = "location=\(coordinate.latitude)%2C\(coordinate.longitude)"
        let radius = "&radius=\(radius)"
        let type = "&type=\(type.lowercased())"
        let keyword = keyword == nil ? "" : "&keyword=\(keyword!)"
        let key = "&key=\(api_key)"
        
        let urlStr = base + location + radius + type + keyword + key
        
        guard let url = URL(string: urlStr) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                app_print(error.localizedDescription)
                
            } else if let response = response as? HTTPURLResponse, 
                response.statusCode == 200,
                let data = data,
                let decoded = try? JSONDecoder().decode(GooglePlacesHTTPResponse.self, from: data) {
        
                DispatchQueue.main.async {
                    self.placesSubject.send(decoded.results)
                    //self.placesSubject.send(completion: .finished)
                }
                
            }
        }
        
        task.resume()
    }
    
    
    // MARK: - setupFetcher
    private func setupFetcher() {
        
        fetcherPublisher = GMSAutocompleteFetcherPublisher()
        
        let token = GMSAutocompleteSessionToken()
        
        fetcher = GMSAutocompleteFetcher()
        fetcher.provide(token)
        fetcher.delegate = fetcherPublisher
    }
    
    // MARK: - fetchPlaces
    func fetchPlaces(name: String? = nil, types: [String]) {
        
        if fetcher == nil {
            setupFetcher()
        }
        
        let filter = GMSAutocompleteFilter()
        filter.types = types
        
        fetcher.autocompleteFilter = filter
        fetcher.sourceTextHasChanged(name)
    }
}

// MARK: - GMSAutocompleteFetcherCombineDelegate
protocol GMSAutocompleteFetcherCombineDelegate: GMSAutocompleteFetcherDelegate {
    
    func autocompletePublisher() -> AnyPublisher<[GMSAutocompletePrediction], Never>
}

// MARK: - GMSAutocompleteFetcherPublisher
class GMSAutocompleteFetcherPublisher: NSObject, GMSAutocompleteFetcherCombineDelegate {
    
    private let autocompleteSubject = PassthroughSubject<[GMSAutocompletePrediction], Never>()
    
    func autocompletePublisher() -> AnyPublisher<[GMSAutocompletePrediction], Never> {
        return autocompleteSubject.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        
        autocompleteSubject.send(predictions)
    }
    
    func didFailAutocompleteWithError(_ error: Error) {
        
    }
}

extension GooglePlacesService: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        app_print("Location authorization changed: \(manager.authorizationStatus.customDumpDescription)")
    }
}


import ComposableArchitecture

// MARK: - extension FirebaseService
extension GooglePlacesService: DependencyKey {
    
    static let liveValue: GooglePlacesService = GooglePlacesService.shared
    static let testValue: GooglePlacesService = GooglePlacesService.shared
}


// MARK: - extension DependencyValues
extension DependencyValues {
    
    var googlePlaces: GooglePlacesService {
        get { self[GooglePlacesService.self] }
        set { self[GooglePlacesService.self] = newValue }
    }
}
