//
//  Task.swift
//  TodoList
//
//  Created by Pavel Maltsev on 24/09/2021.
//

import Foundation
import RealmSwift

class Task: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var isComlete: Bool = false
}
