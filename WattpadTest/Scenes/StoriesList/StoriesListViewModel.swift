
import UIKit

class StoriesListViewModel {
  
  private let service: StoriesListServiceProtocol
  var model: [StoriesListModel]? {
    didSet {
      self.updateLoadingStatus?(model ?? [])
    }
  }
  var alertMessage: String? {
    didSet {
      self.showAlertClosure?(alertMessage ?? "")
    }
  }
  
  var showAlertClosure: ((String) -> ())?
  var updateLoadingStatus: (([StoriesListModel]) -> ())?
  
  init(withStoriesList serviceProtocol: StoriesListServiceProtocol = StoriesListService() ) {
    self.service = serviceProtocol
  }
  
  func fetchStories() {
    service.fetchStories(success: { [weak self] (stories) in
      if stories.count > 0 {
        self?.model = stories
      } else {
        self?.alertMessage = "Nothing found"
      }
    }) {[weak self] (error) in
      self?.alertMessage = error
    }
  }
  
  func fetchImage(url: String, success: @escaping (UIImage?, String) -> Void) {
    service.fetchImage(url: url) {
      image, urlResource in
      success(image, urlResource)
    }
  }
  
}

extension StoriesListViewModel {
  
}
