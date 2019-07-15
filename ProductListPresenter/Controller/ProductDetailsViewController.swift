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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        assert(product != nil)

        productNameLabel.text = product!.title
        productPriceLabel.text = (product!.price == nil ? "не установлена" : String(product!.price!) + "$")
        productDescriptionLabel.text = (product!.description == nil) ? "Описание отсутствует" : product!.description!
        if (productDescriptionLabel.text!.isEmpty) {
            productDescriptionLabel.text = "Описание отсутствует"
        }

        let url: URL? = (product!.imageUrl == nil) ? nil : URL(string: product!.imageUrl!)
        productImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"), options: [], context: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillLayoutSubviews() {
        productDescriptionLabel.sizeToFit()
    }

}
