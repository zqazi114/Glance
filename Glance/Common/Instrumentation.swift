//
//  Instrumentation.swift
//  Glance
//
//  Created by Z Q on 2/17/24.
//

import Foundation

// MARK: - INSTRUMENT_measureExecutionTime
func INSTRUMENT_measureExecutionTime(runs: Int = 1, name: String, function: @escaping () async -> ()) async {
    
    app_print("Instrumenting time for function: \(name)")
    
    var total_ms: Double = 0
    
    for i in 1...runs {
        
        app_print("Run #\(i)")
        
        let start = DispatchTime.now()
        app_print("Start Time (ms) = \(Double(start.uptimeNanoseconds)/1_000_000.0)ms")
        
        await function()
        
        let end = DispatchTime.now()
        app_print("End Time (ms) = \(Double(end.uptimeNanoseconds)/1_000_000.0)ms")
        
        let delta_ms = Double((end.uptimeNanoseconds - start.uptimeNanoseconds))/1_000_000.0
        //app_print("Delta Time (ms) = \(delta_ms)ms")
        app_print("Delta Time (s) = \(delta_ms / 1_000.0)s")
        
        total_ms += delta_ms
        //app_print("Average Time (ms) = \(total_ms / Double(i))ms")
        app_print("Average Time (s) = \(total_ms / (Double(i) * 1_000.0))s")
    }
}
