//
//  CollectionViewCell.swift
//  ProductListPresenter
//
//  Created by Тимур on 05.07.19.
//  Copyright © 2019 Timur. All rights reserved.
//

import UIKit

class ProductCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var segueButton: RoundedButton!

    // self.imageView равен nil в момент вызова конструктора,
    // поэтому используется метод awakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()

        // Ячейка продукта будет иметь черную скругленную рамку
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10

        // Изображние также будет иметь черную рамку
        self.imageView.layer.borderColor = UIColor.black.cgColor
        self.imageView.layer.borderWidth = 1
    }

    override func prepareForReuse() {
        self.titleLabel.text = nil
        self.priceLabel.text = nil
        self.imageView.image = nil
    }

}
