
import UIKit
import Alamofire
import AlamofireImage

class RecipeDetailVC: UIViewController {

    var recipesDetailsVM : RecipeDetailsVM!
    var recipeId = ""
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var recipeImage: UIImageView!
    @IBOutlet var recipeIngredients: UITextView!
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        recipesDetailsVM = RecipeDetailsVM(_recipeId: recipeId, _serviceAdapter: NetworkAdapter())
        recipesDetailsVM.delegate = self
    }
    @IBAction func goTopublisherLink(_ sender: Any) {
         navigateUrl(url: self.recipesDetailsVM.getRecipeDetails().publisherURL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension RecipeDetailVC: RecipeDetailsDelegate {
    func showAlert(messgae: String) {
        self.alert(title: "validation", message: messgae)
    }
    func dataBind() {
        self.titleLbl.text = self.recipesDetailsVM.getRecipeDetails().title
        var ingredients :String = ""
        for obj in self.recipesDetailsVM.getRecipeDetails().ingredients
        {
            ingredients += "\n" + obj
        }
        self.recipeIngredients.text = ingredients;
        Alamofire.request(self.recipesDetailsVM.getRecipeDetails().imageURL).responseImage { response in
            debugPrint(response)
            if let image = response.result.value {
                self.recipeImage.image = image;
            }
        }
    }
}

