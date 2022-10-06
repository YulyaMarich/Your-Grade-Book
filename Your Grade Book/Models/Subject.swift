//
//  Subject.swift
//  Your Grade Book
//
//  Created by mac on 05.01.2022.
//

import RealmSwift
class Subject: Object {
    @Persisted var name: String
    @Persisted var maxPoint: Int
    @Persisted var tasks: List<Task>
}
