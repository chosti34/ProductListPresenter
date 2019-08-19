//
//  ShoppingCartViewController.swift
//  ProductListPresenter
//
//  Created by Тимур on 19.08.19.
//  Copyright © 2019 Timur. All rights reserved.
//

import UIKit

class ShoppingCartViewController: UITableViewController {

    var selectedProduct: Product? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let productDetailsViewController = segue.destination as? ProductDetailsViewController {
            // Get the new view controller using segue.destinationViewController.
            // Pass the selected object to the new view controller.
            assert(selectedProduct != nil)
            productDetailsViewController.product = self.selectedProduct
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return App.instance.shoppingCart.getProductCount()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingCartProductCell", for: indexPath)
        let product = App.instance.shoppingCart.getProduct(at: indexPath.row)
        cell.textLabel?.text = product.title + (product.price != nil ? " ($\(product.price!))" : "")
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.selectedProduct = App.instance.shoppingCart.getProduct(at: indexPath.row)
        self.performSegue(withIdentifier: "ShoppingCartToProductDetailsSegue", sender: self)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            App.instance.shoppingCart.removeProduct(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}
