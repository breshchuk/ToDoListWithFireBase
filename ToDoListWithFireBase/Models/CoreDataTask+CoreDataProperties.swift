//
//  CoreDataTask+CoreDataProperties.swift
//  ToDoListWithFireBase
//
//  Created by dimam on 13.04.21.
//
//

import Foundation
import CoreData


extension CoreDataTask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataTask> {
        return NSFetchRequest<CoreDataTask>(entityName: "CoreDataTask")
    }

    @NSManaged public var isCompleted: Bool
    @NSManaged public var title: String?

}

extension CoreDataTask : Identifiable {

}
