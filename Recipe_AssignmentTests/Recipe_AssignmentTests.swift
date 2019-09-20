
import XCTest
import Alamofire
@testable import Recipe_Assignment

class Recipe_AssignmentTests: XCTestCase {
    
    func testGetAllRecipeService()  {
     let urlString =  String(format:GetAllRecipeURL,"" , 1)
     let e = expectation(description: "Alamofire")
        Alamofire.request(urlString)
            .response { response in
                XCTAssertNil(response.error, "Whoops, error \(response.error!.localizedDescription)")
                XCTAssertNotNil(response, "No response")
                XCTAssertEqual(response.response?.statusCode ?? 0, 200, "Status code not 200")
                
                e.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)
        
    }
}
