import UIKit

protocol CryptoListViewProtocol {
    func reloadContent()
}

class CryptoListViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    lazy var modelView = CryptoListViewModel(with: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {

        }
    }
}

// MARK: - Table View
extension CryptoListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelView.dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
        let object = modelView.dataSource[indexPath.row]
        cell.textLabel!.text = object.abbriviation
        
        let baseImageUrl = "https://www.cryptocompare.com"
        let wholeStringUrl = baseImageUrl + object.imageUrl!
        let imageURL = URL(string: wholeStringUrl)
        
        do {
            let urlData = try Data(contentsOf: imageURL!)
            cell.imageView?.image = UIImage(data: urlData)
        } catch {
            print(error)
        }
        
        return cell
    }

}

extension CryptoListViewController: CryptoListViewProtocol {
    func reloadContent() {
        tableView.reloadData()
    }
}

