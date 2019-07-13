import UIKit

class Product {
    var id: Int = 0
    var price: Int? = 0
    var title: String = ""
    var forSale: Bool = false
    var description: String? = nil
    var imageUrl: String? = nil
    var rating: Int? = nil

    init(
        id: Int,
        price: Int?,
        title: String,
        forSale: Bool,
        description: String?,
        imageUrl: String?,
        rating: Int?
    ) {
        self.id = id
        self.price = price
        self.title = title
        self.forSale = forSale
        self.description = description
        self.imageUrl = imageUrl
        self.rating = rating
    }
}
