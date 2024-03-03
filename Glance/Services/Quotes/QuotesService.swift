//
//  QuotesService.swift
//  Glance
//
//  Created by Z Q on 2/28/24.
//

import Foundation
import SwiftUI
import Combine
import ComposableArchitecture

// MARK: - QuotesServiceProtocol
protocol QuotesServiceProtocol {
    
    func fetch(category: QuotesService.Category?)
}

// MARK: - QuotesService
class QuotesService: QuotesServiceProtocol {
    
    enum Category: String, CaseIterable {
        
        case age, alone, communication, courage, dating, failure, friendship, happiness, jealousy, life, love
        
    }
    
    var publisher: AnyPublisher<[Quote], Never> = Empty().eraseToAnyPublisher()
    var cancellable: AnyCancellable? = nil
    
    // MARK: - fetch
    func fetch(category: Category? = nil) {
        
        guard let key = PropertyListService()?.plist.QUOTES else {
            
            app_print("Could not read Quotes API KEY from plist")
            
            return
        }
        
        let base = "https://api.api-ninjas.com/v1/quotes?"
        
        let category = "category=\(category?.rawValue ?? Category.allCases.randomElement()!.rawValue)"
        
        let urlStr = base + category
        
        guard let url = URL(string: urlStr) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(key, forHTTPHeaderField: "X-Api-Key")
        
        self.publisher = URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: [Quote].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
        
        self.cancellable = self.publisher.sink(receiveCompletion: { completion in
            
            switch completion {
                
            case .finished:
                break
                
            case .failure(let error):
                app_print(error.localizedDescription)
            }
            
            self.publisher = Empty().eraseToAnyPublisher()
            self.cancellable?.cancel()
            self.cancellable = nil
            
        }, receiveValue: { _ in })
    }
}

// MARK: - QuotesServiceKey
struct QuotesServiceKey: EnvironmentKey {
    static var defaultValue = QuotesService()
}

// MARK: - extension EnvironmentValues
extension EnvironmentValues {
    
    var quotesService: QuotesService {
        get { self[QuotesServiceKey.self] }
        set { self[QuotesServiceKey.self] = newValue }
    }
}

// MARK: - extension QuotesService
extension QuotesService: DependencyKey {
    
    static let liveValue: QuotesService = QuotesService()
    static let testValue: QuotesService = QuotesService()
}


// MARK: - extension DependencyValues
extension DependencyValues {
    
    var quotesService: QuotesService {
        get { self[QuotesService.self] }
        set { self[QuotesService.self] = newValue }
    }
}
