//
//  Product.swift
//  ProductListPresenter
//
//  Created by Тимур on 05.07.19.
//  Copyright © 2019 Timur. All rights reserved.
//

import ObjectMapper
import Foundation

class Product: NSObject, NSCoding, Mappable {

    //TODO: productId
    var id: Int = 0
    var title: String = ""

    //TODO: desc - productDescription
    var desc: String? = nil
    var price: Int? = 0
    var imageUrl: String? = nil

    override init() {
        super.init()
    }

    required init?(map: Map) {
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeInteger(forKey: "id") as Int
        self.title = aDecoder.decodeObject(forKey: "title") as! String
        self.desc = aDecoder.decodeObject(forKey: "description") as! String?
        self.price = aDecoder.decodeObject(forKey: "price") as! Int?
        self.imageUrl = aDecoder.decodeObject(forKey: "imageUrl") as! String?
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.desc, forKey: "description")
        aCoder.encode(self.price, forKey: "price")
        aCoder.encode(self.imageUrl, forKey: "imageUrl")
    }

    func mapping(map: Map) {
        self.id       <- map["productId"]
        self.title    <- map["title"]
        self.desc     <- map["productDescription"]
        self.price    <- map["price"]
        self.imageUrl <- map["imageUrl"]
    }
}
