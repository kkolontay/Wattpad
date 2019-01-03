
import Foundation

struct StoriesListModel: Codable {
  var id: String?
  var title: String?
  var user: User?
  var cover: String?
}

struct User: Codable {
  var name: String?
  var avatar: String?
  var fullname: String?
}

struct ListRoot: Codable {
  var  stories: [StoriesListModel]?
}
