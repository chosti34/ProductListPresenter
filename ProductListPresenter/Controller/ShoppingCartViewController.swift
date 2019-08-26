//
//  ShoppingCartViewController.swift
//  ProductListPresenter
//
//  Created by Тимур on 19.08.19.
//  Copyright © 2019 Timur. All rights reserved.
//

import UIKit

class ShoppingCartViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var selectedProduct: Product? = nil

    var shoppingCart: ShoppingCart!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.shoppingCart = App.instance.shoppingCart
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
        return self.shoppingCart.productCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingCartProductCell", for: indexPath) as! ShoppingCartItemTableViewCell

        let product = self.shoppingCart.product(at: indexPath.row)
        cell.label.text = product.title + (product.price != nil ? " ($\(product.price!))" : "")

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
