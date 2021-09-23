//
//  CategoryViewCell.swift
//  TodoList
//
//  Created by Pavel Maltsev on 23/09/2021.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate) .persistentContainer.viewContext
    var categories = [UserCategory]()
    
    override func viewDidLoad() {
        
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
            self.categories.append(self.initCategory(categoryName))
            self.storeData()
        })
        alert.addAction(action)
        
        //show alert
        present(alert, animated: true, completion: nil)
    }
    
    func initCategory(_ name: String) -> UserCategory {
        let category = UserCategory(context: context)
        category.title = name
        return category
    }
    
    
    //MARK: - Managing Core Data
    func storeData(){
        do {
            try context.save()
        } catch  {
            print(error)
        }
        tableView.reloadData()
    }
    
    
    func fetchData(with request : NSFetchRequest<UserCategory> = UserCategory.fetchRequest()){
        do{
            categories = try context.fetch(request)
        }catch{
            print(error)
        }
        tableView.reloadData()
    }
    
    
    //MARK: - TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Cells.categoryCell, for: indexPath)
        let item = categories[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.Segue.openTasksView, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TasksViewController

        if let index = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories[index.row]
        }
    }
    
}
