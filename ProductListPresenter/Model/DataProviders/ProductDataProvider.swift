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
    func dataProvider(_ dataProvider: ProductDataProvider, errorOccurredWithLoadingMode mode: DataProviderLoadingMode)
}

enum DataProviderLoadingMode {
    case initial
    case appending
}

class ProductDataProvider: NSObject {

    var delegate: ProductDataProviderDelegate? = nil

    var products: [Product] = []
    var categoryId: Int? = nil

    var isLoadingPortion: Bool = false
    var loadedUpToLastProduct: Bool = false

    var productApi: ProductApi!

    override init() {
        super.init()
        self.productApi = App.instance.productApi
    }

    func loadProducts(offset: Int = 0, mode: DataProviderLoadingMode) {

        print("trying to load products")
        if self.isLoadingPortion || self.loadedUpToLastProduct {
            print("product load stopped")
            return
        }

        assert(delegate != nil)
        self.isLoadingPortion = true

        let successCallback = { (products: [Product]) in
            print("products loaded")
            self.products.append(contentsOf: products)
            self.isLoadingPortion = false
            self.loadedUpToLastProduct = products.isEmpty
            self.delegate?.dataProvider(self, itemsLoaded: products)
        }

        let errorCallback = {
            print("product loading error")
            self.isLoadingPortion = false
            self.delegate?.dataProvider(self, errorOccurredWithLoadingMode: mode)
        }

        self.productApi.fetchProducts(categoryId: self.categoryId, offset: offset, completionHandler: successCallback, errorHandler: errorCallback)
    }
}
