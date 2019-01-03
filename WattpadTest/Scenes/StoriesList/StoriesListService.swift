
import UIKit

protocol StoriesListServiceProtocol {
  func fetchStories(success: @escaping ([StoriesListModel]) -> Void, errorMessage: @escaping (String) -> Void)
  func fetchImage(url: String, success: @escaping(UIImage?, String) -> Void)
}

class StoriesListService: StoriesListServiceProtocol {
  let operation = OperationQueue()
  
  func fetchStories(success: @escaping ([StoriesListModel]) -> Void, errorMessage: @escaping (String) -> Void) {
    let url = StringURLRequest.getRequest()
    let connection = APIRequest(url) {
      data, error in
      if error != nil {
        errorMessage(error ?? "error")
        return
      }
      if data != nil {
        do {
          let decoder = JSONDecoder()
          let stories = try decoder.decode(ListRoot.self, from: data!)
          success(stories.stories ?? [])
          
        } catch let error as NSError {
          errorMessage(error.localizedDescription)
        }
      }
    }
    operation.addOperation(connection)
  }
  
  func fetchImage(url: String, success: @escaping(UIImage?, String) -> Void) {
    let connection = ImageDownloading(url) {
      image, error, urlResource in
      if error != nil {
        success(nil, urlResource ?? "")
      } else {
        success(image, urlResource ?? "")
      }
    }
    operation.addOperation(connection)
  }
}
