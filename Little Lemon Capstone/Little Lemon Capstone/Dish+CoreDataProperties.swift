//
//  Dish+CoreDataProperties.swift
//  Little Lemon Capstone
//
//  Created by Logan Buzzard on 9/19/24.
//
//

import Foundation
import CoreData


extension Dish {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dish> {
        return NSFetchRequest<Dish>(entityName: "Dish")
    }

    @NSManaged public var title: String?
    @NSManaged public var image: String?
    @NSManaged public var price: String?
    @NSManaged public var desc: String?
    @NSManaged public var id: Int16
    @NSManaged public var category: String?

}

extension Dish : Identifiable {

}
