//
//  TaskListViewController.swift
//  CoreDataDemoApp
//
//  Created by Ирина Кузнецова on 04.07.2020.
//  Copyright © 2020 Alexey Efimov. All rights reserved.
//

import UIKit
import CoreData

class TaskListViewController: UITableViewController {
    
    private let cellID = "cell"
    private var tasks: [Task] = StorageManager.shared.fetchData()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        setupNavigationBar()
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let edit = UIContextualAction(style: .normal, title: "Edit") {
            (_, _, completionHandler) in completionHandler(true)
            
            let task = self.tasks[indexPath.row]
            tableView.deselectRow(at: indexPath, animated: true)
            self.showAlert(task: task) {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        edit.image = UIImage(systemName: "square.and.pencil")
        edit.backgroundColor = #colorLiteral(red: 0.001868192435, green: 0.6579348838, blue: 0.002898670662, alpha: 1)
        
        let delete = UIContextualAction(style: .normal, title: "Delete") {
            (_, _, completionHandler) in completionHandler(true)
            
            StorageManager.shared.deleteContext(self.tasks[indexPath.row])
            self.tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        delete.image = UIImage(systemName: "trash")
        delete.backgroundColor = .red
        
        let swipe = UISwipeActionsConfiguration(actions: [delete, edit])
        return swipe
    }

    private func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = UIColor(
            red: 21/255,
            green: 101/255,
            blue: 192/255,
            alpha: 194/255
        )
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTask)
        )
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc private func addTask() {
        showAlert()
    }
}

// MARK: - Table view data source
extension TaskListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Alert Controller
extension TaskListViewController {
    
    private func showAlert(task: Task? = nil, completion: (() -> Void)? = nil) {
        
        var title = "New Task"
        if task != nil { title = "Edit Task" }
        
        let alert = AlertController(title: title, message: "What do you want to do?", preferredStyle: .alert)
        
        alert.action(task: task) { newValue in
            if let task = task, let completion = completion {
                StorageManager.shared.edit(task, newName: newValue)
                completion()
            } else {
                StorageManager.shared.save(newValue) { task in
                    self.tasks.append(task)
                    self.tableView.insertRows(
                        at: [IndexPath(row: self.tasks.count - 1, section: 0)],
                        with: .automatic
                    )
                }
            }
        }
        
        present(alert, animated: true)
    }
}
