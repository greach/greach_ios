import Foundation
import CoreData

@objc(Track)
class Track: NSManagedObject {
  @NSManaged var trackId: Int32
  @NSManaged var name: String
  @NSManaged var sessions: NSSet

  class func trackByTrackId(_ trackId: Int, context: NSManagedObjectContext) -> Track? {
    let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Track")
    fetch.predicate = NSPredicate(format: "trackId = %@", argumentArray: [trackId])

    if let results = try? context.fetch(fetch) {
      if let result = results.first as? Track {
        return result
      }
    }

    return nil
  }

  class func trackByTrackIdOrNew(_ trackId: Int, context: NSManagedObjectContext) -> Track {
    return trackByTrackId(trackId, context: context) ?? Track(entity: NSEntityDescription.entity(forEntityName: "Track", in: context)!, insertInto: context)
  }
}
