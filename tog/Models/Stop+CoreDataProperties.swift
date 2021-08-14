//
//  Stop+CoreDataProperties.swift
//  
//
//  Created by Artem Zhukov on 14.08.21.
//
//

import Foundation
import CoreData

extension Stop {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Stop> {
    return NSFetchRequest<Stop>(entityName: "Stop")
  }
  
  @NSManaged public var id: Int32
  @NSManaged public var name: String
  @NSManaged public var latitude: Double
  @NSManaged public var longitude: Double
  
  public static func createWith(id: Int, name: String, latitude: Double, longitude: Double, using context: NSManagedObjectContext) {
    let stop = Stop(context: context)
    stop.id = Int32(id)
    stop.name = name
    stop.latitude = latitude
    stop.longitude = longitude
  }
  
}
