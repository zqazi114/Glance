//
//  TestView.swift
//  Glance
//
//  Created by Z Q on 2/24/24.
//

import SwiftUI
import Combine

// MARK: - TestPublisher
class TestPublisher {
    let subject = PassthroughSubject<Int, Never>()
}

// MARK: - TestView
struct TestView: View {
    
    @State private var value: Int = -1
    @State private var value2: Int = -2
    @State private var value3: Int = -3
    @State private var value4: Int = -4
    
    // publisher
    let subject: CurrentValueSubject<Int,Never> = CurrentValueSubject<Int,Never>(0)
    let subject2 = PassthroughSubject<Int, Never>()
    let subject3 = TestPublisher()
    
    // subscriber
    @State var cancellable: AnyCancellable?
    
    var body: some View {
        
        VStack {
            
            Text("\(subject.value)")
            Text("\(value)")
            Text("\(value2)")
            Text("\(value3)")
            Text("\(value4)")
            
            Button {
                subject.send(subject.value + 1)
                
            } label: {
                Text("Emit")
            }
            
            Button {
                subject2.send(value3 + 1)
                subject2.send(value3 + 1)
                subject2.send(value3 + 1)
                subject2.send(value3 + 1)
                
            } label: {
                Text("Emit3")
            }
            
            Button {
                subject3.subject.send(value4 + 1)
                
            } label: {
                Text("Emit4")
            }
            
            Button {
                
                if cancellable == nil {
                    
                    cancellable = subject.sink { newValue in
                        value2 = newValue
                    }
                    
                } else {
                    cancellable?.cancel()
                    cancellable = nil
                }
                
            } label: {
                Text(cancellable == nil ? "Subscribe" : "Unsubscribe")
            }
            
            
        }
        .onReceive(subject, perform: { newValue in
            value = newValue
        })
        .onReceive(subject2, perform: { newValue in
            value3 = value3 + 1
        })
        .onReceive(subject3.subject, perform: { newValue in
            value4 = newValue
        })
    }
}

#Preview {
    TestView()
}
