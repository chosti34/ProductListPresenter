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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Если был произведен переход на данный экран, self.product должен быть проинициализирован
        assert(self.product != nil)

        // Задаем название товара
        self.productNameLabel.text = self.product!.title

        // Задаем текст цены товара
        self.productPriceLabel.text = (self.product!.price == nil ? "не установлена" : String(self.product!.price!) + "$")

        // Задаем описание товара
        self.productDescriptionLabel.text = (self.product!.desc == nil) ? "Описание отсутствует" : self.product!.desc!

        // Описание в виде пустой строки не информативно
        if (self.productDescriptionLabel.text!.isEmpty) {
            self.productDescriptionLabel.text = "Описание отсутствует"
        }

        // Задаем изображение продукта
        let url: URL? = (self.product!.imageUrl == nil) ? nil : URL(string: self.product!.imageUrl!)
        self.productImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"), options: [], context: nil)
    }

    override func viewWillLayoutSubviews() {
        self.productDescriptionLabel.sizeToFit()
    }

    @IBAction func onAddToCartButtonPress(_ sender: RoundedButton) {
        assert(self.product != nil)
        App.instance.shoppingCart.addProduct(product: self.product!)

        let alertController = UIAlertController(title: "Товар '\(self.product!.title)' добавлен в корзину", message: nil, preferredStyle: .alert)

        let continueAction = UIAlertAction(title: "Продолжить", style: .default, handler: nil)
        alertController.addAction(continueAction)

        let gotoShoppingCartViewAction = UIAlertAction(title: "Посмотреть корзину", style: .default) { (action: UIAlertAction) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let shoppingCartViewController = storyboard.instantiateViewController(withIdentifier: "ShoppingCartViewController")
            let segue = UIStoryboardSegue(identifier: "ProductDetailsToShoppingCartSegue", source: self, destination: shoppingCartViewController, performHandler: {
                self.navigationController?.show(shoppingCartViewController, sender: self)
            })
            self.prepare(for: segue, sender: self)
            segue.perform()
        }
        alertController.addAction(gotoShoppingCartViewAction)

        self.present(alertController, animated: true, completion: nil)
    }
}
