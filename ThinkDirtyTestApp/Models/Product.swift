//
//  ListItem.swift
//  ThinkDirtyTestApp
//
//  Created by Vivienne Fosh on 25.09.2022.
//

import Foundation

struct Products: Codable {
    var products = [Product]()
}

struct Product: Codable, Identifiable {
    
    var id: String { uuid }
    
    enum RatingCategory: String, Codable {
        case clean = "CLEAN" //green
        case halfAndHalf = "HALF_AND_HALF" //yellow
        case dirty = "DIRTY" // red
    }
    
    enum CodingKeys: String, CodingKey {
        case uuid = "uuid"
        case productName = "product_name"
        case brandName = "brand_name"
        case description
        case imageURLSmall = "image_url_small"
        case imageURLLarge = "image_url_large"
        case productCategory = "product_category"
        case hazardRating = "hazard_rating"
        case hazardRatingCategory = "hazard_rating_category"
    }
    
    
    let uuid: String
    let productName: String
    let brandName: String
    let description: String?
    let imageURLSmall: URL?
    let imageURLLarge: URL?
    let productCategory: String
    let hazardRating: Int // 0...10
    let hazardRatingCategory: RatingCategory
}
