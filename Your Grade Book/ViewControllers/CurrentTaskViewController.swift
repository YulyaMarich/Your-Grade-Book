
//  CurrentTaskViewController.swift
//  Your Grade Book
//
//  Created by Julia on 11.01.2022.


import UIKit
import RealmSwift

class CurrentTaskViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var newTaskButton: UIButton!
    
    private var name: String!
    var task: Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpVC()
    }
    
    // MARK: - IBACtion functions
    
    @IBAction func addOneMoreTask() {
        let currentTask = CurrentTask()
        currentTask.point = 0.0
        StorageManager.shared.save(currentTask: currentTask, into: task)
        self.tableView.reloadData()
    }
    
    // MARK: - Setting functions
    
    private func setUpVC() {
        title = task.name
        navigationController?.navigationBar.tintColor = .black
        newTaskButton.layer.cornerRadius = 10
    }
    
    // MARK: - Navigation functions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeTask" {
            let navigationVC = segue.destination as! UINavigationController
            let newSubjectVC = navigationVC.topViewController as! NewCurrentTaskViewController
            newSubjectVC.currentTask = task
        }
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if task.points.count == 0 {
            let emptyLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
            emptyLabel.text = "You have no points😉"
            emptyLabel.textColor = .gray
            emptyLabel.textAlignment = NSTextAlignment.center
            self.tableView.backgroundView = emptyLabel
            return 0
        } else {
            self.tableView.backgroundView = nil
            return task.points.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "currentTaskCell", for: indexPath) as! CurrentTaskTableViewCell
        
        cell.delegate = self
        
        let cellName = task.name + " \(indexPath.row + 1)"
        let cellMark = String(task.points[indexPath.row].point)
        
        cell.task = task
        cell.currentTask = task.points[indexPath.row]
        
        
        cell.configure(name: cellName, mark: cellMark)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            let pointToDelete = self.task.points[indexPath.row]
            StorageManager.shared.deletePoint(point: pointToDelete)
            tableView.deleteRows(at: [indexPath], with: .automatic)
           
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension CurrentTaskViewController: CurrentTaskCellDelegate {
    
    func showSomeAlert(with title: String, message: String) {
        self.showAlert(with: title, message: message)
    }
    
    func isWrongFormatOf(input: String) -> Bool {
        self.isWrongFormatOf(text: input)
    }
    
    func getDoubleFrom(text: String) -> String {
        makeStringInTheFormOfDoubleFrom(text: text)
    }
}
