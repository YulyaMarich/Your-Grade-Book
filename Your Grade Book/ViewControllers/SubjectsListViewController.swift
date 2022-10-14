//
//  SubjectsListViewController.swift
//  Your Grade Book
//
//  Created by Julia on 04.01.2022.
//

import UIKit
import RealmSwift

class SubjectsListViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    var subjects: Results<Subject>!
    var subjectToChange: Subject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpVC()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Setting functions
    
    private func setUpVC() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        subjects = StorageManager.shared.realm.objects(Subject.self)
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "")
    }
    
    private func changeCellBackroundColor(indexPath: IndexPath, cell: SubjectListTableViewCell) {
        let subject = subjects[indexPath.row]
        let result = StorageManager.shared.getNumberForSubject(subject: subject)
        
        if  result <= (Double(subject.maxPoint)/3) {
            cell.backgroundColor = UIColor(red: 0.929, green: 0.416, blue: 0.369, alpha: 1)
        } else if result <= (Double(subject.maxPoint)/1.5) {
            cell.backgroundColor = UIColor(red: 0.953, green: 0.749, blue: 0.306, alpha: 1)
        } else {
            cell.backgroundColor = UIColor(red: 97/255, green: 197/255, blue: 84/255, alpha: 1)
        }
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

extension SubjectsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if subjects.count == 0 {
            let emptyLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
            emptyLabel.text = "Your subject's list is empty😉"
            emptyLabel.textColor = .gray
            emptyLabel.textAlignment = NSTextAlignment.center
            self.tableView.backgroundView = emptyLabel
            return 0
        } else {
            self.tableView.backgroundView = nil
            return subjects.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subjectListCell", for: indexPath) as! SubjectListTableViewCell
        
        let subject = subjects[indexPath.row]
        let results = StorageManager.shared.getNumberForSubject(subject: subject)
        
        cell.configure(with: subject, mark: results, subjectMaxPoint: subject.maxPoint)
        
        changeCellBackroundColor(indexPath: indexPath, cell: cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44
    }
}
