//
//  BaseViewController.swift
//  ProductListPresenter
//
//  Created by Тимур on 20.08.19.
//  Copyright © 2019 Timur. All rights reserved.
//

import UIKit

class BaseCollectionViewController: UIViewController {

    var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(BaseCollectionViewController.refreshCollectionViewData), for: UIControlEvents.valueChanged)
    }

    @objc func refreshCollectionViewData() {
        self.refreshCollectionViewDataImpl()
    }

    // Будет переопределен в подклассах
    func refreshCollectionViewDataImpl() {}

    func showLoadingErrorNotificationAlert(message: String) {
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let continueAction = UIAlertAction(title: "Продолжить", style: .default, handler: nil)
        alertController.addAction(continueAction)
        self.present(alertController, animated: true, completion: nil)
    }

    func showShoppingCartButton() {
        let barButtonItem = UIBarButtonItem()
        // TODO: customize, add handler
        self.navigationItem.rightBarButtonItem = barButtonItem
    }

    // TODO: add action to handle ShoppingCartButton

    // TODO: use Notification Center to handle keyboard
}
