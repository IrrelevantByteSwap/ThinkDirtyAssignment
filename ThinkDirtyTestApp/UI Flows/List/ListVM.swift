//
//  ListVM.swift
//  ThinkDirtyTestApp
//
//  Created by Vivienne Fosh on 25.09.2022.
//

import Foundation
import Combine

final class ProductsVM: ViewModel {
    
    @Published private(set) var state: State
    
    struct State {
       
    }
    
    enum Input {
        case onAppear
    }
    
    func trigger(_ input: Input) {
        switch input {
        case .onAppear: break
        }
    }
    
    init(appState: AppState) {
        self.appState = appState
        self.state = State()
    }
    
    //MARK: Private
    let appState: AppState
    var cancelBag = CancelBag()
}

extension ProductsVM {
    
}
