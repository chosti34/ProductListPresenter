//
//  ProductCollectionViewController.swift
//  ProductListPresenter
//
//  Created by Тимур on 05.07.19.
//  Copyright © 2019 Timur. All rights reserved.
//

import UIKit
import MBProgressHUD

// TODO: use UICollectionViewDelegateFlowLayout for cells layout
class ProductListViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!

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
        self.dataProvider.categoryId = category?.id
        self.dataProvider.loadProducts()

        print("ProductCollectionViewController - viewDidLoad with category \(self.category?.id ?? -1) ended")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController: ProductDetailsViewController = segue.destination as? ProductDetailsViewController {
            assert(self.selectedProduct != nil)
            destinationViewController.product = self.selectedProduct
            return
        }
        assert(false, "unexpected segue from product list view")
    }

    @IBAction func onProductDetailsButtonPress(_ sender: RoundedButton) {
        self.openProductDetailScreen(product: self.products[sender.tag])
    }

    func openProductDetailScreen(product: Product) {
        self.selectedProduct = product
        self.performSegue(withIdentifier: "ProductListToProductDetailsSegue", sender: self)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let maxScrollingOffsetY = scrollView.contentSize.height - scrollView.frame.height

        if offsetY >= maxScrollingOffsetY {
            self.dataProvider.loadProducts(offset: self.products.count)
        }
    }
}

extension ProductListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.products.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        // Достаем ячейку с продуктом
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCollectionViewCell

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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.openProductDetailScreen(product: self.products[indexPath.row])
    }
}

extension ProductListViewController: ProductDataProviderDelegate {
    func dataProvider(_ dataProvider: ProductDataProvider, itemsLoaded items: [Product]) {
        self.products = dataProvider.products
        self.progressHUD?.hide(animated: true)
        self.collectionView?.reloadData()
    }
}
