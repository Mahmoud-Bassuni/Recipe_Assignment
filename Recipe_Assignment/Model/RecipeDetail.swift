

import Foundation
struct RecipeDetailModel: Codable {
    let recipe: RecipeDetail
}

struct RecipeDetail: Codable {
    let publisher, f2FURL: String
    let ingredients: [String]
    let sourceURL, recipeID, imageURL: String
    let socialRank: Double
    let publisherURL, title: String
    
    enum CodingKeys: String, CodingKey {
        case publisher
        case f2FURL = "f2f_url"
        case ingredients
        case sourceURL = "source_url"
        case recipeID = "recipe_id"
        case imageURL = "image_url"
        case socialRank = "social_rank"
        case publisherURL = "publisher_url"
        case title
    }
}
