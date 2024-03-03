//
//  GooglePlacesService_Wrapper.swift
//  Glance
//
//  Created by Z Q on 2/25/24.
//

import SwiftUI

// MARK: - GooglePlacesService_Wrapper
struct GooglePlacesService_Wrapper: View {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @State private var search: String = "Hot"
    @State private var places: [GooglePlacesHTTPResponse.PlaceResult] = []
    
    @State private var isBusy: Bool = false
    @State private var error: AppError? = nil
    
    
    // MARK: - body
    var body: some View {
        
        VStack(alignment: .leading) {
            
            TextField(text: $search, prompt: Text("Search")) {
                Text(search)
            }
            .textFieldStyle(.roundedBorder)
            .overlay {
                
                HStack {
                    Spacer()
                    
                    Button {
                        
                        GooglePlacesService.shared.fetchPlaces(type: "bar", keyword: search.isEmpty ? nil : search)
                        
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                    .padding(.trailing, 10)
                }
            }
            
            ForEach(places, id: \.self.place_id) { place in
                
                Text(place.name)
                    .foregroundStyle(.gray)
            }
            
            Spacer()
        }
        
        .padding()
        
        .progressView(isBusy)
        
        .errorAlert(error: error) {
            error = nil
        }
        
        .onAppear(perform: {
            //GooglePlacesService.shared.setupFetcher()
        })
        
        .onReceive(GooglePlacesService.shared.fetcherSubject, perform: { newValue in
            
            //placess = newValue
        })
        /*
        .onReceive(GooglePlacesService.shared.placesSubject.subscribe(on: DispatchQueue.main), perform: { places in
            
            self.places = places
        })*/
    }
}

#Preview {
    GooglePlacesService_Wrapper()
}

