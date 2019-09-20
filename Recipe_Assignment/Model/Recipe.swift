//
//  Recipe.swift
//  Recipe_Assignment
//
//  Created by Bassuni on 9/19/19.
//  Copyright © 2019 Mahmoud. All rights reserved.
//

import Foundation

struct RecipeModel: Codable {
    let count: Int
    let recipes: [Recipe]
}

struct Recipe: Codable {
    let publisher, f2FURL, title, sourceURL: String
    let recipeID, imageURL: String
    let socialRank: Double
    let publisherURL: String
    
    enum CodingKeys: String, CodingKey {
        case publisher
        case f2FURL = "f2f_url"
        case title
        case sourceURL = "source_url"
        case recipeID = "recipe_id"
        case imageURL = "image_url"
        case socialRank = "social_rank"
        case publisherURL = "publisher_url"
    }
}


