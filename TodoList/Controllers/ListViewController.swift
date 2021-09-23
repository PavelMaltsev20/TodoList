//
//  ViewController.swift
//  TodoList
//
//  Created by Pavel Maltsev on 22/09/2021.
//

import UIKit
import CoreData

class ListViewController: UITableViewController {
    
    var tasks = [Task]()
    let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Tasks.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate) .persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        fetchData()
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
        return newTask
    }
    
    func storeData() {
        do{
            try context.save()
            tableView.reloadData()
        }catch{
            print(error)
        }
    }

    func fetchData(with request : NSFetchRequest<Task> = Task.fetchRequest()){
        do{
            tasks = try context.fetch(request)
            tableView.reloadData()
        }catch{
            print(error)
        }
    }

    //MARK: - TableView
    
    //Items count (numberOfRowsInSection)
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    //Init cell (cellForRowAt)
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.tableViewCellName, for: indexPath)
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

extension ListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        fetchData(with: request)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if(searchBar.text?.count == 0){
            fetchData()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
