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
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Tasks.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTask()
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
            self.tasks.append(Task(title: taskName, isCompleted: false))
            self.storeNewTask()
            self.tableView.reloadData()
        })
        alert.addAction(action)
        
        //show alert
        present(alert, animated: true, completion: nil)
    }
    
    func storeNewTask() {
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(tasks)
            try data.write(to: dataFilePath!)
        }catch{
            print(error)
        }
    }
    
    func loadTask(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                tasks = try decoder.decode([Task].self, from: data)
            }catch{
                print(error)
            }
        }
        
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
        storeNewTask()
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
