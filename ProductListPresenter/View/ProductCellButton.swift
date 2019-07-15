//
//  ProductCellButton.swift
//  ProductListPresenter
//
//  Created by Тимур on 14.07.19.
//  Copyright © 2019 Timur. All rights reserved.
//

import UIKit

class ProductCellButton: UIButton {

    var productId: Int? = nil

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
