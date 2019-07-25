//
//  CategoryApi.swift
//  ProductListPresenter
//
//  Created by Тимур on 14.07.19.
//  Copyright © 2019 Timur. All rights reserved.
//

import UIKit

class CategoryApi: BaseApi {

    let relativeUrl = "common/category/list"

    func fetchCategories(parentId: Int?, completionHandler: @escaping ([Category]) -> Void) {
        let params = (parentId != nil) ? ["parentId" : parentId!] : [:]
        super.sendRequest(relativeUrl: relativeUrl, params: params) { (response: Any?) in
            self.parseCategories(response, completionHandler)
        }
    }

    func parseCategories(_ response: Any?, _ completionHandler: @escaping ([Category]) -> Void) {
        var categories: [Category] = []

        if let jsonRootObject = response as? [String: Any] {
            if let jsonDataObject = jsonRootObject["data"] as? [String: Any] {
                if let jsonCategoriesArray = jsonDataObject["categories"] as? [[String: Any]] {
                    for categoryJson in jsonCategoriesArray {
                        categories.append(self.parseCategoryJson(categoryJson))
                    }
                }
            }
        }

        completionHandler(categories)
    }

    func parseCategoryJson(_ jsonCategory: [String: Any]) -> Category {

        let categoryId: Int = jsonCategory["categoryId"] as! Int
        let title: String = jsonCategory["title"] as! String
        let imageUrl: String? = jsonCategory["imageUrl"] as? String

        return Category(id: categoryId, title: title, imageUrl: imageUrl)
    }
}
