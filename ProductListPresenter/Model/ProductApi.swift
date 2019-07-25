//
//  ProductApi.swift
//  ProductListPresenter
//
//  Created by Тимур on 14.07.19.
//  Copyright © 2019 Timur. All rights reserved.
//

import UIKit

class ProductApi: BaseApi {

    let relativeUrl = "common/product/list"

    func fetchProducts(categoryId: Int?, completionHandler: @escaping ([Product]) -> Void) {
        let params = (categoryId != nil) ? ["categoryId" : categoryId!] : [:]
        super.sendRequest(relativeUrl: relativeUrl, params: params) { (response: Any?) in
            self.parseProducts(response, completionHandler)
        }
    }

    private func parseProducts(_ response: Any?, _ completionHandler: ([Product]) -> Void) {
        //TODO: use ObjectMapper to parse data
        var products: [Product] = []
        //var products: [Product] = Mapper<Product>.mapArray(JSONObject: jsonRootObject["data"])

        if let jsonRootObject = response as? [String: Any] {
            if let jsonProductArray = jsonRootObject["data"] as? [[String: Any]] {
                for jsonProduct in jsonProductArray {
                    products.append(self.parseProductJson(jsonProduct))
                }
            }
        }
        
        completionHandler(products)
    }

    private func parseProductJson(_ jsonProduct: [String: Any]) -> Product {
        let productId: Int = jsonProduct["productId"] as! Int
        let productDescription: String? = jsonProduct["productDescription"] as? String
        let title: String = jsonProduct["title"] as! String
        let rating: Int? = jsonProduct["rating"] as? Int
        let imageUrl: String? = jsonProduct["imageUrl"] as? String
        let price: Int? = jsonProduct["price"] as? Int
        let availableForSale: Bool = jsonProduct["isAvailableForSale"] as! Bool
        
        return Product(
            id: productId,
            price: price,
            title: title,
            forSale: availableForSale,
            description: productDescription,
            imageUrl: imageUrl,
            rating: rating)
    }
}
