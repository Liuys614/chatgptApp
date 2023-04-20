//
//  UtteranceEntity+CoreDataProperties.swift
//  chatgptApp
//
//  Created by Louis Liu on 2023/4/17.
//
//

import Foundation
import CoreData


extension UtteranceEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UtteranceEntity> {
        return NSFetchRequest<UtteranceEntity>(entityName: "UtteranceEntity")
    }

    @NSManaged public var content: String?
    @NSManaged public var role: String?
    @NSManaged public var dialogue: DialoguesEntity?

}

extension UtteranceEntity : Identifiable {

}
