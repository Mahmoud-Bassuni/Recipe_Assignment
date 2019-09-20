//
//  RecipeEnum.swift
//  Recipe_Assignment
//
//  Created by Bassuni on 9/19/19.
//  Copyright © 2019 Mahmoud. All rights reserved.
//
import Foundation
import Moya
enum RecipeEnum{
    case getAllRecipe(pageId : Int,query : String)
     case getRecipeDetail(recipeId: String)
}
extension RecipeEnum: TargetType{
    var baseURL: URL {
            return URL(string: EndPoint.baseUrl.rawValue)!
    }
    var path: String {
        switch self{
        case .getAllRecipe: return EndPoint.GetAllRecipeURL.rawValue
        case .getRecipeDetail: return EndPoint.GetRecipeDetailURL.rawValue
        }
    }
    var method: Moya.Method {
        return .get
    }
    var sampleData: Data {
        return Data()
    }
    var task: Task {
        switch self {
        case let .getAllRecipe(page,query):
            return .requestParameters(parameters:  ["page": page , "q" :query , "key":EndPoint.token.rawValue], encoding: URLEncoding.queryString)
        case let .getRecipeDetail(recipeId):
            return .requestParameters(parameters:  ["rId": recipeId , "key": EndPoint.token.rawValue], encoding: URLEncoding.queryString)
        }
    }
    var headers: [String : String]?{
        return ["Content-Type" : "application/json"]
    }
}
