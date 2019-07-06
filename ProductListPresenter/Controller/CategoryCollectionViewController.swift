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

    let url = "http://ostest.whitetigersoft.ru/api/common/category/list?appKey=yx-1PU73oUj6gfk0hNyrNUwhWnmBRld7-SfKAU7Kg6Fpp43anR261KDiQ-MY4P2SRwH_cd4Py1OCY5jpPnY_Viyzja-s18njTLc0E7XcZFwwvi32zX-B91Sdwq1KeZ7m"
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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        // self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CategoryCell")

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return categories.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath)
            as! CategoryCollectionViewCell
        
        let category: Category = categories[indexPath.item]
        
        // Configure the cell
        cell.titleLabel.text = category.title
        cell.imageView.layer.borderColor = UIColor.black.cgColor
        cell.imageView.layer.borderWidth = 1
        
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 10
        
        if let imageUrl = category.imageUrl {
            if let url = URL(string: imageUrl) {
                cell.imageView.sd_setImage(with: url)
            }
        }
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
