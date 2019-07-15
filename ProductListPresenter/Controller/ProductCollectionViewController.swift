//
//  ProductCollectionViewController.swift
//  ProductListPresenter
//
//  Created by Тимур on 05.07.19.
//  Copyright © 2019 Timur. All rights reserved.
//

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
        self.navigationItem.backBarButtonItem?.title = self.navigationItem.title
        print("ProductCollectionViewController - viewDidLoad with category \(categoryId ?? -1)")

        let productApi = App.instance.productApi
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

        // Устанавливаем кнопке идентификатор товара (для перехода на карточку товара)
        cell.segueButton.productId = indexPath.row
        let product = products[indexPath.row]

        // Заполняем ячейку данными модели
        cell.titleLabel.text = product.title
        if let price = product.price {
            cell.priceLabel.text = String(price) + "$"
        } else {
            cell.priceLabel.text = "Цена не установлена"
        }

        // Оформление ячейки
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 10

        // Устанавливаем изображение товара
        let url: URL? = (product.imageUrl != nil) ? URL(string: product.imageUrl!) : nil
        cell.imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"), options: [], completed: nil)

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let destination: ProductDetailsViewController = segue.destination as! ProductDetailsViewController
        let segueButton: ProductCellButton = sender as! ProductCellButton
        destination.product = products[segueButton.productId!]

        let backItem = UIBarButtonItem()
        backItem.title = self.navigationItem.title
        self.navigationItem.backBarButtonItem = backItem
    }
}
