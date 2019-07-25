//
//  CategoryCollectionViewController.swift
//  ProductListPresenter
//
//  Created by Тимур on 06.07.19.
//  Copyright © 2019 Timur. All rights reserved.
//

import UIKit
import SDWebImage

class CategoryListViewController: UICollectionViewController {

    // Список категорий для отображения
    var categories: [Category] = []

    // Выбранная категория для перехода на следующий экран
    var selectedCategory: Category? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        let categoryApi: CategoryApi = App.instance.categoryApi
        // TODO: show loader
        categoryApi.fetchCategories(parentId: nil) { (categories: [Category]) in
            self.categories = categories
            self.collectionView?.reloadData()
            // TODO: hide loader
        }

        print("CategoryCollectionViewController - viewDidLoad ended")
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        // Достаем ячейку с категорией
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        let category: Category = categories[indexPath.row]

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

    // TODO: category hierarchy
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        self.selectedCategory = self.categories[indexPath.row]
        self.performSegue(withIdentifier: "ProductList", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let productListViewController = segue.destination as! ProductListViewController

        // Если переход на экран списка товаров был вызван данным контроллером,
        // тогда пользователем была выбрана конкретная категория. Иначе категория
        // не определена, пользователю будут показаны товары всех категорий
        if (sender as? CategoryListViewController) != nil {
            assert(selectedCategory != nil)
            productListViewController.category = self.selectedCategory
        }
    }
}
