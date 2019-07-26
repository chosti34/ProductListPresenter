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
        self.productDescriptionLabel.text = (self.product!.description == nil) ? "Описание отсутствует" : self.product!.description!

        // Описание в виде пустой строки не информативно
        if (self.productDescriptionLabel.text!.isEmpty) {
            self.productDescriptionLabel.text = "Описание отсутствует"
        }

        // Задаем изображение продукта
        let url: URL? = (self.product!.imageUrl == nil) ? nil : URL(string: self.product!.imageUrl!)
        self.productImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"), options: [], context: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        //self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }

    override func viewWillLayoutSubviews() {
        self.productDescriptionLabel.sizeToFit()
    }
}
