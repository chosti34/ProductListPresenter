import UIKit
import Alamofire

class ProductCollectionViewController: UICollectionViewController {
    
    var products: [Product] = []
    
    var categoryId: Int? = nil
    var categoryName: String? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.navigationItem.title = categoryName ?? "Все продукты"
        print("ProductCollectionViewController - viewDidLoad with category \(categoryId ?? -1)")

        let productApi: ProductApi = ProductApi()
        let productsParsedCallback = { (parsedProducts: [Product]) in
            self.products = parsedProducts
            self.collectionView?.reloadData()
        }

        if categoryId != nil {
            productApi.fetchProductsWithCategory(categoryId: categoryId!, completionHandler: productsParsedCallback)
        } else {
            productApi.fetchAllProducts(completionHandler: productsParsedCallback)
        }

        print("ProductCollectionViewController - viewDidLoad ended")
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath)
            as! ProductCollectionViewCell

        // Заполняем ячейку данными модели
        cell.titleLabel.text = products[indexPath.row].title
        if let price = products[indexPath.row].price {
            cell.priceLabel.text = String(price) + "$"
        } else {
            cell.priceLabel.text = "Цена не установлена"
        }

        // Оформление ячейки
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 10
        
        return cell
    }
}





