//
//  CategoryViewCell.swift
//  TodoList
//
//  Created by Pavel Maltsev on 23/09/2021.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        //init alert
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        //adding textfield to alert
        var textField = UITextField()
        alert.addTextField(configurationHandler: {(alertTextField)in
            alertTextField.placeholder = "enter category name"
            textField = alertTextField
        })
        
        //adding action to alert
        let action = UIAlertAction(title: "add", style: .default, handler: {(action) in
            let categoryName = textField.text!.isEmpty ? K.defaultCategoryName:textField.text!
            self.storeData(category: self.initCategory(categoryName))
        })
        alert.addAction(action)
        
        //show alert
        present(alert, animated: true, completion: nil)
    }
    
    func initCategory(_ name: String) -> Category {
        let category = Category()
        category.title = name
        return category
    }
    
    
    //MARK: - Managing Realm
    func storeData(category: Category){
        do {
            try realm.write{
                realm.add(category)
            }
        } catch  {
            print(error)
        }
        tableView.reloadData()
    }
    
    
    func fetchData(){
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    func deleteData(delete category: Category){
        do{
            try realm.write{
                realm.delete(category)
            }
        }catch{
            print(error)
        }
    }
    
    
    //MARK: - Overriding methods
    override func deleteDataAt(at indexPath: IndexPath){
        if let category = categories?[indexPath.row]{
            deleteData(delete: category)
        }
    }
    
    
    //MARK: - TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let item = categories?[indexPath.row]
        
        cell.textLabel?.text = item?.title ?? "No categories added yet"
        cell.backgroundColor = UIColor.randomFlat()
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.Segue.openTasksView, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //the segue of new view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TasksViewController
        
        if let index = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[index.row]
        }
    }
    
}
