//
//  ProductCollectionViewController.swift
//  ProductListPresenter
//
//  Created by Тимур on 05.07.19.
//  Copyright © 2019 Timur. All rights reserved.
//

import UIKit
import Alamofire

class ProductListViewController: UICollectionViewController {

    // Список продуктов категории
    var products: [Product] = []

    // Категория продукта (если nil, тогда все категории)
    var category: Category? = nil

    // Продукт, выбранный пользователем для просмотра подробной информации
    var selectedProduct: Product? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Задаем заголовок категории
        self.navigationItem.title = category?.title ?? "Все продукты"

        let productApi = App.instance.productApi
        let productsParsedCallback = { (parsedProducts: [Product]) in
            self.products = parsedProducts
            self.collectionView?.reloadData()
        }

        if self.category != nil {
            productApi.fetchProductsWithCategory(categoryId: self.category!.id, completionHandler: productsParsedCallback)
        } else {
            productApi.fetchAllProducts(completionHandler: productsParsedCallback)
        }

        print("ProductCollectionViewController - viewDidLoad with category \(self.category?.id ?? -1) ended")
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.products.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        // Достаем ячейку с продуктом
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath)
            as! ProductCell

        // Задаем кнопке в ячейке индекс продукта (сохраняем в тег)
        cell.segueButton.tag = indexPath.row
        let product = products[indexPath.row]

        // Задаем заголовок ячейки продукта
        cell.titleLabel.text = product.title

        // Задаем цену в ячейке продукта
        cell.priceLabel.text = (product.price != nil) ? (String(product.price!) + "$") : "Цена не установлена"

        // Устанавливаем изображение товара
        let url: URL? = (product.imageUrl != nil) ? URL(string: product.imageUrl!) : nil
        cell.imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"), options: [], completed: nil)

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController: ProductDetailsViewController = segue.destination as! ProductDetailsViewController
        assert(self.selectedProduct != nil)
        destinationViewController.product = self.selectedProduct
    }

    // TODO: add custom handler for segueButton touch, fill selectedProduct, call segue for product details
    @IBAction func onProductDetailsButtonPress(_ sender: RoundedButton) {
        self.selectedProduct = self.products[sender.tag]
        self.performSegue(withIdentifier: "ProductDetailsSegue", sender: self)
    }
}
