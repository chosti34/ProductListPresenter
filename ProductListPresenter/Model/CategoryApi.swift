//
//  CategoryApi.swift
//  ProductListPresenter
//
//  Created by Тимур on 14.07.19.
//  Copyright © 2019 Timur. All rights reserved.
//

import UIKit

class CategoryApi: BaseApi {
    func parseCategoryJson(_ jsonCategory: [String: Any]) -> Category {
        let categoryId: Int = jsonCategory["categoryId"] as! Int
        let title: String = jsonCategory["title"] as! String
        let imageUrl: String? = jsonCategory["imageUrl"] as? String

        return Category(id: categoryId, title: title, imageUrl: imageUrl)
    }

    //TODO: add categoryId as optional param
    func fetchAllCategories(completionHandler: @escaping ([Category]) -> Void) {
        super.sendGetRequest(relativeRequestPath: "/common/category/list", params: [], responseHandler: { response in
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
        })
    }
}





