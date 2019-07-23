//
//  App.swift
//  ProductListPresenter
//
//  Created by Тимур on 15.07.19.
//  Copyright © 2019 Timur. All rights reserved.
//

import UIKit

class App {

    static let instance = App()

    let categoryApi = CategoryApi()
    let productApi = ProductApi()

    // Запрещаем создание экземпляра данного класса
    private init() {}

}
