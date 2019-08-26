//
//  ShoppingCartViewController.swift
//  ProductListPresenter
//
//  Created by Тимур on 19.08.19.
//  Copyright © 2019 Timur. All rights reserved.
//

import UIKit
import SDWebImage

class ShoppingCartViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var selectedProduct: Product? = nil

    var shoppingCart: ShoppingCart!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.shoppingCart = App.instance.shoppingCart
    }

    // Поскольку мы можем добавить товар и вернуться обратно на экран корзины,
    // необходимо обновить данные таблицы при показе экрана
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let productDetailsViewController = segue.destination as? ProductDetailsViewController {
            assert(selectedProduct != nil)
            productDetailsViewController.product = self.selectedProduct
        }
    }
}

extension ShoppingCartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shoppingCart.productsCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingCartProductCell", for: indexPath) as! ShoppingCartItemTableViewCell

        let product = self.shoppingCart.product(at: indexPath.row)
        cell.itemTitleLabel.text = product.title
        cell.itemPriceLabel.text = "Цена" + (product.price != nil ? ": " + String(product.price!) + "$" : " не установлена")
        cell.itemCountLabel.text = String(self.shoppingCart.productCount(of: product)!) + " шт."

        let url: URL? = (product.imageUrl != nil) ? URL(string: product.imageUrl!) : nil
        cell.itemImageView.sd_setImage(
            with: url,
            placeholderImage: UIImage(named: "placeholder"),
            options: SDWebImageOptions.continueInBackground)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.selectedProduct = self.shoppingCart.product(at: indexPath.row)

        // Переход на страницу с подробным описанием продукта
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let productDetailsViewController = storyboard.instantiateViewController(withIdentifier: "ProductDetailsViewController")
        let segue = UIStoryboardSegue(identifier: "ShoppingCartToProductDetailsSegue", source: self, destination: productDetailsViewController, performHandler: {
            self.navigationController?.pushViewController(productDetailsViewController, animated: true)
        })
        self.prepare(for: segue, sender: self)
        segue.perform()
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.shoppingCart.removeProduct(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
