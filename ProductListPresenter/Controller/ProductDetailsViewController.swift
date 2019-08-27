//
//  ProductDetailsViewController.swift
//  ProductListPresenter
//
//  Created by Тимур on 14.07.19.
//  Copyright © 2019 Timur. All rights reserved.
//

import UIKit
import SDWebImage

class ProductDetailsViewController: UIViewController {

    var product: Product? = nil

    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!

    // MARK: - UIViewController overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        // Если был произведен переход на данный экран, self.product должен быть проинициализирован
        assert(self.product != nil)

        // Заголовок экрана - название товара
        self.navigationItem.title = product!.productTitle

        // Задаем название товара
        self.productNameLabel.text = self.product!.productTitle

        // Задаем текст цены товара
        self.productPriceLabel.text = (self.product!.productPrice == nil ? "не установлена" : String(self.product!.productPrice!) + "$")

        // Задаем описание товара
        self.productDescriptionLabel.text = (self.product!.productDescription == nil) ? "Описание отсутствует" : self.product!.productDescription!

        // Описание в виде пустой строки не информативно
        if (self.productDescriptionLabel.text!.isEmpty) {
            self.productDescriptionLabel.text = "Описание отсутствует"
        }

        // Задаем изображение продукта
        let url: URL? = (self.product!.productImageUrl == nil) ? nil : URL(string: self.product!.productImageUrl!)
        self.productImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"), options: [], context: nil)
    }

    // MARK: - Segue helpers

    private func performSegueOrGoBackToShoppingCart() {
        let indexOfCurrentViewController = self.navigationController?.viewControllers.index(of: self)
        let previousViewController = self.navigationController?.viewControllers[indexOfCurrentViewController! - 1]
        if previousViewController as? ShoppingCartViewController != nil {
            self.navigationController?.popViewController(animated: true)
            return
        }

        self.performSegue(withIdentifier: "ProductDetailsToShoppingCartSegue", sender: self)
    }

    // MARK: - Button press handlers

    @IBAction func onAddToShoppingCartButtonPress(_ sender: BorderedButton) {
        assert(self.product != nil)
        App.instance.shoppingCart.addProduct(product: self.product!)

        let alertController = UIAlertController(title: "Товар '\(self.product!.productTitle)' добавлен в корзину", message: nil, preferredStyle: .alert)

        let continueAction = UIAlertAction(title: "Продолжить", style: .default, handler: nil)
        alertController.addAction(continueAction)
        alertController.preferredAction = continueAction

        let gotoShoppingCartViewAction = UIAlertAction(title: "Посмотреть корзину", style: .default) { (action: UIAlertAction) in
            self.performSegueOrGoBackToShoppingCart()
        }
        alertController.addAction(gotoShoppingCartViewAction)

        self.present(alertController, animated: true, completion: nil)
    }

    @IBAction func onShoppingCartBarButtonPress(_ sender: Any) {
        self.performSegueOrGoBackToShoppingCart()
    }
}
