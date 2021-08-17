//
//  Halt+CoreDataProperties.swift
//  
//
//  Created by Artem Zhukov on 17.08.21.
//
//

import Foundation
import CoreData

extension Halt {

  @nonobjc public class func fetchRequest() -> NSFetchRequest<Halt> {
    return NSFetchRequest<Halt>(entityName: "Halt")
  }

  @NSManaged public var arrival: Date
  @NSManaged public var departure: Date
  @NSManaged public var stopSequence: Int32
  @NSManaged public var stop: Stop
  @NSManaged public var trip: Trip

  // swiftlint:disable function_parameter_count
  public static func create(at stop: Stop, during trip: Trip, arrival: Date, departure: Date, sequence: Int32,
                            using context: NSManagedObjectContext) {
    let halt = Halt(context: context)
    halt.stop = stop
    halt.trip = trip
    halt.arrival = arrival
    halt.departure = departure
    halt.stopSequence = sequence
  }

}
