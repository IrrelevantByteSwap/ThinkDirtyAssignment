//
//  RootCoordinator.swift
//  ThinkDirtyTestApp
//
//  Created by Vivienne Fosh on 25.09.2022.
//

import Foundation
import Stinsen
import SwiftUI

final class RootCoordinator: NavigationCoordinatable {
    var stack = Stinsen.NavigationStack<RootCoordinator>(initial: \.root)
    
    @ObservedObject private var appState: AppState
    @ObservedObject private var listVM: ProductsVM
    
    @Root private var root = makeList
    @Route(.modal) var showDetails = makeDetails
    
    init(appState: AppState) {
        _appState = ObservedObject(wrappedValue: appState)
        _listVM = ObservedObject(wrappedValue: ProductsVM(service: ProductsService(), appState: appState))
    }
}

private extension RootCoordinator {
    @ViewBuilder func makeList() -> some View {
        ProductListView(listVM: self.listVM)
    }
    
    @ViewBuilder func makeDetails(_ product: Product) -> some View {
        EmptyView()
    }
}
