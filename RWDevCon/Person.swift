import Foundation
import CoreData

@objc(Person)
class Person: NSManagedObject {
  @NSManaged var first: String
  @NSManaged var last: String
  @NSManaged var bio: String
  @NSManaged var twitter: String
  @NSManaged var identifier: String
  @NSManaged var active: Bool
  @NSManaged var sessions: NSSet

  var fullName: String {
    return "\(first) \(last)"
  }
  
  class func personByIdentifier(_ identifier: String, context: NSManagedObjectContext) -> Person? {
    let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
    fetch.predicate = NSPredicate(format: "identifier = %@", argumentArray: [identifier])

    if let results = try? context.fetch(fetch) {
      if let result = results.first as? Person {
        return result
      }
    }

    return nil
  }

  class func personByIdentifierOrNew(_ identifier: String, context: NSManagedObjectContext) -> Person {
    return personByIdentifier(identifier, context: context) ?? Person(entity: NSEntityDescription.entity(forEntityName: "Person", in: context)!, insertInto: context)
  }
}
