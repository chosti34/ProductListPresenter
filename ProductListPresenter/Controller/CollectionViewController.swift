import UIKit
import Alamofire

class ProductCollectionViewController: UICollectionViewController {

    let url = "http://ostest.whitetigersoft.ru/api/common/product/list?appKey=yx-1PU73oUj6gfk0hNyrNUwhWnmBRld7-SfKAU7Kg6Fpp43anR261KDiQ-MY4P2SRwH_cd4Py1OCY5jpPnY_Viyzja-s18njTLc0E7XcZFwwvi32zX-B91Sdwq1KeZ7m"
    var products: [Product] = []

    private func parseAndAppendProduct(productJson: [String: Any]) {
        let productId: Int = productJson["productId"] as! Int
        let productDescription: String? = productJson["productDescription"] as? String
        let title: String = productJson["title"] as! String
        let rating: Int? = productJson["rating"] as? Int
        let imageUrl: String? = productJson["imageUrl"] as? String
        let price: Int = productJson["price"] as! Int
        let availableForSale: Bool = productJson["isAvailableForSale"] as! Bool

        let product: Product = Product(
            id: productId,
            price: price,
            title: title,
            forSale: availableForSale,
            description: productDescription,
            imageUrl: imageUrl,
            rating: rating)
        
        products.append(product)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        Alamofire.request(self.url).validate().responseJSON { response in
            if !response.result.isSuccess {
                print("Error")
                return
            }

            if let json = response.result.value as? [String: Any] {
                // print(json["data"]!)
                if let productsJson = json["data"]! as? [[String: Any]] {
                    for productJson in productsJson {
                        self.parseAndAppendProduct(productJson: productJson)
                    }
                }
            }

            self.collectionView?.reloadData()
        }
        
        print("viewDidLoad ended")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath)
            as! ProductCollectionViewCell

        // Заполняем ячейку данными модели
        cell.titleLabel.text = products[indexPath.row].title
        cell.priceLabel.text = String(products[indexPath.row].price) + "$"

        // Оформление ячейки
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 10
        
        return cell
    }
}

