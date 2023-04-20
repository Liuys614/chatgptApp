//
//  DialoguesEntity+CoreDataProperties.swift
//  chatgptApp
//
//  Created by Louis Liu on 2023/4/17.
//
//

import Foundation
import CoreData


extension DialoguesEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DialoguesEntity> {
        return NSFetchRequest<DialoguesEntity>(entityName: "DialoguesEntity")
    }

    @NSManaged public var title: String?
    @NSManaged public var uid: UUID?
    @NSManaged public var utterances: NSSet?

}

// MARK: Generated accessors for utterances
extension DialoguesEntity {

    @objc(addUtterancesObject:)
    @NSManaged public func addToUtterances(_ value: UtteranceEntity)

    @objc(removeUtterancesObject:)
    @NSManaged public func removeFromUtterances(_ value: UtteranceEntity)

    @objc(addUtterances:)
    @NSManaged public func addToUtterances(_ values: NSSet)

    @objc(removeUtterances:)
    @NSManaged public func removeFromUtterances(_ values: NSSet)

}

extension DialoguesEntity : Identifiable {

}
