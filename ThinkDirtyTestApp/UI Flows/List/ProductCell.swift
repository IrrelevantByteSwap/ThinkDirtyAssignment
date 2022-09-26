//
//  ProductCell.swift
//  ThinkDirtyTestApp
//
//  Created by Vivienne Fosh on 25.09.2022.
//

import Foundation
import SwiftUI
import Kingfisher

struct ProductCell: View {
    let product: Product
    
    var body: some View {
        VStack(spacing: 0) {
            
            HStack(alignment: .center) {
                KFImage(product.imageURLSmall)
                    .fromMemoryCacheOrRefresh()
                    .resizable()
                    .frame(width: 100, height: 100)
                    .cornerRadius(20)
                    .shadow(radius: 5)
                
                // pretty sure even localized "by" string will cause problems, but for the sake of beauty I left it like this
                VStack(alignment: .leading, spacing: 4) {
                    
                    Text(product.productName)
                        .font(.resagokr(.bold, fixedSize: 18))
                        .foregroundColor(.primary)
                        .padding(.trailing, 8)
                    
                    Group {
                        Text("\(product.productCategory) ") +
                        Text("by \(product.brandName)")
                            
                    }.font(.resagokr(.regular, fixedSize: 15))
                        .foregroundColor(.primary)
                        .padding(.trailing, 8)
                    
                    Text(product.description ?? "")
                        .font(.resagokr(.light, fixedSize: 15))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                    
                    Group {
                        HStack {
                            
                            switch product.hazardRatingCategory {
                            case .clean:
                                Text("Clean")
                                    .foregroundColor(color)
                            case .halfAndHalf:
                                Text("Half&Half")
                                    .foregroundColor(color)
                            case .dirty:
                                Text("Dirty")
                                    .foregroundColor(color)
                            }
                            
                            Spacer()
                            
                            if product.hazardRating > 0 {
                                Text("\(product.hazardRating)")
                                    .foregroundColor(color)
                                    .font(.resagokr(.regular, fixedSize: 16))
                                    .shadow(radius: 3)
                                Image("radiation")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                    .shadow(radius: 1)
                            }
                        }
                    }.font(.resagokr(.regular, fixedSize: 18))
                        .padding(.trailing, 8)
                        
                }
                .padding(.leading, 4)
                .padding(.vertical, 6)
            }
            .padding(.leading, 10)
            .padding(.bottom, 8)
        }.frame(maxWidth: .infinity, maxHeight: 160)
    }
    
    var color: Color {
        switch product.hazardRatingCategory {
        case .clean: return .green
        case .halfAndHalf: return .orange
        case .dirty: return .pink
        }
    }
}

struct ProductCell_Previews: PreviewProvider {
    static var previews: some View {
        ProductCell(product: TestData.product2)
    }
}
