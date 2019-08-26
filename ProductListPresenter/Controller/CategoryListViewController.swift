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

class CategoryListViewController: BaseCollectionViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    //var refreshControl: UIRefreshControl!

    var categories: [Category] = []

    // Выбранная пользователем категория для перехода на следующий экран
    var selectedCategory: Category? = nil

    // Родительская категория для отображения подкатегорий на данном экране
    var parentCategory: Category? = nil

    var categoryApi: CategoryApi! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.addSubview(self.refreshControl)

        self.categoryApi = App.instance.categoryApi

        // Указываем информацию о родительской категории
        if self.parentCategory != nil {
            self.navigationItem.title = "Подкатегории \"\(self.parentCategory!.title)\""
        }

        MBProgressHUD.showAdded(to: self.view, animated: true)

        let errorCallback = { () -> Void in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.showLoadingErrorNotificationAlert(message: "Произошла ошибка при загрузке категорий")
        }

        let successCallback = { (categories: [Category]) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.categories = categories
            self.collectionView?.reloadData()
        }

        self.categoryApi.fetchCategories(parentId: self.parentCategory?.id, completionHandler: successCallback, errorHandler: errorCallback)
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

    override func refreshCollectionViewDataImpl() {
        let errorCallback = { () -> Void in
            self.collectionView.setContentOffset(CGPoint.zero, animated: true)
            self.refreshControl.endRefreshing()
            self.showLoadingErrorNotificationAlert(message: "Произошла ошибка при загрузке категорий")
        }

        let successCallback = { (categories: [Category]) in
            self.refreshControl.endRefreshing()
            self.categories = categories
            self.collectionView?.reloadData()
        }

        self.categoryApi.fetchCategories(parentId: self.parentCategory?.id, completionHandler: successCallback, errorHandler: errorCallback)
    }

    private func performSegueToProductListView(toCategoryIndex index: Int) {
        self.selectedCategory = self.categories[index]
        assert(self.selectedCategory != nil)

        if self.selectedCategory!.hasSubcategories {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let categoryListViewController = storyboard.instantiateViewController(withIdentifier: "CategoryListViewController")
            let segue = UIStoryboardSegue(identifier: "CategoryListToSubcategoryListSegue", source: self, destination: categoryListViewController, performHandler: {
                self.navigationController?.pushViewController(categoryListViewController, animated: true)
            })
            self.prepare(for: segue, sender: self)
            segue.perform()
        } else {
            self.performSegue(withIdentifier: "CategoryListToProductListSegue", sender: self)
        }
    }

    @IBAction func onCategoryDetailsButtonPress(_ sender: RoundedButton) {
        self.performSegueToProductListView(toCategoryIndex: sender.tag)
    }
}

extension CategoryListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Достаем ячейку с категорией
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCollectionViewCell

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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegueToProductListView(toCategoryIndex: indexPath.row)
    }
}
