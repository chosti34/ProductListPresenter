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

    var delegate: ProductDataProviderDelegate? = nil

    var fetching: Bool = false
    var noMoreToFetch: Bool = false

    func fetchProducts(_ categoryId: Int?, _ offset: Int = 0) {

        print("trying to fetch...")
        if self.fetching || self.noMoreToFetch {
            return
        }

        assert(delegate != nil)
        self.fetching = true

        App.instance.productApi.fetchProducts(categoryId: categoryId, offset: offset) { (parsedProducts: [Product]) in

            print("fetched \(parsedProducts.count) products")

            self.fetching = false
            self.noMoreToFetch = parsedProducts.isEmpty
            self.delegate?.dataProvider(self, itemsLoaded: parsedProducts)
        }
    }

    //TODO: declare delegate
    //TODO: move products to this class
    //TODO: move fetchingProducts, fetchingEndReached to this class
    //TODO: add method fetchMore
    //TODO: notify controller via delegate about new products
}
