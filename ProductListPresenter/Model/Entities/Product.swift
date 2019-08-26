//
//  Product.swift
//  ProductListPresenter
//
//  Created by Тимур on 05.07.19.
//  Copyright © 2019 Timur. All rights reserved.
//

import Foundation
import ObjectMapper

class Product: Mappable {

    var productId: Int = 0
    var productTitle: String = ""
    var productDescription: String? = nil
    var productPrice: Int? = 0
    var productImageUrl: String? = nil

    required init?(map: Map) {}

    func mapping(map: Map) {
        self.productId           <- map["productId"]
        self.productTitle        <- map["title"]
        self.productDescription  <- map["productDescription"]
        self.productPrice        <- map["price"]
        self.productImageUrl     <- map["imageUrl"]
    }
}
