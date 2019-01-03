
import UIKit

class StoriesListView: UIViewController {
  @IBOutlet weak var searchField: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var activeIndicator: UIActivityIndicatorView!
  var viewModel: StoriesListViewModel?
  var workStroies: [StoriesListModel]? {
    didSet {
      tableView.reloadData()
    }
  }
  
  var stories:[StoriesListModel]? {
    didSet {
      workStroies = stories
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel = StoriesListViewModel()
    viewModel?.showAlertClosure = { [weak self] error in
      DispatchQueue.main.async {
        self?.showAlert(error: error)
        self?.activeIndicator.stopAnimating()
      }
    }
    viewModel?.updateLoadingStatus = {
      [weak self] stories in
      DispatchQueue.main.async {
        self?.stories = stories
        self?.activeIndicator.stopAnimating()
      }
    }
    viewModel?.fetchStories()
    activeIndicator.startAnimating()
    tableView.tableFooterView = UIView()
    searchField.delegate = self
  }
  
  func showAlert( error: String) {
    let alert = UIAlertController(title: nil, message: error, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
  
}

extension StoriesListView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if UIDevice.current.userInterfaceIdiom == .pad {
      return 234
    }
    return 134
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let cell = cell as? StoryItemTableViewCell else { return }
    cell.setData(workStroies?[indexPath.row] ?? StoriesListModel())
    guard  let url = workStroies?[indexPath.row].cover else {
      return
    }
    viewModel?.fetchImage(url: url, success: {[weak cell] (image, urlResource) in
      DispatchQueue.main.async {
        cell?.setImage(image: image, url: urlResource)
      }
    })
  }
}

extension StoriesListView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return workStroies?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "story", for: indexPath)
    return cell
  }
}

extension StoriesListView: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText.isEmpty {
      workStroies = stories
      return
    }
    workStroies = stories?.filter({ (item) -> Bool in
      return item.title?.lowercased().contains(searchText.lowercased()) ?? false
    })
  }
}


