//
//  RecipeVM.swift
//  Recipe_Assignment
//
//  Created by Bassuni on 9/19/19.
//  Copyright © 2019 Mahmoud. All rights reserved.
//
import Foundation
class RecipesVM{
    public var delegate : RecipeDelegate!
    var pageNumber : Int = 1
    var query : String = ""
    private var recipes: [Recipe]! = []
    private var suggestionsData = [String]()
    private var serviceAdapter : NetworkAdapter<RecipeEnum>!
    init(_serviceAdapter : NetworkAdapter<RecipeEnum>) {
        serviceAdapter = _serviceAdapter
        fetchRecipesData()
    }
    func fetchRecipesData(){
        // show loading in main ui thread
        DispatchQueueHelper.delay(bySeconds: 0, dispatchLevel: .main) {
            self.delegate?.showLoading()
        }
        serviceAdapter.request(target: .getAllRecipe(pageId: pageNumber, query: self.query), success: { [unowned self] response in
            do{
                let decoder = JSONDecoder()
                // decode the json object
                let getData = try decoder.decode(RecipeModel.self,from: response.data)
                DispatchQueueHelper.delay(bySeconds: 0) {
                    if(self.query != "")
                    {
                        self.recipes = [];
                    }
                    if(getData.recipes.count > 0){
                        for item in getData.recipes
                        {
                            self.recipes.append(item);
                        }
                    }
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
    func createAutoSuggest(searchText : String)
    {
        // save the data that user entered in user UserDefaults to save it
        let defaults = UserDefaults.standard
        if let tabledata : [String] = defaults.object(forKey: "SuggestionsData") as? [String]
        {
            self.suggestionsData = tabledata
        }

        if(self.suggestionsData.filter({$0 == searchText}).first == nil)
        {
            if (self.suggestionsData.count > 9)
            {
                self.suggestionsData.removeFirst()
            }
            self.suggestionsData.append(searchText)
            defaults.set(self.suggestionsData, forKey: "SuggestionsData")
        }
    }
    func getSuggestData() -> [String]{
        if let suggestionsData : [String] = UserDefaults.standard.object(forKey: "SuggestionsData") as? [String]{
            return suggestionsData
        }
        return []
    }
    // when vm was dispose it must be to clear all dependency
    deinit {
        delegate = nil
    }
}
// this extension will be useful when we using tableview
extension RecipesVM {
    var numberOfRecipesInSections: Int {
        return recipes.count
    }
    func recipeAtIndex(index: Int) -> RecipeItemVM {
        let recipe = recipes[index]
        return RecipeItemVM(recipe)
    }

}
struct RecipeItemVM {
    private let recipe: Recipe
    init(_ _recipe: Recipe) {
        recipe = _recipe
    }
}
extension RecipeItemVM {
    var publisher: String {return recipe.publisher}
    var f2FURL: String {return recipe.f2FURL}
    var title: String {return recipe.title}
    var sourceURL: String {return recipe.sourceURL}
    var recipeID: String {return recipe.recipeID}
    var imageURL: String {return recipe.imageURL}
    var socialRank: Double {return recipe.socialRank}
    var publisherURL: String {return recipe.publisherURL}
}
