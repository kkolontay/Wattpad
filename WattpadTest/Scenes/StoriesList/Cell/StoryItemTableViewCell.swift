
import UIKit

class StoryItemTableViewCell: UITableViewCell {
  @IBOutlet weak var imageCoverView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  var story: StoriesListModel?


  override func prepareForReuse() {
    imageCoverView.image = UIImage(named: "noImages")
    titleLabel.text = ""
    nameLabel.text = ""
  }
  
  func setData(_ story: StoriesListModel) {
    self.story = story
    titleLabel.text = story.title
    nameLabel.text = story.user?.name
  }
  
  func setImage( image: UIImage? , url: String) {
    if image != nil && url == story?.cover {
      imageCoverView.image = image
    }
  }

}
