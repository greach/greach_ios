import Foundation

let SessionDataUpdatedNotification = "com.razeware.rwdevcon.notification.sessionDataUpdated"

class Config {
    class func timeZoneName() -> String {
        return "Europe/Warsaw"
    }
    
  class func applicationDocumentsDirectory() -> URL {
    let fileManager = FileManager.default

    let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask) 
    return urls[0]
  }
  
  class func userDefaults() -> UserDefaults {
    return UserDefaults.standard
  }

  class func favoriteSessions() -> [String: String] {
    if let favs = userDefaults().dictionary(forKey: "favoriteSessions") as? [String: String] {
      return favs
    }
    return [:]
  }

  class func registerFavorite(_ session: Session) {
    var favs = favoriteSessions()
    favs[session.startDateTimeString] = session.identifier

    userDefaults().setValue((favs as NSDictionary), forKey: "favoriteSessions")
    userDefaults().synchronize()
  }

  class func unregisterFavorite(_ session: Session) {
    var favs = favoriteSessions()
    favs[session.startDateTimeString] = nil

    userDefaults().setValue((favs as NSDictionary), forKey: "favoriteSessions")
    userDefaults().synchronize()
  }

}
