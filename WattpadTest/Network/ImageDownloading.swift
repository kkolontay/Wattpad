  import Foundation
  import UIKit

  class ImageDownloading: AsyncOperation {
    
    var request: URLRequest?
    var handlerUrl: ((UIImage?, String?, String?) -> Void)?
    
    init(_ url: String, handlerUrl: @escaping (UIImage?, String?, String?) -> (Void)) {
      super.init()
      self.handlerUrl = handlerUrl
      guard let urlCheck = URL(string: url) else {
        handlerUrl(nil, "URL isn't correct", url)
        return
      }
      request = URLRequest(url: urlCheck)
     // request?.addValue("application/json", forHTTPHeaderField: "Content-Type")
      //request?.httpMethod = "GET"
    }
    
    override func main() {
      guard let request = self.request else {
          self.state = .Finished
        return
      }
      if let image = CachingImages.shared.imageCache?.object(forKey: request.url?.absoluteString as AnyObject) as? UIImage {
        if self.isCancelled {
            self.state = .Finished
          return
        }
        self.handlerUrl?(image, nil, request.url?.absoluteString )
          self.state = .Finished
        return
      } else {
        URLSession.shared.dataTask(with: request) {
          [weak self] data, response, error in
          if self?.isCancelled  ?? false {
            self?.state = .Finished
            return
          }
          if error != nil {
            self?.handlerUrl?(nil, error?.localizedDescription, request.url?.absoluteString)
              self?.state = .Finished
            return
          }
          if let response = (response as? HTTPURLResponse)?.statusCode {
            if  200 ... 299 ~= response, let data = data {
              if  let image = UIImage(data: data) {
                CachingImages.shared.imageCache?.setObject(image, forKey: request.url?.absoluteString as AnyObject)
                if self?.isCancelled  ?? false {
                    self?.state = .Finished
                  return
                }
                self?.handlerUrl?(image, nil, request.url?.absoluteString )
                  self?.state = .Finished
              }
            }
          } else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            self?.handlerUrl?(nil, "Status code \(statusCode ?? 0)", request.url?.absoluteString)
              self?.state = .Finished
          }
          }.resume()
      }
    }
  }
