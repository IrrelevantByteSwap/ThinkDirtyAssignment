//
//  ContentView.swift
//  ThinkDirtyTestApp
//
//  Created by Vivienne Fosh on 25.09.2022.
//

import SwiftUI

struct ProductListView: View {
    
    @StateObject var listVM: ProductsVM
    
    init(listVM: ProductsVM) {
        _listVM = StateObject(wrappedValue: listVM)
        
        if listVM.state.products.isEmpty {
            listVM.trigger(.fetch)
        }
    }
    
    var body: some View {
        ZStack {
            listView
            overlayView
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    listVM.trigger(.fetchMalformed)
                }, label: {
                    Text("Malformed")
                        .font(.resagokr(.bold, size: 16))
                        .fixedSize(horizontal: true, vertical: false)
                })
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    listVM.trigger(.fetchEmpty)
                }, label: {
                    Text("Empty")
                        .font(.resagokr(.bold, size: 16))
                        .fixedSize(horizontal: true, vertical: false)
                })
            }
            ToolbarItem(placement: .bottomBar) {
                Button(action: {
                    listVM.trigger(.fetch)
                }, label: {
                    Text("Fetch Products")
                        .font(.resagokr(.bold, size: 18))
                        .fixedSize(horizontal: true, vertical: false)
                })
            }
            ToolbarItem(placement: .principal) {
                Text("Products")
                    .font(.resagokr(.bold, fixedSize: 24))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension ProductListView {
    
    var overlayView: some View {
        VStack {
            HStack {
                Spacer()
                if listVM.state.showProgress {
                    ProgressView()
                        .progressViewStyle(.circular)
                } else if listVM.state.products.isEmpty {
                    Text("Product list is Empty")
                }
                Spacer()
            }
        }
    }
    
    var listView: some View {
        List {
            ForEach(listVM.products) {
                ProductCell(product: $0)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
        }.refreshable { // does not work in Catalyst apps, but ok for assignment
            listVM.trigger(.fetch)
        }.listStyle(.insetGrouped)
        
    }
}

struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductListView(listVM: ProductsVM(service: ProductsService(), appState: AppState()).test(ProductsVM.State(products: [TestData.product1, TestData.product2], showProgress: false)))
    }
}
