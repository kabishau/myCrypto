import Foundation

struct Currency {
    let abbriviation: String
    let imageUrl: String?
    
    
}

extension Currency {
    init?(key: String, data: Any) {
        
        guard let value = data as? [String: Any] else {
            return nil
        }
        
        self.abbriviation = key
        self.imageUrl = value["imageUrl"] as? String
    }
}
