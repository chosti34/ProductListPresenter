//
//  CategoryCollectionViewCell.swift
//  ProductListPresenter
//
//  Created by Тимур on 06.07.19.
//  Copyright © 2019 Timur. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subcategoriesInfoLabel: UILabel!
    @IBOutlet weak var segueButton: RoundedButton!

    // self.imageView равен nil в момент вызова конструктора,
    // поэтому используется метод awakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()

        // Ячейка категории будет иметь скругленную рамку
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5

        // Картинка внутри ячейки также будет иметь рамку
        self.imageView.layer.borderColor = UIColor.gray.cgColor
        self.imageView.layer.borderWidth = 1
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
        self.titleLabel.text = nil
    }

}
