//
//  Category.swift
//  ProductListPresenter
//
//  Created by Тимур on 06.07.19.
//  Copyright © 2019 Timur. All rights reserved.
//

import ObjectMapper

class Category: NSObject, Mappable {

    var id: Int = 0
    var title: String = ""
    var imageUrl: String? = nil
    var hasSubcategories: Bool = false

    override init() {
        super.init()
    }

    required init?(map: Map) {
        super.init()
    }

    func mapping(map: Map) {
        self.id               <- map["categoryId"]
        self.title            <- map["title"]
        self.imageUrl         <- map["imageUrl"]
        self.hasSubcategories <- map["hasSubcategories"]
    }

}
