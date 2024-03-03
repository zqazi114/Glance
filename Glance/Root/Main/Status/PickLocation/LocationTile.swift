//
//  LocationTile.swift
//  Glance
//
//  Created by Z Q on 2/23/24.
//

import SwiftUI

// MARK: - LocationTile
struct LocationTile: View {
    
    var location: Location
    
    // MARK: - V_header
    private var V_header: some View {
        
        HStack(alignment: .top) {
            
            Text(location.name)
                .font(.title3)
                .fontWeight(.semibold)
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            Text(location.type.description)
                .font(.body)
                .fontWeight(.light)
                .foregroundColor(.gray)
                .padding(.trailing)
        }
    }
    
    // MARK: - V_address
    private var V_address: some View {
        
        Text(location.address)
            .fontWeight(.light)
            .multilineTextAlignment(.leading)
            .lineLimit(2)
            .padding(.top, 5)
            .padding(.bottom, 15)
    }
    
    // MARK: - V_rating
    private var V_rating: some View {
        
        HStack(spacing: 0) {
            
            Text(String(format: "%.1f", location.rating))
                .padding(.trailing, 10)
            
            ForEach(0..<location.stars, id: \.self) { _ in
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
            
            ForEach(0..<(5 - location.stars), id: \.self) { _ in
                Image(systemName: "star")
                    .foregroundColor(.gray)
            }
            
            Text("(\(location.reviews))")
                .padding(.leading, 5)
        }
    }
    
    // MARK: - V_timing
    private var V_timing: some View {
        
        HStack {
            Text(location.operation)
                .foregroundColor(.green)
            
            Image(systemName: "circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 10, height: 10)
                .foregroundColor(.white)
            
            Text("Closes at \(location.close)")
                .fontWeight(.light)
        }
    }
    
    // MARK: - V_status
    private var V_status: some View {
        
        Text(location.status.rawValue)
            .frame(width: 120)
            .padding(.vertical, 5)
            .background {
                Capsule()
                    .foregroundColor(location.status.color)
            }
    }
    
    // MARK: - V_image
    private var V_image: some View {
        
        Image(location.image)
            .resizable()
            .scaledToFill()
            .frame(width: 100, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: .white, radius: 1)
            .padding(.trailing)
    }
    
    // MARK: - body
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            V_header
            
            V_address
            
            GeometryReader { geo in
                
                HStack(alignment: .top) {
                    
                    VStack(alignment: .leading, spacing: 10) {
                        
                        V_rating
                        
                        V_timing
                        
                        V_status
                    }
                    
                    Spacer()
                    
                    V_image
                }
            }
            .frame(height: 100)
        }
    }
}

#Preview {
    LocationTile(location: Location.TEST.first!)
        .padding()
}
