//
//  ProductApi.swift
//  ProductListPresenter
//
//  Created by Тимур on 14.07.19.
//  Copyright © 2019 Timur. All rights reserved.
//

import UIKit

class ProductApi: BaseApi {

    //TODO: merge fetchProductsWithCategory and fetchAllProducts with optional categoryId
    func fetchProductsWithCategory(categoryId: Int, completionHandler: @escaping ([Product]) -> Void) {
        //TODO: make params dictionary, not string
        self.sendGetRequest(relativeRequestPath: "/common/product/list", params: ["categoryId=\(categoryId)"], responseHandler: { response in
            self.fetchProducts(response, completionHandler)
        })
    }

    func fetchAllProducts(completionHandler: @escaping ([Product]) -> Void) {
        self.sendGetRequest(relativeRequestPath: "/common/product/list", params: [], responseHandler: { response in
            self.fetchProducts(response, completionHandler)
        })
    }

    //TODO: parseProducts
    private func fetchProducts(_ response: Any?, _ completionHandler: ([Product]) -> Void) {
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






