//
//  Category.swift
//  ProductListPresenter
//
//  Created by Тимур on 06.07.19.
//  Copyright © 2019 Timur. All rights reserved.
//

import ObjectMapper

class Category: Mappable {

    var id: Int = 0
    var title: String = ""
    var imageUrl: String? = nil

    required init?(map: Map) {}

    func mapping(map: Map) {
        self.id       <- map["categoryId"]
        self.title    <- map["title"]
        self.imageUrl <- map["imageUrl"]
    }

}
