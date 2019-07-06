//
//  Category.swift
//  ProductListPresenter
//
//  Created by Тимур on 06.07.19.
//  Copyright © 2019 Timur. All rights reserved.
//

import UIKit

class Category {
    var id: Int = 0
    var title: String = ""
    var imageUrl: String? = nil
    
    init(id: Int, title: String, imageUrl: String?) {
        self.id = id
        self.title = title
        self.imageUrl = imageUrl
    }
}
