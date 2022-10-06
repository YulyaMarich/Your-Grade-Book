//
//  SubjectsListViewController.swift
//  Your Grade Book
//
//  Created by Julia on 04.01.2022.
//

import UIKit
import RealmSwift

class SubjectsListViewController: UITableViewController {
    
    var subjects: Results<Subject>!
    var subjectToChange: Subject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subjects = StorageManager.shared.realm.objects(Subject.self)
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        subjects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subjectListCell", for: indexPath) as! SubjectListTableViewCell
        
        let subject = subjects[indexPath.row]
        let results = StorageManager.shared.getNumberForSubject(subject: subject)
        
        cell.configure(with: subject, mark: results)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            let subjectToDelete = self.subjects[indexPath.row]
            StorageManager.shared.deleteSubject(subject: subjectToDelete)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { ( _, _, isDone) in
            self.subjectToChange = self.subjects[indexPath.row]
            self.performSegue(withIdentifier: "changeSubject", sender: self)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeSubject" {
            let navigationVC = segue.destination as! UINavigationController
            let changeSubjectVC = navigationVC.topViewController as! NewSubjectViewController
            changeSubjectVC.subject = subjectToChange
        } else if segue.identifier == "showTasks" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let subject = subjects[indexPath.row]
            let subjectVC = segue.destination as! SubjectViewController
            subjectVC.currentSubject = subject
        }
    }
}


