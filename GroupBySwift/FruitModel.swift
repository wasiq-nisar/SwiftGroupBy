//
//  FruitModel.swift
//  GroupBySwift
//
//  Created by Muhammad Wasiq  on 17/01/2024.
//

import Foundation
import UIKit

struct FruitModel {
    var name: String
    var color: String
    var createdAtDate: Date
    var uuid: UUID?
    
    init(name: String, color: String, createdAtDate: Date, uuid: UUID? = nil) {
        self.name = name
        self.color = color
        self.uuid = uuid
        self.createdAtDate = createdAtDate
    }
}
