//
//  Constants.swift
//  TodoList
//
//  Created by Pavel Maltsev on 22/09/2021.
//

import Foundation

struct K {
    static let tableViewCellName = "ToDoItemCell"
    static let defaultTaskName = "New task created"
    static let userDefaultsKey =  "TodoListArray"

    struct Segue {
        static let openItemsView = "goToItems"
    }
}
