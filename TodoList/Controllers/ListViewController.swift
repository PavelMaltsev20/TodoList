//
//  ViewController.swift
//  TodoList
//
//  Created by Pavel Maltsev on 22/09/2021.
//

import UIKit

class ListViewController: UITableViewController {
    
    var tasks = [Task]()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasks.append(Task(title: "Cook diner" ,isCompleted: false))
        tasks.append(Task(title: "Online meatig" ,isCompleted: true))
        tasks.append(Task(title: "Clean room" ,isCompleted: false))
        
        
        if let items = defaults.array(forKey: K.userDefaultsKey) as? [Task]{
            tasks = items
        }
        
    }
    
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
            
            var taskName = textField.text!
            
            if(taskName.isEmpty){
                taskName = K.defaultTaskName
            }
            
            self.tasks.append(Task(title: taskName, isCompleted: false))
            self.defaults.set(self.tasks, forKey: K.userDefaultsKey)
            self.tableView.reloadData()
        })
        alert.addAction(action)
        
        //show alert
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView
    
    //tableview items coune (numberOfRowsInSection)
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    //tableview init cell (cellForRowAt)
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.tableViewCellName, for: indexPath)
        let item = tasks[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.accessoryType = item.isCompleted ? .checkmark : .none
        
        return cell
    }
    
    //tableview on cell selected (didSelectRowAt)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tasks[indexPath.row].isCompleted = !tasks[indexPath.row].isCompleted
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
