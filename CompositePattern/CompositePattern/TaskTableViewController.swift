//
//  TaskTableViewController.swift
//  CompositePattern
//
//  Created by Alexander Obotnin on 24.12.2022.
//
//

import UIKit

class TaskTableViewController: UITableViewController {
    
    public var currentTaskGroup: Task?
    
    public var tasksList: [CompositeTask] = [CompositeTask(name: "Задача 1", tasks: [ConcreteTask(name: "Подзадача 1")]),    CompositeTask(name: "Задача 2", tasks: [ConcreteTask(name: "Подзадача 2")])]
    
    override func viewDidLoad(){
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    public var currentTaskNumber: Int?{
        didSet {
            if let currentTaskNumber = self.currentTaskNumber {
                if let currentTaskGroup = self.currentTaskGroup {
                    self.currentTaskGroup = currentTaskGroup.subTask[currentTaskNumber]
                } else {
                    self.currentTaskGroup = tasksList[currentTaskNumber]
                }
            } else {
                self.currentTaskGroup = nil
            }
            
            self.tableView.reloadData()
        }
    }
    
    @IBAction func addButtonAction(_ sender: Any){
        let alert = UIAlertController(title: "Название задачи", message: "Напишите название задачи", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        
        let ok = UIAlertAction(title: "Ok", style: .default){ (_) in
            if let textField = alert.textFields,
                textField.count > 0,
                let taskTitle = textField[0].text,
                taskTitle.isEmpty == false
            {
                self.addTask(title: taskTitle)
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func addTask (title: String){
        if let currentTaskGroup = currentTaskGroup{
            if let currentTask = currentTaskGroup as? ConcreteTask{
                self.currentTaskGroup = CompositeTask(name: currentTask.name, tasks: [])
            }
            self.currentTaskGroup?.add(task: ConcreteTask(name: title))
            
        } else {
            tasksList.append(CompositeTask(name: title, tasks: []))
        }
        self.tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let currentTask = currentTaskGroup{
            return currentTask.count
        } else {
            return tasksList.count
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentTaskNumber = indexPath.row
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskListCell", for: indexPath)
        let task: Task
        if let currentTask = currentTaskGroup{
            task = currentTask.subTask[indexPath.row]
        } else {
            task = tasksList[indexPath.row]
        }
        
        cell.textLabel?.text = task.name
    
        return cell
    }
}
