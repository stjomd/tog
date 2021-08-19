//
//  Halt+CoreDataProperties.swift
//  
//
//  Created by Artem Zhukov on 17.08.21.
//
//

// import Foundation
// import CoreData
//
// extension Halt {
//
//  @nonobjc public class func fetchRequest() -> NSFetchRequest<Halt> {
//    return NSFetchRequest<Halt>(entityName: "Halt")
//  }
//
//  // Arrival and departures are stored as strings but are accessed via Time
//  @NSManaged private var arrival: String
//  @NSManaged private var departure: String
//  @NSManaged public var stopSequence: Int32
//  @NSManaged public var stop: Stop
//  @NSManaged public var trip: Trip
//
//  // Time typed getters
//  public var arrivalTime: Time {
//    guard let time = Time(arrival) else {
//      fatalError("Inconsistent arrival time")
//    }
//    return time
//  }
//  public var departureTime: Time {
//    guard let time = Time(departure) else {
//      fatalError("Inconsistent departure time")
//    }
//    return time
//  }
//
//  // @swiftlint:@disable @function_parameter_count
//  public static func create(at stop: Stop, during trip: Trip, arrival: Time, departure: Time, sequence: Int,
//                            using context: NSManagedObjectContext) {
//    let halt = Halt(context: context)
//    halt.stop = stop
//    halt.trip = trip
//    halt.arrival = arrival.description
//    halt.departure = departure.description
//    halt.stopSequence = Int32(sequence)
//  }
//
// }
