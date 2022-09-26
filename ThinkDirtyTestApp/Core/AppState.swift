//
//  AppState.swift
//  ThinkDirtyTestApp
//
//  Created by Vivienne Fosh on 25.09.2022.
//
 
#if os(iOS)
import UIKit
#else
import AppKit
#endif
import Combine

class AppState: ObservableObject {
    /// Centralized Error Handling
    var alertMessageSubject = PassthroughSubject<String, Never>()
    var alertErorSubject = PassthroughSubject<Error, Never>()

    /// Hides keyboard
    var resignFirstResponderSubject = PassthroughSubject<Void, Never>()

    /// Others

    
}

extension AppState {
    /// Update with a closure to avoid extra refreshes
    func performUpdate(_ update: () -> Void) {
        update()
        objectWillChange.send()
    }

    func reset() {
        
    }
    
}
