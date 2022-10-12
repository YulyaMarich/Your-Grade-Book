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
    private var results = 0.0
    private var tasks: List<Task>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    //MARK: - Setting functions
    
    private func setUpVC() {
        tasks = currentSubject.tasks
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func changeCellBackroundColor(indexPath: IndexPath, cell: SubjectTableViewCell) {
        let task = tasks[indexPath.row]
        
        if results < (Double(task.maxPoint)/2) {
            cell.backgroundColor = UIColor(red: 0.929, green: 0.416, blue: 0.369, alpha: 1)
        } else {
            cell.backgroundColor = UIColor(red: 97/255, green: 197/255, blue: 84/255, alpha: 1)
        }
    }
    
    //MARK: - Navigation functions
    
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
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tasks.count == 0 {
            let emptyLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
            emptyLabel.text = "Your task's list is empty😉"
            emptyLabel.textColor = .gray
            emptyLabel.textAlignment = NSTextAlignment.center
            self.tableView.backgroundView = emptyLabel
            return 0
        } else {
            self.tableView.backgroundView = nil
            return tasks.count
        }
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44
    }
}

