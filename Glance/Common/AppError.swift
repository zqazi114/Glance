//
//  AppError.swift
//  Glance
//
//  Created by Z Q on 2/16/24.
//

import SwiftUI

// MARK: - func app_print
func app_print(_ message: String) {
    print("<:-) \(message)")
}

// MARK: - AppError
enum AppError: Error, Equatable {
    
    case unimplemented
    
    case auth_notLoggedIn(error: String? = nil)
    case auth_couldNotRegister(error: String? = nil)
    case auth_couldNotLogin(error: String? = nil)
    
    case user_couldNotLoad(error: String? = nil)
    case user_couldNotSave(error: String? = nil)
    
    case places_couldNotGet(error: String? = nil)
}

// MARK: - extension AppError
extension AppError: CustomStringConvertible, LocalizedError {
    
    var errorDescription: String? {
        return description
    }
    
    var description: String {
        
        switch self {
            
        case .auth_notLoggedIn(let error),
             .auth_couldNotRegister(let error),
             .auth_couldNotLogin(let error),
             .user_couldNotLoad(let error),
             .user_couldNotSave(let error),
             .places_couldNotGet(let error):
            
            return error ?? "Unknown error occurred"

        case .unimplemented:
            return "Function is not implemented"
        }
    }
}

// MARK: - ErrorViewModifier
struct ErrorViewModifier: ViewModifier {
    
    var error: AppError?
    var action: (() -> ())?
    
    func body(content: Content) -> some View {
        
        content
            .alert("An error occurred", isPresented: .constant(error != nil)) {
                
                Button(role: .cancel) {
                    action?()
                    
                } label: {
                    Text("OK")
                }
                
            } message: {
                Text(error?.description ?? "Error is nil")
            }
    }
}

extension View {
    
    func errorAlert(error: AppError?, action: (() -> ())? = nil) -> some View {
        modifier(ErrorViewModifier(error: error, action: action))
    }
}

// MARK: - ErrorAlert_Wrapper
struct ErrorAlert_Wrapper: View {
    
    @State private var error: AppError? = nil
    
    var body: some View {
        
        VStack {
            
            Button {
                error = AppError.user_couldNotLoad(error: "User is not logged in")
                
            } label: {
                Text("Show error")
            }
        }
        .errorAlert(error: error) {
            error = nil
        }
    }
}

#Preview {
    ErrorAlert_Wrapper()
}
