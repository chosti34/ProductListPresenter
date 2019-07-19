//
//  CategoryCollectionViewController.swift
//  ProductListPresenter
//
//  Created by Тимур on 06.07.19.
//  Copyright © 2019 Timur. All rights reserved.
//

import UIKit
import SDWebImage

//TODO: rename CategoryListViewController, CategoriesViewController
class CategoryCollectionViewController: UICollectionViewController {

    var categories: [Category] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let categoryApi: CategoryApi = App.instance.categoryApi

        //TODO: show loader
        categoryApi.fetchAllCategories { (categories: [Category]) in
            self.categories = categories
            self.collectionView?.reloadData()
            //TODO: hide loader
        }

        print("CategoryCollectionViewController - viewDidLoad ended")
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Достаем ячейку с категорией
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCollectionViewCell
        let category: Category = categories[indexPath.row]


        //TODO: move to CategoryCollectionViewCell to constructor init?(coder aDecoder: NSCoder)
        // Конфигурируем интерфейс ячейки
        cell.imageView.layer.borderColor = UIColor.black.cgColor
        cell.imageView.layer.borderWidth = 1

        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 5

        // Устанавливаем заголовок категории
        cell.titleLabel.text = category.title

        // Устанавливаем изображение категории
        let url: URL? = (category.imageUrl != nil) ? URL(string: category.imageUrl!) : nil
        cell.imageView.sd_setImage(
            with: url,
            placeholderImage: UIImage(named: "placeholder"),
            options: SDWebImageOptions.continueInBackground)

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        self.performSegue(withIdentifier: "ProductList", sender: self)
        //TODO: category hierarchy
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let productCollectionViewController = storyboard.instantiateViewController(withIdentifier: "ProductCollectionViewController") as! ProductCollectionViewController

        let category: Category = categories[indexPath.row]
        productCollectionViewController.categoryId = category.id
        productCollectionViewController.categoryName = category.title

        //TODO: remove
        let backItem = UIBarButtonItem()
        backItem.title = self.navigationItem.title
        self.navigationItem.backBarButtonItem = backItem

        self.navigationController?.pushViewController(productCollectionViewController, animated: true)
    }
}
