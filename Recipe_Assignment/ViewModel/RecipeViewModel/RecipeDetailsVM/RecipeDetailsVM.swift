//
//  RecipeDetailsVM.swift
//  Recipe_Assignment
//
//  Created by Bassuni on 9/20/19.
//  Copyright © 2019 Mahmoud. All rights reserved.
//
import Foundation
class RecipeDetailsVM{
    public var delegate : RecipeDetailsDelegate!
    var recipeId: String!
    private var recipe: RecipeDetail!
    private var serviceAdapter : NetworkAdapter<RecipeEnum>!
    init(_recipeId : String , _serviceAdapter : NetworkAdapter<RecipeEnum>) {
        serviceAdapter = _serviceAdapter
        recipeId = _recipeId
        fetchRecipeDetailsData()
    }
    func fetchRecipeDetailsData(){
        serviceAdapter.request(target: .getRecipeDetail(recipeId: recipeId), success: { [unowned self] response in
            do{
                let decoder = JSONDecoder()
                // decode the json object
                let getData = try decoder.decode(RecipeDetailModel.self,from: response.data)
                DispatchQueueHelper.delay(bySeconds: 0) {
                    self.recipe = getData.recipe
                    DispatchQueueHelper.delay(bySeconds: 0, dispatchLevel: .main) {
                        // realod data to table view after data fetch
                        self.delegate?.dataBind()
                    }
                }
            }
            catch let err { print("Err", err)}
            }, error: {error  in self.delegate?.showAlert(messgae: error.localizedDescription)}
            , failure: {moyaError in self.delegate?.showAlert(messgae: moyaError.localizedDescription)})
    }
    func getRecipeDetails() -> RecipeDetail{
        return self.recipe
    }
    // when vm was dispose it must be to clear all dependency
    deinit {
        delegate = nil
    }
}
