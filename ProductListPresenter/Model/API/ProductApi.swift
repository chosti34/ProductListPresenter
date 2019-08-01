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

    private func buildParams(_ categoryId: Int?, _ offset: Int) -> Dictionary<String, Any> {
        var params = (categoryId != nil) ? ["categoryId" : categoryId!] : [:]
        params["offset"] = offset
        return params
    }

    func fetchProducts(categoryId: Int?, offset: Int = 0, completionHandler: @escaping ([Product]) -> Void) {
        super.sendRequest(relativeUrl: relativeUrl, params: buildParams(categoryId, offset)) { (response: Any?) in
            self.parseProducts(response, completionHandler)
        }
    }

    private func parseProducts(_ response: Any?, _ completionHandler: ([Product]) -> Void) {
        if let jsonData = response as? [[String: Any]] {
            let products: [Product]? = Mapper<Product>().mapArray(JSONObject: jsonData)
            completionHandler(products!)
        }
    }
}
