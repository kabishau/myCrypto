import Foundation

class CryptoListViewModel {
    
    var dataSource: [Currency] = []
    
    init(with view: CryptoListViewProtocol) {
        RestAPI.coinsList { [weak self] (list) in
            defer {
                DispatchQueue.main.async {
                    view.reloadContent()
                }
            }
            
            guard let currencies = list else { return }
            self?.dataSource = currencies.sorted(by: { (l, r) -> Bool in
                return l.abbriviation.compare(r.abbriviation) == .orderedAscending
            })
        }
    }
}
