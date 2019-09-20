
import UIKit
import Alamofire
import AlamofireImage
class recipeTVC: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    @IBOutlet var recipeRanking: FloatRatingView!
    @IBOutlet var recipeTitle: UILabel!
    @IBOutlet var recipePublisher: UILabel!
    @IBOutlet var recipImage: UIImageView!
    func configrationCell (recipe : RecipeItemVM)
    {
        recipeTitle.text = recipe.title ;
        recipePublisher.text = recipe.publisher ;
        recipeRanking.rating = recipe.socialRank/20; // // because rating max is 5
        Alamofire.request(recipe.imageURL).responseImage { response in
            if let image = response.result.value {
                self.recipImage.image = image;
            }
        }
        
        
    }
    

}
