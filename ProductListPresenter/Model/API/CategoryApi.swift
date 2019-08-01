//
//  CategoryApi.swift
//  ProductListPresenter
//
//  Created by Тимур on 14.07.19.
//  Copyright © 2019 Timur. All rights reserved.
//

import ObjectMapper

class CategoryApi: BaseApi {

    let relativeUrl = "common/category/list"

    func fetchCategories(parentId: Int?, completionHandler: @escaping ([Category]) -> Void) {
        let params = (parentId != nil) ? ["parentId" : parentId!] : [:]
        super.sendRequest(relativeUrl: relativeUrl, params: params) { (response: Any?) in
            self.parseCategories(response, completionHandler)
        }
    }

    func parseCategories(_ response: Any?, _ completionHandler: @escaping ([Category]) -> Void) {
        if let jsonData = response as? [String: Any] {
            // Можно поштучно: Mapper<Category>().map(JSON: categoryJson)
            let categories: [Category]? = Mapper<Category>().mapArray(JSONObject: jsonData["categories"]!)
            completionHandler(categories!)
        }
    }
}
