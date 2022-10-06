//
//  StorageManager.swift
//  Your Grade Book
//
//  Created by Julia on 03.02.2022.
//

import RealmSwift
import Combine

class StorageManager {
    static let shared = StorageManager()
    
    let realm = try! Realm()
    
    //MARK: - Save functions
    
    func save(subject: Subject) {
        try! self.realm.write {
            self.realm.add(subject)
        }
    }
    
    func save(task: Task, into subject: Subject) {
        write {
            subject.tasks.append(task)
        }
    }
    
    func save(currentTask: CurrentTask, into task: Task) {
        write {
            task.points.append(currentTask)
        }
    }
    
    //MARK: - Change functions
    
    func changeSubject(subject: Subject, name: String, maxPoint: Int) {
        write {
            subject.name = name
            subject.maxPoint = maxPoint
        }
    }
    
    func changeCurrentTask(currentTask: Task,  name: String, maxPoint: Int, systemType: System, coefficient: Double?) {
        write {
            currentTask.name = name
            currentTask.maxPoint = maxPoint
            currentTask.systemType = systemType
            currentTask.coefficient = coefficient ?? 1
        }
    }
    
    func changeCurrentTask(currentTask: CurrentTask, with number: Double) {
        write {
            currentTask.point = number
        }
    }
    
    //MARK: - Delete functions
    
    func deleteSubject(subject: Subject) {
        write {
            for task in subject.tasks {
                for point in task.points {
                    realm.delete(point)
                }
            }
            realm.delete(subject.tasks)
            realm.delete(subject)
        }
    }
    
    func deleteTask(task: Task) {
        write {
            realm.delete(task.points)
            realm.delete(task)
        }
    }
    
    func deletePoint(point: CurrentTask) {
        write {
            realm.delete(point)
        }
    }
    
    //MARK: - Mark calculation functions
    
    func getNumberForSubject(subject: Subject) -> Double {
        var results = 0.0
        
        for task in subject.tasks {
            results += getNumberForTask(task: task)
        }
        return results
    }
    
    func getNumberForTask(task: Task) -> Double {
        var results = 0.0
        
        if task.systemType == .accumulativeSystem {
            results += getPontsInTask(task: task)
        } else {
            results = (getPontsInTask(task: task) / Double(task.points.count)) * task.coefficient
        }
        return results
    }
    
    private func getPontsInTask(task: Task) -> Double {
        var result: Double = 0
        for point in task.points {
            result += point.point
        }
        return result
    }
    
    // MARK: - Realm function
    private func write(_ completion: () -> Void) {
        do {
            try realm.write {
                completion()
            }
        } catch let error {
            print(error)
        }
    }
}
