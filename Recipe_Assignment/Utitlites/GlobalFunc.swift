
import Foundation
import SafariServices
func navigateUrl(url : String) {
    
    if #available(iOS 9.0, *)
    {
        let urlString = url
        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                topController.present(vc, animated: true, completion: nil)
            }
        }
    }
        
    else
    {
        UIApplication.shared.open(URL(string : url)!, options: [:], completionHandler: { (status) in
        })
    }
    
}
