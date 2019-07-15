//
//  CollectionViewCell.swift
//  ProductListPresenter
//
//  Created by Тимур on 05.07.19.
//  Copyright © 2019 Timur. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var segueButton: ProductCellButton!
}
