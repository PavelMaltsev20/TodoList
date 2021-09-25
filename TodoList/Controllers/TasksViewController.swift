//
//  ViewController.swift
//  TodoList
//
//  Created by Pavel Maltsev on 22/09/2021.
//

import UIKit
import RealmSwift

class TasksViewController: SwipeTableViewController {
    
    var tasks: Results<Task>?
    let realm = try! Realm()
    var selectedCategory: Category?{
        didSet{
            fetchTasksData()
        }
    }
    
    //MARK: - Alert controller region
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        //init alert
        let alert = UIAlertController(title: "Add new task", message: "", preferredStyle: .alert)
        
        //adding textfield to alert
        var textField = UITextField()
        alert.addTextField(configurationHandler: {(alertTextField)in
            alertTextField.placeholder = "enter name of task"
            textField = alertTextField
        })
        
        //adding action to alert
        let action = UIAlertAction(title: "add", style: .default, handler: {(action) in
            let taskName = textField.text!.isEmpty ? K.defaultTaskName:textField.text!
            self.storeData(task: taskName)
        })
        alert.addAction(action)
        
        //show alert
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Realm data
    func storeData(task: String) {
        if let category = selectedCategory{
            do {
                try self.realm.write{
                    let newTask = Task()
                    newTask.title = task
                    newTask.dateCreated = Date()
                    category.tasks.append(newTask)
                }
            }catch  {
                print(error)
            }
            
            tableView.reloadData()
                        }
    }
    
    func fetchTasksData(){
        tasks = selectedCategory?.tasks.sorted(byKeyPath: "isComlete", ascending: true)
        tableView.reloadData()
    }
    
    func deleteData(delete task: Task){
        do{
            try realm.write{
                realm.delete(task)
            }
        }catch{
            print(error)
        }
    }
    
    
    //MARK: - Overriding methods
    override func deleteDataAt(at indexPath: IndexPath){
        if let task = tasks?[indexPath.row]{
            deleteData(delete: task)
        }
    }
    
    
    //MARK: - TableView
    
    //Items count (numberOfRowsInSection)
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks?.count ?? 1
    }
    
    //Init cell (cellForRowAt)
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = tasks?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.isComlete ? .checkmark    : .none
        }else{
            cell.textLabel?.text = "No items added"
        }
        
        return cell
    }
    
    //On cell selected (didSelectRowAt)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = tasks?[indexPath.row]{
            do {
                try realm.write{
                    item.isComlete = !item.isComlete
                    tableView.reloadData()

                }
            } catch  {
                print(error)
            }
        }
    }
    
}


//MARK: - Search section
extension TasksViewController: UISearchBarDelegate{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        tasks = tasks?.filter(K.Predict.searchByTitle, searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
//        Core data query
//        let request: NSFetchRequest<Task> = Task.fetchRequest()
//        let predicate = NSPredicate(format: K.CoreData.searchPredicate, searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        fetchTasksData(with: request, predicate: predicate)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchBar.text?.count == 0){
            fetchTasksData()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }

}
