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
        
        func getDocumentDirectory() -> URL? {
            let fileManager = FileManager.default
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
            let filePath = documentsURL?.appendingPathComponent("\(object.abbriviation).png")
            return filePath
        }
        
        func saveImageDocumentDirectory() {
            let baseImageUrl = "https://www.cryptocompare.com"
            let fullUrl = baseImageUrl + object.imageUrl!
            let imageURL = URL(string: fullUrl)
            let data = try? Data(contentsOf: imageURL!)
            
            do {
                if let filePath = getDocumentDirectory() {
                    try data?.write(to: filePath, options: .atomic)
                }
            } catch {
                print(error)
            }
        }
        
        func getImage() {
            guard let filePath = getDocumentDirectory() else { return }
            let fileName = filePath.path
            cell.imageView?.image = UIImage(contentsOfFile: fileName)
        }
        
        
        if let filePath = getDocumentDirectory() {
            if FileManager.default.fileExists(atPath: filePath.path) {
                getImage()
            } else {
                saveImageDocumentDirectory()
                getImage()
            }
        }
        
        return cell
    }

}

extension CryptoListViewController: CryptoListViewProtocol {
    func reloadContent() {
        tableView.reloadData()
    }
}

