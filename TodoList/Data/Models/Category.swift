//
//  Category.swift
//  TodoList
//
//  Created by Pavel Maltsev on 24/09/2021.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var title: String = ""
    let tasks = List<Task>()
}
