//
//  CancelBag.swift
//  ThinkDirtyTestApp
//
//  Created by Vivienne Fosh on 25.09.2022.
//

import Combine

typealias CancelBag = Set<AnyCancellable>

extension CancelBag {

    mutating func collect(@Builder _ cancellables: () -> [AnyCancellable]) {
        formUnion(cancellables())
    }

    @resultBuilder
    struct Builder {
        static func buildBlock(_ cancellables: AnyCancellable...) -> [AnyCancellable] {
            cancellables
        }
    }
}
