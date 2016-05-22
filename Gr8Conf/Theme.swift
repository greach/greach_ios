
import UIKit
import MapKit

enum Theme: Int {
    case GR8ConfEU
    
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
        return .Black
    }
    
    var venueLatitude : CLLocationDegrees {
        return 55.659635
    }
    
    var venueLongitude : CLLocationDegrees {
        return 40.4319361
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
        return UIColor.blackColor()
    }
}

let SelectedThemeKey = "SelectedTheme"
struct ThemeManager {
    
    static func currentTheme() -> Theme {
        if let storedTheme = NSUserDefaults.standardUserDefaults().valueForKey(SelectedThemeKey)?.integerValue {
            return Theme(rawValue: storedTheme)!
        } else {
            return .GR8ConfEU
        }
    }
    
    static func applyTheme(theme: Theme) {
        NSUserDefaults.standardUserDefaults().setValue(theme.rawValue, forKey: SelectedThemeKey)
        NSUserDefaults.standardUserDefaults().synchronize()
        
        let sharedApplication = UIApplication.sharedApplication()
        sharedApplication.delegate?.window??.tintColor = theme.mainColor
        
        UINavigationBar.appearance().barTintColor = theme.navigationBarBackgroundColor
        UITabBar.appearance().backgroundColor = theme.tabBarBackgroundColor
        UITabBar.appearance().barStyle = theme.barStyle
        
        UITableViewHeaderFooterView.appearance().contentView.backgroundColor = theme.tabBarBackgroundColor
    }
}