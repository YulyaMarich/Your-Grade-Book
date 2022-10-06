//
//  SubjectViewController.swift
//  Your Grade Book
//
//  Created by Julia on 04.01.2022.
//

import UIKit
import RealmSwift

class SubjectViewController: UITableViewController {
    
    var currentSubject: Subject!
    var results = 0.0
    var tasks: List<Task>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tasks = currentSubject.tasks
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subjectCell", for: indexPath)
        as! SubjectTableViewCell
        
        let task = tasks[indexPath.row]
        let mark = StorageManager.shared.getNumberForTask(task: task)
        
        results = mark
        
        cell.configure(with: task, mark: mark)
        changeCellBackroundColor(indexPath: indexPath, cell: cell)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            let taskToDelete = self.tasks[indexPath.row]
            StorageManager.shared.deleteTask(task: taskToDelete)
            
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
   
    //MARK: - Navigation function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigationVC = segue.destination as? UINavigationController, let newSubjectVC = navigationVC.topViewController as? NewCurrentTaskViewController {
            newSubjectVC.subject = currentSubject
        } else {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let currentTaskVC = segue.destination as! CurrentTaskViewController
            let currentTask = tasks[indexPath.row]
            currentTaskVC.task = currentTask
        }
    }
    
    //MARK: - Setting function
    func changeCellBackroundColor(indexPath: IndexPath, cell: SubjectTableViewCell) {
        let task = tasks[indexPath.row]
        if results < (Double(task.maxPoint)/2) {
            cell.backgroundColor = .red
        } else {
            cell.backgroundColor = .green
        }
    }
}

