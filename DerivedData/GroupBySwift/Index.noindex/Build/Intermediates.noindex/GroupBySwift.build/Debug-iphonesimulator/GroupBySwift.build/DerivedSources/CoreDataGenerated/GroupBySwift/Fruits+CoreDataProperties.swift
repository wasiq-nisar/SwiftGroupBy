//
//  Fruits+CoreDataProperties.swift
//  
//
//  Created by Muhammad Wasiq  on 17/01/2024.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Fruits {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Fruits> {
        return NSFetchRequest<Fruits>(entityName: "Fruits")
    }

    @NSManaged public var fruitColor: String?
    @NSManaged public var fruitName: String?

}

extension Fruits : Identifiable {

}
