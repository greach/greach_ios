import Foundation
import CoreData

private let formatter = DateFormatter()

@objc(Session)
class Session: NSManagedObject {
  @NSManaged var identifier: String
  @NSManaged var active: Bool
  @NSManaged var title: String
  @NSManaged var date: NSDate
  @NSManaged var duration: Int32
  @NSManaged var column: Int32
  @NSManaged var sessionNumber: String
  @NSManaged var sessionDescription: String
  @NSManaged var room: Room
  @NSManaged var track: Track
  @NSManaged var presenters: NSOrderedSet

  var fullTitle: String {
    return (sessionNumber != "" ? "\(sessionNumber): " : "") + title
  }

  var startDateDayOfWeek: String {
    return formatDate("EEEE")
  }

  var startDateTimeShortString: String {
    return formatDate("EEE h:mm a")
  }

  var startDateTimeString: String {
    return formatDate("EEEE h:mm a")
  }

  var startTimeString: String {
    return formatDate("h:mm a")
  }

  var isFavorite: Bool {
    get {
        //TODO
//      let favorites = Config.favoriteSessions()
      //return favorites.values.array.indexOf(identifier) != nil
        return false
    }
    set {
      if newValue {
        Config.registerFavorite(self)
      } else {
        Config.unregisterFavorite(self)
      }
    }
  }

  func formatDate(_ format: String) -> String {
    formatter.dateFormat = format
    formatter.timeZone = NSTimeZone(name: Config.timeZoneName()) as! TimeZone
    return formatter.string(from: date as Date)
  }

  class func sessionCount(context: NSManagedObjectContext) -> Int {
    let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Session")
    fetch.includesSubentities = false
    do {
      let countNumber = try context.count(for: fetch)
      return countNumber
    } catch _ {
        
    }
    return 0
  }

  class func sessionByIdentifier(identifier: String, context: NSManagedObjectContext) -> Session? {
    let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Session")
    fetch.predicate = NSPredicate(format: "identifier = %@", argumentArray: [identifier])

    if let results = try? context.fetch(fetch) {
      if let result = results.first as? Session {
        return result
      }
    }

    return nil
  }

  class func sessionByIdentifierOrNew(identifier: String, context: NSManagedObjectContext) -> Session {
    return sessionByIdentifier(identifier: identifier, context: context) ?? Session(entity: NSEntityDescription.entity(forEntityName: "Session", in: context)!, insertInto: context)
  }

  class func sessionsForPredicate(predicate: NSPredicate?, context: NSManagedObjectContext) -> [Session] {
    let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Session")
    fetch.predicate = predicate
    fetch.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true), NSSortDescriptor(key: "track.trackId", ascending: true)]

    if let results = (try? context.fetch(fetch)) as? [Session] {
      return results
    }

    return []
  }

  class func allSessionsInContext(context: NSManagedObjectContext) -> [Session] {
    let predicate = NSPredicate(format: "active = %@", argumentArray: [true])
    return sessionsForPredicate(predicate: predicate, context: context)
  }

  class func sessionsForTrack(trackId: Int, context: NSManagedObjectContext) -> [Session] {
    let predicate = NSPredicate(format: "active = %@ AND track.trackId = %@", argumentArray: [true, trackId])
    return sessionsForPredicate(predicate: predicate, context: context)
  }

  class func nextFavoriteSession(context: NSManagedObjectContext) -> Session? {
    /*
    let identifers = Config.favoriteSessions().values.array
    if identifers.count > 0 {
      let fetch = NSFetchRequest(entityName: "Session")
      let sessionPredicate = NSPredicate(format: "identifier IN %@", argumentArray: [identifers])
      let datePredicate = NSPredicate(format: "date >= %@", argumentArray: [NSDate()])
      fetch.predicate = NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: [sessionPredicate, datePredicate])
      fetch.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
      if let results = try? context.executeFetchRequest(fetch) {
        if results.count > 0 {
          if let session = results.first as? Session {
            return session
          }
        }
      }
    }
*/
    return nil
  }

}
