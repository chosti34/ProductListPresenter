//
//  ProductApi.swift
//  ProductListPresenter
//
//  Created by Тимур on 14.07.19.
//  Copyright © 2019 Timur. All rights reserved.
//

import ObjectMapper

class ProductApi: BaseApi {

    let relativeUrl = "common/product/list"

    func fetchProducts(categoryId: Int?, completionHandler: @escaping ([Product]) -> Void) {
        let params = (categoryId != nil) ? ["categoryId" : categoryId!] : [:]
        super.sendRequest(relativeUrl: relativeUrl, params: params) { (response: Any?) in
            self.parseProducts(response, completionHandler)
        }
    }

    private func parseProducts(_ response: Any?, _ completionHandler: ([Product]) -> Void) {
        if let jsonRoot = response as? [String: Any] {
            let products: [Product]? = Mapper<Product>().mapArray(JSONObject: jsonRoot["data"])
            completionHandler(products!)
        }
    }
}
