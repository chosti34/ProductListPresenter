//
//  BaseViewController.swift
//  ProductListPresenter
//
//  Created by Тимур on 20.08.19.
//  Copyright © 2019 Timur. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func showShoppingCartButton() {
        let barButtonItem = UIBarButtonItem()
        //TODO: customize, add handler
        self.navigationItem.rightBarButtonItem = barButtonItem
    }

    //TODO: add action to handle ShoppingCartButton

    //TODO: use Notification Center to handle keyboard
}
