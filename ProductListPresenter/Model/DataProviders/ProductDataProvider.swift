//
//  ProductDataProvider.swift
//  ProductListPresenter
//
//  Created by Тимур on 30.07.19.
//  Copyright © 2019 Timur. All rights reserved.
//

import UIKit
import Alamofire

protocol ProductDataProviderDelegate {
    func dataProvider(_ dataProvider: ProductDataProvider, itemsLoaded items: [Product])
}

class ProductDataProvider: NSObject {
    // TODO: use UserDefaults

    var delegate: ProductDataProviderDelegate? = nil

    var products: [Product] = []
    var categoryId: Int? = nil

    var isLoadingPortion: Bool = false
    var loadedUpToLastProduct: Bool = false

    func loadProducts(offset: Int = 0) {

        print("trying to load...")
        if self.isLoadingPortion || self.loadedUpToLastProduct {
            return
        }

        assert(delegate != nil)
        self.isLoadingPortion = true

        App.instance.productApi.fetchProducts(categoryId: self.categoryId, offset: offset) { (products: [Product]) in
            print("loaded \(products.count) products")
            self.products.append(contentsOf: products)
            self.isLoadingPortion = false
            self.loadedUpToLastProduct = products.isEmpty
            self.delegate?.dataProvider(self, itemsLoaded: products)
        }
    }
}
