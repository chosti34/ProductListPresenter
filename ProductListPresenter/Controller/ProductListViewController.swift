//
//  ProductCollectionViewController.swift
//  ProductListPresenter
//
//  Created by Тимур on 05.07.19.
//  Copyright © 2019 Timur. All rights reserved.
//

import UIKit
import MBProgressHUD

class ProductListViewController: UICollectionViewController {

    // Список продуктов категории
    var products: [Product] = []

    // Категория продукта (если nil, тогда все категории)
    var category: Category? = nil

    // Продукт, выбранный пользователем для просмотра подробной информации
    var selectedProduct: Product? = nil

    var dataProvider: ProductDataProvider = ProductDataProvider()

    var progressHUD: MBProgressHUD? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = category?.title ?? "Все продукты"
        self.progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)

        self.dataProvider.delegate = self
        self.dataProvider.fetchProducts(self.category?.id)

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

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedProduct = self.products[indexPath.row]
        self.performSegue(withIdentifier: "ProductListToProductDetailsSegue", sender: self)
    }

    @IBAction func onProductDetailsButtonPress(_ sender: RoundedButton) {
        self.selectedProduct = self.products[sender.tag]
        self.performSegue(withIdentifier: "ProductListToProductDetailsSegue", sender: self)
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let maxScrollingOffsetY = scrollView.contentSize.height - scrollView.frame.height

        if offsetY >= maxScrollingOffsetY {
            self.dataProvider.fetchProducts(self.category?.id, self.products.count)
        }
    }
}

extension ProductListViewController: ProductDataProviderDelegate {
    func dataProvider(_ dataProvider: ProductDataProvider, itemsLoaded items: [Product]) {

        print("products loaded")

        self.products.append(contentsOf: items)
        self.progressHUD?.hide(animated: true)
        self.collectionView?.reloadData()
    }
}
