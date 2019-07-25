//
//  Product.swift
//  ProductListPresenter
//
//  Created by Тимур on 05.07.19.
//  Copyright © 2019 Timur. All rights reserved.
//

import ObjectMapper

class Product: Mappable {

    var id: Int = 0
    var title: String = ""
    var description: String? = nil
    var price: Int? = 0
    var imageUrl: String? = nil

    required init?(map: Map) {}

    func mapping(map: Map) {
        self.id          <- map["productId"]
        self.title       <- map["title"]
        self.description <- map["productDescription"]
        self.price       <- map["price"]
        self.imageUrl    <- map["imageUrl"]
    }

}
