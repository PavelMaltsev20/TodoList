//
//  ViewController.swift
//  TodoList
//
//  Created by Pavel Maltsev on 22/09/2021.
//

import UIKit
import RealmSwift

class TasksViewController: UITableViewController {
    
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
    
    //MARK: - Core data
    func storeData(task: String) {
        if let category = selectedCategory{
            do {
                try self.realm.write{
                    let newTask = Task()
                    newTask.title = task
                    category.tasks.append(newTask)
                }
            }catch  {
                print(error)
            }
            
            tableView.reloadData()
        }
    }
    
    func fetchTasksData(){
        tasks = selectedCategory?.tasks.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    //MARK: - TableView
    
    //Items count (numberOfRowsInSection)
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks?.count ?? 1
    }
    
    //Init cell (cellForRowAt)
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Cells.taskCell, for: indexPath)
        if let item = tasks?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.isComlete ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No items added"
        }
        
        return cell
    }
    
    //On cell selected (didSelectRowAt)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tasks?[indexPath.row].isComlete = !(tasks?[indexPath.row].isComlete ?? false)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

//extension TasksViewController: UISearchBarDelegate{
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request: NSFetchRequest<Task> = Task.fetchRequest()
//        let predicate = NSPredicate(format: K.CoreData.searchPredicate, searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        fetchTasksData(with: request, predicate: predicate)
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if(searchBar.text?.count == 0){
//            fetchTasksData()
//
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
//
//}
