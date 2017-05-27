
import UIKit
import MapKit

enum Theme: Int {
    case GR8ConfEU
    
    var botconfUrl: URL {
        return URL(string: "https://botconf.s3.amazonaws.com/gr8confeu/gr8confeu-2017.plist")!
    }
    
    var conferenceWebsite : String {
        return  "http://gr8conf.eu"
    }
    
    var conferenceTwitterHandle : String {
        return "@gr8conf"
    }
    
    var conferenceVideosUrl : String {
        return "https://www.youtube.com/channel/UCJXNOMywewNmau4hzAy4LjA"
    }
    
    var mainColor: UIColor {
        return UIColor(red: 217.0/255.0, green: 109.0/255.0, blue: 38.0/255.0, alpha: 1.0)
    }
    
    var barStyle: UIBarStyle {
        return .black
    }
    
    var venueLatitude : CLLocationDegrees {
        return 55.659635
    }
    
    var venueLongitude : CLLocationDegrees {
        return 12.590958        
    }
    
    var venueName : String {
        return "IT University of Copenhagen"
    }
    
    var venueAddress : String {    
        return "Rued Langgards Vej 7, DK-2300 Copenhagen"
    }
    
    
    var tabBarBackgroundColor: UIColor {
        return UIColor(red: 37.0/255.0, green: 37.0/255.0, blue: 37.0/255.0, alpha: 1.0)
    }
    
    var navigationBarBackgroundColor : UIColor {
        return UIColor.black
    }
}

let SelectedThemeKey = "SelectedTheme"
struct ThemeManager {
    
    static func currentTheme() -> Theme {
        if let storedTheme = (UserDefaults.standard.value(forKey: SelectedThemeKey) as AnyObject).integerValue {
            return Theme(rawValue: storedTheme)!
        } else {
            return .GR8ConfEU
        }
    }
    
    static func applyTheme(theme: Theme) {
        UserDefaults.standard.setValue(theme.rawValue, forKey: SelectedThemeKey)
        UserDefaults.standard.synchronize()
        
        let sharedApplication = UIApplication.shared
        sharedApplication.delegate?.window??.tintColor = theme.mainColor
        
        UINavigationBar.appearance().barTintColor = theme.navigationBarBackgroundColor
        UITabBar.appearance().backgroundColor = theme.tabBarBackgroundColor
        UITabBar.appearance().barStyle = theme.barStyle
        
        UITableViewHeaderFooterView.appearance().contentView.backgroundColor = theme.tabBarBackgroundColor
    }
}
