//
//  CategoryCollectionViewController.swift
//  ProductListPresenter
//
//  Created by Тимур on 06.07.19.
//  Copyright © 2019 Timur. All rights reserved.
//

import UIKit
import SDWebImage
import MBProgressHUD

class CategoryListViewController: UICollectionViewController {

    // Список категорий для отображения
    var categories: [Category] = []

    // Выбранная категория для перехода на следующий экран
    var selectedCategory: Category? = nil

    // Возможно категории списка являются подкатегориями
    var parentCategory: Category? = nil

    var progressHUD: MBProgressHUD? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Если это подкатегория
        if self.parentCategory != nil {
            self.navigationItem.rightBarButtonItem = nil
            self.navigationItem.title = "Подкатегории \"\(self.parentCategory!.title)\""
        }

        print("CategoryCollectionViewController - viewDidLoad ended")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("categories viewWillAppear")

        if self.progressHUD != nil {
            self.progressHUD?.hide(animated: true)
        }

        self.progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        App.instance.categoryApi.fetchCategories(parentId: self.parentCategory?.id) { (categories: [Category]) in
            self.categories = categories
            self.progressHUD?.hide(animated: true)
            self.collectionView?.reloadData()
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        // Достаем ячейку с категорией
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell

        // Задаем кнопке в ячейке индекс продукта (сохраняем в тег)
        cell.segueButton.tag = indexPath.row

        let category: Category = categories[indexPath.row]

        // Устанавливаем заголовок категории
        cell.titleLabel.text = category.title

        // Устанавливаем информацию о подкатегориях
        cell.subcategoriesInfoLabel.text = category.hasSubcategories ? "Есть подкатегории" : "Нет подкатегорий"

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
            self.performSegue(withIdentifier: "CategoryListToItselfSegue", sender: self)
        } else {
            self.performSegue(withIdentifier: "CategoryListToProductListSegue", sender: self)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let categoryListViewController = segue.destination as? CategoryListViewController {
            categoryListViewController.parentCategory = self.selectedCategory
        } else if let productListViewController = segue.destination as? ProductListViewController {
            // Если переход на экран списка товаров был вызван данным контроллером,
            // тогда пользователем была выбрана конкретная категория. Иначе категория
            // не определена, пользователю будут показаны товары всех категорий
            if (sender as? CategoryListViewController) != nil {
                assert(selectedCategory != nil)
                productListViewController.category = self.selectedCategory
            }
        }
    }

    @IBAction func onCategoryDetailsButtonPress(_ sender: UIButton) {
        self.selectedCategory = self.categories[sender.tag]

        if self.selectedCategory!.hasSubcategories {
            self.performSegue(withIdentifier: "CategoryListToItselfSegue", sender: self)
        } else {
            self.performSegue(withIdentifier: "CategoryListToProductListSegue", sender: self)
        }
    }
}
