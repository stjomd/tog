//
//  Stop+CoreDataProperties.swift
//  
//
//  Created by Artem Zhukov on 14.08.21.
//
//

// import Foundation
// import CoreData
//
// extension Stop {
//
//  @nonobjc public class func fetchRequest() -> NSFetchRequest<Stop> {
//    return NSFetchRequest<Stop>(entityName: "Stop")
//  }
//
//  @NSManaged public var id: Int32
//  @NSManaged public var latitude: Double
//  @NSManaged public var longitude: Double
//  @NSManaged public var name: String
//  @NSManaged public var halts: Set<Halt>
//
//  public static func create(withId id: Int, name: String, latitude: Double, longitude: Double,
//                            using context: NSManagedObjectContext) {
//    let stop = Stop(context: context)
//    stop.id = Int32(id)
//    stop.name = name
//    stop.latitude = latitude
//    stop.longitude = longitude
//  }
//
// }
//
// MARK: Generated accessors for halts
// extension Stop {
//
//  @objc(addHaltsObject:)
//  @NSManaged public func addToHalts(_ value: Halt)
//
//  @objc(removeHaltsObject:)
//  @NSManaged public func removeFromHalts(_ value: Halt)
//
//  @objc(addHalts:)
//  @NSManaged public func addToHalts(_ values: NSSet)
//
//  @objc(removeHalts:)
//  @NSManaged public func removeFromHalts(_ values: NSSet)
//
// }
