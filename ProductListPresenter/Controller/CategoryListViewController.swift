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

    // Возможно категории списка являются подкатегориями
    var parentCategory: Category? = nil

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Если это подкатегория
        if self.parentCategory != nil {
            self.navigationItem.rightBarButtonItem = nil
            self.navigationItem.title = "Подкатегории \"\(self.parentCategory!.title)\""
        }

        self.activityIndicator.startAnimating()

        let categoryApi: CategoryApi = App.instance.categoryApi
        categoryApi.fetchCategories(parentId: self.parentCategory?.id) { (categories: [Category]) in
            self.categories = categories
            self.activityIndicator.stopAnimating()
            self.collectionView?.reloadData()
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

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedCategory = self.categories[indexPath.row]

        if self.selectedCategory!.hasSubcategories {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let categoryListViewController = storyboard.instantiateViewController(withIdentifier: "CategoryListViewController")
            let segue = UIStoryboardSegue(identifier: "SegueToItself", source: self, destination: categoryListViewController, performHandler: {
                self.navigationController?.show(categoryListViewController, sender: self)
            })
            self.prepare(for: segue, sender: self)
            segue.perform()
        } else {
            self.performSegue(withIdentifier: "ProductListSegue", sender: self)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToItself" {
            let categoryListViewController = segue.destination as! CategoryListViewController
            categoryListViewController.parentCategory = self.selectedCategory
        }
        if segue.identifier == "ProductListSegue" {
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
}
