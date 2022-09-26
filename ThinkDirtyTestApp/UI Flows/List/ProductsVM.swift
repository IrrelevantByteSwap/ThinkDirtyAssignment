//
//  ListVM.swift
//  ThinkDirtyTestApp
//
//  Created by Vivienne Fosh on 25.09.2022.
//

import Foundation
import Combine

final class ProductsVM: ViewModel {
    
    @Published private(set) var state: State // only changeable from this VM
    
    struct State {
        var products = [Product]()
        var showProgress = false
    }
    
    enum Input {
        case onAppear
        case fetch
        case fetchEmpty
        case fetchMalformed
    }
    
    func trigger(_ input: Input) { // factory method and generally the only way to make changes in the View Data
        switch input {
        case .onAppear: break
        case .fetch: fetchProducts()
        case .fetchEmpty: fetchEmpty()
        case .fetchMalformed: fetchMalformed()
        }
    }
    
    init(service: ProductsService, appState: AppState) { // web-service and app-state injected
        self.appState = appState
        self.service = service
        self.state = State()
    }
    
    func test(_ state: State) -> Self { // for testing through PreviewProvider
        self.state = state
        return self
    }
    
    //MARK: Private
    let service: ProductsService
    let appState: AppState
    var cancelBag = CancelBag()
}

private extension ProductsVM {
    func fetchProducts() {
        state.showProgress = true
        
        service.fetchProducts()
            .sink { [weak self] result in
                self?.state.showProgress = false
                if case .failure(let error) = result {
                    self?.appState.alertErorSubject.send(error)
                }
            } receiveValue: { [weak self] response in
                self?.state.products = response.products
            }.store(in: &cancelBag)
    }
    
    func fetchMalformed() {
        state.showProgress = true
        
        service.fetchMalformed()
            .sink { [weak self] result in
                self?.state.showProgress = false
                if case .failure(let error) = result {
                    self?.appState.alertErorSubject.send(error)
                }
            } receiveValue: { [weak self] response in
                self?.state.products = response.products
            }.store(in: &cancelBag)
    }
    
    func fetchEmpty() {
        state.showProgress = true
        
        service.fetchEmpty()
            .sink { [weak self] result in
                self?.state.showProgress = false
                if case .failure(let error) = result {
                    self?.appState.alertErorSubject.send(error)
                }
            } receiveValue: { [weak self] response in
                self?.state.products = response.products
            }.store(in: &cancelBag)
    }
}
