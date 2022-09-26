//
//  TestData.swift
//  ThinkDirtyTestApp
//
//  Created by Vivienne Fosh on 25.09.2022.
//

import Foundation

struct TestData {
    static let product1 = Product(uuid: "d9434cf1-6185-40c9-8857-b260be7bf6de",
                                  productName: "Cocoa Butter Matte Lipstick - Pink Canyon",
                                  brandName: "100% Pure",
                                  description: "Envelop your lips with the opaque, nurturing formula of 100% Pure's Cocoa Butter Semi-Matte Lipstick. Fruit pigments combine with a nourishing blend of cocoa butter, shea butter, and vitamin E to create a rich, vibrant formula that's long-wearing and never drying.",
                                  imageURLSmall: URL(string: "https://td-ios-coding-challenge.s3.amazonaws.com/product_images/d9434cf1-6185-40c9-8857-b260be7bf6de/small.png")!,
                                  imageURLLarge: URL(string: "https://td-ios-coding-challenge.s3.amazonaws.com/product_images/d9434cf1-6185-40c9-8857-b260be7bf6de/large.png")!,
                                  productCategory: "Lipstick",
                                  hazardRating: 0,
                                  hazardRatingCategory: .clean)
    
    static let product2 = Product(uuid: "aafb2033-a31d-44db-94eb-485dd112ca2e",
                                  productName: "Bye Bye Pores",
                                  brandName: "It Cosmetics",
                                  description: "Instantly erase the appearance of imperfections with Bye Bye Pores™, your airbrushed perfection in a jar! Loads of antioxidants, peptides and skin-loving ingredients give you a shine-free, airbrushed finish. Plus, the universal translucent shade goes on completely clear and works on all skin tones!",
                                  imageURLSmall: URL(string: "https://td-ios-coding-challenge.s3.amazonaws.com/product_images/aafb2033-a31d-44db-94eb-485dd112ca2e/small.png")!,
                                  imageURLLarge: URL(string: "https://td-ios-coding-challenge.s3.amazonaws.com/product_images/aafb2033-a31d-44db-94eb-485dd112ca2e/large.png")!,
                                  productCategory: "Toner",
                                  hazardRating: 5,
                                  hazardRatingCategory: .halfAndHalf)
}
