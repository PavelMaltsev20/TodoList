//
//  Constants.swift
//  TodoList
//
//  Created by Pavel Maltsev on 22/09/2021.
//

import Foundation

struct K {
    static let defaultTaskName = "New task created"
    static let defaultCategoryName = "New category created"
    static let userDefaultsKey =  "TodoListArray"
    
    struct Segue{
        static let openTasksView = "openTasksView"
    }

    struct Cells {
        static let categoryCell = "categoriesCell"
        static let taskCell = "tasksCell"
    }
    
    struct CoreData {
        static let categoryPredicate = "parentCategory.title MATCHES %@"
        static let searchPredicate = "title CONTAINS[cd] %@"
    }
}
