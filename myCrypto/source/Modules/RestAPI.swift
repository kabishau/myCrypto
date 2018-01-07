import Foundation

class RestAPI {
    
    class func coinsList(complition: @escaping (([Currency]?) -> Void)) {
        guard let url = URL(string: "https://min-api.cryptocompare.com/data/all/coinlist") else {
            complition(nil)
            print("url is invalid")
            return
        }
        
        let request = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let unwrappedData = data, error == nil else {
                complition(nil)
                print(error?.localizedDescription ?? "")
                return
            }
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: unwrappedData, options: .allowFragments) as? [String: Any],
                    let content = json["Data"] as? [String: Any] else {
                        complition(nil)
                        return
                }
                let currencies = content.flatMap(Currency.init)
                complition(currencies)
            } catch {
                complition(nil)
                print(error.localizedDescription)
            }
        }
        request.resume()
    }
}
