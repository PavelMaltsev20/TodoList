//
//  ViewController.swift
//  TodoList
//
//  Created by Pavel Maltsev on 22/09/2021.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TasksViewController: SwipeTableViewController {
    
    @IBOutlet weak var addBtn: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    var tasks: Results<Task>?
    let realm = try! Realm()
    var selectedCategory: Category?{
        didSet{
            fetchTasksData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
    }
    
    func setNavigationBar() {
        if let category = selectedCategory{
            if let navBar = navigationController?.navigationBar{
                let primaryColor = UIColor.init(hexString: category.color)!
                let onPrimaryColor = UIColor(contrastingBlackOrWhiteColorOn: primaryColor, isFlat: true)
                title = category.title

                navBar.backgroundColor = primaryColor
                navBar.barTintColor = primaryColor
                navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: onPrimaryColor]
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: onPrimaryColor]
                searchBar.barTintColor = primaryColor
                view.backgroundColor = primaryColor

                navBar.tintColor = onPrimaryColor
                searchBar.tintColor = onPrimaryColor
                addBtn.tintColor = onPrimaryColor
                searchBar.searchTextField.textColor = onPrimaryColor


            }
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
        tasks = selectedCategory?.tasks.sorted(byKeyPath: "dateCreated", ascending: true)
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
            if let color = UIColor.init(hexString: selectedCategory!.color)!.darken(byPercentage: (CGFloat(indexPath.row) / CGFloat(tasks!.count))){
                cell.backgroundColor = color
                cell.tintColor = UIColor.init(contrastingBlackOrWhiteColorOn: color, isFlat: true)
                cell.textLabel?.textColor = UIColor.init(contrastingBlackOrWhiteColorOn: color, isFlat: true)
            }
            
            cell.textLabel?.text = item.title
            cell.accessoryType = item.isComlete ? .checkmark : .none
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
