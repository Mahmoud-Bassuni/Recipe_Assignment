
import UIKit

class recipeViewController: UIViewController,UIScrollViewDelegate {

     var recipesVM : RecipesVM!

    // IBOutlet
    @IBOutlet var autoSuggestionsTbl: UITableView!
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet var recipeSearchProp: UISearchBar!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    //-----------------------------
    var suggestionsData = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        iBOutletSetup();
        recipesVM = RecipesVM(_serviceAdapter: NetworkAdapter())
        recipesVM.delegate = self
    }

    func iBOutletSetup()
    {
        tableView?.dataSource = self
        tableView?.delegate = self
        autoSuggestionsTbl.dataSource = self
        autoSuggestionsTbl?.delegate = self
        recipeSearchProp.delegate = self
        activityIndicator?.hidesWhenStopped = true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // chack if scrolling arrive at the end of table
        if (((self.tableView?.contentOffset.y)! + (self.tableView?.frame.size.height)!) >= (self.tableView?.contentSize.height)!)
        {
            self.recipesVM.pageNumber = self.recipesVM.pageNumber + 1
            self.recipesVM.fetchRecipesData()
        }
    }
}
extension recipeViewController: RecipeDelegate {
    func showLoading() {
          activityIndicator?.startAnimating()
    }
    func hideLoading() {
         activityIndicator?.stopAnimating()
    }

    func showAlert(messgae: String) {
        self.alert(title: "validation", message: messgae)
    }
    func dataBind() {
         self.tableView?.reloadData()
    }
}
 // there where two table tableView and autoSuggestionsTbl
extension recipeViewController: UITableViewDataSource ,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == self.tableView ?  self.recipesVM.numberOfRecipesInSections : suggestionsData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == self.tableView)
        {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as? recipeTVC
            {
                cell.configrationCell(recipe: self.recipesVM.recipeAtIndex(index: indexPath.row))
                return cell;
            }
            else {
                return recipeTVC()
            }
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AutoSuggestionCell", for: indexPath)
            
            cell.textLabel?.text = suggestionsData[indexPath.row]
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == self.tableView)
        {
            let _recipeId : String =  self.recipesVM.recipeAtIndex(index: indexPath.row).recipeID //self.recipeToDisplay[indexPath.row].recipeID;
            guard  _recipeId != ""  else {  return  }
            let recipeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RecipeDetaiScreen") as! RecipeDetailVC
            recipeVC.recipeId = _recipeId;
            self.present(recipeVC, animated: true, completion: nil)
        }
        else
        {
            recipeSearchProp.text = self.suggestionsData[indexPath.row]
            self.autoSuggestionsTbl.isHidden = true
        }
        
    }
}
extension recipeViewController: UISearchBarDelegate
{
    //  display Suggestion Data when tapped on searchBar
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        displaySuggestionData(searchBar.text!);
    }
    //  display Suggestion Data when edit data on searchBar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        displaySuggestionData(searchBar.text!);
    }
    
    func displaySuggestionData(_ searchText :String)
    {
        guard searchText == "" else { self.autoSuggestionsTbl.isHidden = true; return}
        // if Suggestions data is empty not dispaly sugesst table
        let defaults = UserDefaults.standard
        if let tabledata : [String] = defaults.object(forKey: "SuggestionsData") as? [String]
        {
            self.suggestionsData = tabledata
            self.autoSuggestionsTbl.reloadData()
            self.autoSuggestionsTbl.isHidden = false;
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        self.recipesVM.query = recipeSearchProp.text ?? ""
        self.recipesVM.pageNumber = 1
        self.recipesVM.fetchRecipesData()
        self.autoSuggestionsTbl.isHidden = true;
        //recipePresenter.getRecipes(1,recipeSearchProp.text ?? "")
        view.endEditing(true)
        // save the data that user entered in user UserDefaults to save it
        let defaults = UserDefaults.standard
        if let tabledata : [String] = defaults.object(forKey: "SuggestionsData") as? [String]
        {
            self.suggestionsData = tabledata
        }
        
        if(self.suggestionsData.filter({$0 == searchBar.text}).first == nil)
        {
            if (self.suggestionsData.count > 9)
            {
                self.suggestionsData.removeFirst()
            }
            self.suggestionsData.append(searchBar.text!)
            defaults.set(self.suggestionsData, forKey: "SuggestionsData")
        }
        
    }
}



