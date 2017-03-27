import Foundation
import UIKit
import CoreData

typealias TableCellConfigurationBlock = (_ cell: ScheduleTableViewCell, _ indexPath: IndexPath, _ session: Session) -> ()

class ScheduleDataSource: NSObject {
  var coreDataStack: CoreDataStack!

  var startDate: Date?
  var endDate: Date?
  var favoritesOnly = false

  let hourHeaderHeight: CGFloat = 40
  let numberOfTracksInSchedule = 3
  let numberOfHoursInSchedule = 11
  let trackHeaderWidth: CGFloat = 120
  let widthPerHour: CGFloat = 180
  let firstHour = 8
  
  var tableCellConfigurationBlock: TableCellConfigurationBlock?

  var allSessions: [Session] {
    let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Session")
    fetch.predicate = NSPredicate(format: "active = %@", argumentArray: [true])
    fetch.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true), NSSortDescriptor(key: "track.trackId", ascending: true)]

    if let results = (try? self.coreDataStack.context.fetch(fetch)) as? [Session] {
      return results
    }

    return []
  }

  var distinctTimes: [String] {
    var times = [String]()

    if favoritesOnly {
      for session in self.allSessions {
        let last = times.last
        let thisDayOfWeek = session.startDateDayOfWeek

        if (last == nil) || (last != nil && last! != thisDayOfWeek) {
          times.append(thisDayOfWeek)
        }
      }
    } else {
      for session in self.allSessions {
        let last = times.last
        if (last == nil) || (last != nil && last! != session.startDateTimeString) {
          times.append(session.startDateTimeString)
        }
      }
    }

    return times
  }


  internal func sessionForIndexPath(_ indexPath: IndexPath) -> Session {
    let sessions = arrayOfSessionsForSection(indexPath.section)
    return sessions[indexPath.row]
  }
  
  // MARK: Private Utilities
  
  fileprivate func arrayOfSessionsForSection(_ section: Int) -> [Session] {
    if favoritesOnly {
      let weekday = distinctTimes[section]
      return allSessions.filter({ (session) -> Bool in
        return session.startDateTimeString.hasPrefix(weekday)
      })
    } else {
      let startTimeString = distinctTimes[section]
      return allSessions.filter({ (session) -> Bool in
        return session.startDateTimeString == startTimeString
      })
    }
  }
  
  fileprivate func groupDictionaryForSection(_ section: Int) -> NSDictionary {
    return ["Header": distinctTimes[section]]
  }
  
}

extension ScheduleDataSource: UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    return distinctTimes.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return arrayOfSessionsForSection(section).count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTableViewCell") as! ScheduleTableViewCell
    let session = sessionForIndexPath(indexPath)
    if let configureBlock = tableCellConfigurationBlock {
      configureBlock(cell, indexPath, session)
    }
    return cell
  }

}
