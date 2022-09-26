//
//  ViewModel.swift
//  ThinkDirtyTestApp
//
//  Created by Vivienne Fosh on 25.09.2022.
//

import Foundation
import Combine

@dynamicMemberLookup
protocol ViewModel: ObservableObject where ObjectWillChangePublisher.Output == Void {
    associatedtype State
    associatedtype Input

    var state: State { get }

    func trigger(_ input: Input)
    func update(state: State, with appState: AppState) -> State
}

extension ViewModel {

    subscript<Value>(dynamicMember keyPath: KeyPath<State, Value>) -> Value {
        state[keyPath: keyPath]
    }

    func state(appState: AppState) -> AnyPublisher<State, Never> {
        return Just(update(state: state, with: appState))
            .append(appState.objectWillChange
                        .compactMap { [weak self] in
                guard let self = self else { return nil }
                return self.update(state: self.state, with: appState)
            })
            .eraseToAnyPublisher()
    }

    func update(state: State, with appState: AppState) -> State {
        return state
    }
}
