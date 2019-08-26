//
//  ShoppingCart.swift
//  ProductListPresenter
//
//  Created by Тимур on 19.08.19.
//  Copyright © 2019 Timur. All rights reserved.
//

import UIKit
import ObjectMapper

class ShoppingCart: NSObject {

    class Item: Mappable {
        var product: Product?
        var count: Int = 0

        init(product: Product, count: Int) {
            self.product = product
            self.count = count
        }

        required init?(map: Map) {}

        func mapping(map: Map) {
            self.product <- map["product"]
            self.count   <- map["count"]
        }
    }

    private let userDefaultsKey = "ShoppingCartItems"

    private var items: [Item] = []

    override init() {
        super.init()
        self.load()
    }

    func addProduct(product: Product) {
        let found = self.items.index { (item: Item) -> Bool in
            return item.product!.id == product.id
        }

        if let index = found {
            self.items[index].count += 1
        } else {
            self.items.append(Item(product: product, count: 1))
        }

        self.save()
    }

    func removeProduct(at index: Int) {
        self.items.remove(at: index)
        self.save()
    }

    func product(at index: Int) -> Product {
        return self.items[index].product!
    }

    func productsCount() -> Int {
        return self.items.count
    }

    func productCount(of product: Product) -> Int? {
        let found = self.items.index { (item: Item) -> Bool in
            return item.product!.id == product.id
        }

        if let index = found {
            return self.items[index].count
        }

        return nil
    }

    private func save() {
        let jsonString = self.items.toJSONString(prettyPrint: true)
        UserDefaults.standard.set(jsonString, forKey: self.userDefaultsKey)
    }

    private func load() {
        if let jsonString = UserDefaults.standard.string(forKey: self.userDefaultsKey) {
            if let mappedItems = Mapper<Item>().mapArray(JSONString: jsonString)  {
                self.items = mappedItems
            }
        }
    }
}
