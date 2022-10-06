//
//  Task.swift
//  Your Grade Book
//
//  Created by mac on 08.01.2022.
//
import RealmSwift

class Task: Object {
    @Persisted var name: String
    @Persisted var maxPoint: Int
    @Persisted var systemType = System.accumulativeSystem
    @Persisted var coefficient: Double
    @Persisted var points: List<CurrentTask>
    
}
