//
//  CategoryCollectionViewController.swift
//  ProductListPresenter
//
//  Created by Тимур on 06.07.19.
//  Copyright © 2019 Timur. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class CategoryCollectionViewController: UICollectionViewController {

    static var appKey = "yx-1PU73oUj6gfk0hNyrNUwhWnmBRld7-SfKAU7Kg6Fpp43anR261KDiQ-MY4P2SRwH_cd4Py1OCY5jpPnY_Viyzja-s18njTLc0E7XcZFwwvi32zX-B91Sdwq1KeZ7m"
    let url = "http://ostest.whitetigersoft.ru/api/common/category/list?appKey=\(appKey)"

    var categories: [Category] = []

    private func parseAndAppendCategory(categoryJson: [String: Any]) {
        let categoryId: Int = categoryJson["categoryId"] as! Int
        let title: String = categoryJson["title"] as! String
        let imageUrl: String? = categoryJson["imageUrl"] as? String
        
        let category: Category = Category(id: categoryId, title: title, imageUrl: imageUrl)
        categories.append(category)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Запрашиваем список категорий
        Alamofire.request(self.url).validate().responseJSON { response in
            if !response.result.isSuccess {
                print("Error")
                return
            }

            if let json = response.result.value as? [String: [String: Any]] {
                if let categoriesJson = json["data"]!["categories"]! as? [[String: Any]] {
                    for categoryJson in categoriesJson {
                        self.parseAndAppendCategory(categoryJson: categoryJson)
                    }
                }
            }

            self.collectionView?.reloadData()
        }

        // Do any additional setup after loading the view.
        print("CategoryCollectionViewController - viewDidLoad ended")
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Достаем ячейку с категорией
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCollectionViewCell
        let category: Category = categories[indexPath.row]

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
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let productCollectionViewController = storyboard.instantiateViewController(withIdentifier: "ProductCollectionViewController") as! ProductCollectionViewController

        let category: Category = categories[indexPath.row]
        productCollectionViewController.categoryId = category.id
        productCollectionViewController.categoryName = category.title

        self.navigationController?.pushViewController(productCollectionViewController, animated: true)
    }
}










