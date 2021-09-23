//
//  ViewController.swift
//  TodoList
//
//  Created by Pavel Maltsev on 22/09/2021.
//

import UIKit
import CoreData

class TasksViewController: UITableViewController {
    
    var selectedCategory: UserCategory?{
        didSet{
            fetchTasksData()
        }
    }
    var tasks = [Task]()
    let context = (UIApplication.shared.delegate as! AppDelegate) .persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            self.tasks.append(self.initTaskItem(taskName))
            self.storeData()
        })
        alert.addAction(action)
        
        //show alert
        present(alert, animated: true, completion: nil)
    }
    
    func initTaskItem(_ taskName: String) -> Task {
        let newTask = Task(context: context)
        newTask.title = taskName
        newTask.isCompleted = false
        newTask.parentCategory = selectedCategory
        return newTask
    }
    
    //MARK: - Core data
    func storeData() {
        do{
            try context.save()
        }catch{
            print(error)
        }
        tableView.reloadData()
    }
    
    func fetchTasksData(with request : NSFetchRequest<Task> = Task.fetchRequest(),
                        predicate: NSPredicate? = nil){
        
        
        let categoryPredicate = NSPredicate(format: K.CoreData.categoryPredicate, selectedCategory!.title!)
        
        if let savePredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, savePredicate])
        }else{
            request.predicate = categoryPredicate
        }
        
        do{
            tasks = try context.fetch(request)
        }catch{
            print(error)
        }
        tableView.reloadData()
    }
    
    //MARK: - TableView
    
    //Items count (numberOfRowsInSection)
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    //Init cell (cellForRowAt)
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Cells.taskCell, for: indexPath)
        let item = tasks[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.accessoryType = item.isCompleted ? .checkmark : .none
        
        return cell
    }
    
    //On cell selected (didSelectRowAt)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tasks[indexPath.row].isCompleted = !tasks[indexPath.row].isCompleted
        
        //Important to save order of methods. Firstly remove from Core Data and only then from tasks array.
        //Reason- we need firstly received Task object that stored in tasks array.
        context.delete(tasks[indexPath.row])
        tasks.remove(at: indexPath.row)
        
        storeData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension TasksViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        let predicate = NSPredicate(format: K.CoreData.searchPredicate, searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        fetchTasksData(with: request, predicate: predicate)
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
