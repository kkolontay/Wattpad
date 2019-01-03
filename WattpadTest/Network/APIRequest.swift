import Foundation


enum StringURLRequest: String {
  
  case apiRequest = "https://www.wattpad.com/api/v3/stories?offset=0&limit=30&fields=stories(id,title,cover,user)"
  
  static func getRequest() -> String {
    return String(StringURLRequest.apiRequest.rawValue)
  }
  
  
}

class APIRequest: AsyncOperation {
  
  var handler: ((Data?, String?) -> Void)?
  var url: String?
  
  init(_ url: String, handler: @escaping (Data?, String?) -> Void) {
    super.init()
    self.handler = handler
    self.url = url
  }
  
  override func main() {
    
    if let url = url, let request = createURLRequest(url) {
      URLSession.shared.dataTask(with: request) {
        [weak self] data, response, error in
        if self?.isCancelled  ?? false {
          self?.state = .Finished
          return
        }
        if error != nil {
          self?.handler?(nil, error?.localizedDescription)
          self?.state = .Finished
          return
        }
        if let responseCode = (response as? HTTPURLResponse)?.statusCode {
          if  200 ... 299 ~= responseCode, let data = data {
            self?.handler?(data, nil)
            self?.state = .Finished
          } else {
            self?.handler?(nil, "Connection error")
            self?.state = .Finished
          }
        }
        }.resume()
    } else {
      self.state = .Finished
    }
  }
  
  
  func createURLRequest(_ url: String, httpMethod: String = "GET") -> URLRequest? {
    guard let url = URL(string: url) else { return nil }
    var request = URLRequest(url: url)
    request.httpMethod = httpMethod
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    return request
  }
  
}

