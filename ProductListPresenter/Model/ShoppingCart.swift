//
//  ShoppingCart.swift
//  ProductListPresenter
//
//  Created by Тимур on 19.08.19.
//  Copyright © 2019 Timur. All rights reserved.
//

import UIKit

class ShoppingCart: NSObject {

    private var products: [Product] = []

    override init() {
        super.init()
        self.load()
    }

    func addProduct(product: Product) {
        self.products.append(product)
        self.save()
    }

    func removeProduct(at index: Int) {
        self.products.remove(at: index)
        self.save()
    }

    func getProduct(at index: Int) -> Product {
        return self.products[index]
    }

    func getProductCount() -> Int {
        return self.products.count
    }

    private func save() {
        let encoded: Data = NSKeyedArchiver.archivedData(withRootObject: self.products)
        UserDefaults.standard.set(encoded, forKey: "Products")
    }

    private func load() {
        guard let data = UserDefaults.standard.object(forKey: "Products") as? NSData else {
            print("'Products' key not found in UserDefaults")
            return
        }

        guard let decodedProducts = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? [Product] else {
            print("can't unarchive todo items data")
            return
        }

        self.products = decodedProducts
    }
}
