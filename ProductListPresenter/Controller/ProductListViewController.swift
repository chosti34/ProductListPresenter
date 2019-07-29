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

    // Когда пользователь пролистал список до конца, программа сделает запрос
    // к серверу за новой порцией данных
    var fetchingProducts: Bool = false
    var fetchingEndReached: Bool = false

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = category?.title ?? "Все продукты"
        self.activityIndicator.startAnimating()

        App.instance.productApi.fetchProducts(categoryId: self.category?.id) { (parsedProducts: [Product]) in
            self.products = parsedProducts
            self.activityIndicator.stopAnimating()
            self.collectionView?.reloadData()
        }

        print("ProductCollectionViewController - viewDidLoad with category \(self.category?.id ?? -1) ended")
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.products.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        // Достаем ячейку с продуктом
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell

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

    @IBAction func onProductDetailsButtonPress(_ sender: RoundedButton) {
        self.selectedProduct = self.products[sender.tag]
        self.performSegue(withIdentifier: "ProductDetailsSegue", sender: self)
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if (self.products.count != 0) && (offsetY > contentHeight - scrollView.frame.height) && !self.fetchingProducts && !self.fetchingEndReached {
            self.fetchMoreProducts()
            print("offsetY = " + "\(offsetY)")
            print("contentHeight - frameHeight = " + "\(contentHeight - scrollView.frame.height)")
        }
    }

    private func fetchMoreProducts() {
        self.fetchingProducts = true

        App.instance.productApi.fetchProducts(categoryId: self.category?.id, offset: self.products.count) { (parsedProducts: [Product]) in
            self.fetchingEndReached = parsedProducts.isEmpty
            self.products.append(contentsOf: parsedProducts)
            self.collectionView?.reloadData()
            self.fetchingProducts = false
        }
    }
}
