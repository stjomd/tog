//
//  Trip+CoreDataProperties.swift
//  
//
//  Created by Artem Zhukov on 17.08.21.
//
//

// import Foundation
// import CoreData
//
// extension Trip {
//
//  @nonobjc public class func fetchRequest() -> NSFetchRequest<Trip> {
//    return NSFetchRequest<Trip>(entityName: "Trip")
//  }
//
//  @NSManaged public var id: Int32
//  @NSManaged public var headsign: String
//  @NSManaged public var shortName: String?
//  @NSManaged public var halts: Set<Halt>
//
//  public static func create(withId id: Int, headsign: String, shortName: String?,
//                            using context: NSManagedObjectContext) {
//    let trip = Trip(context: context)
//    trip.id = Int32(id)
//    trip.headsign = headsign
//    trip.shortName = shortName
//  }
//
// }
//
// MARK: Generated accessors for halts
// extension Trip {
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
