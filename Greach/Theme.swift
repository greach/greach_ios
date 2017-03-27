
import UIKit
import MapKit

enum Theme: Int {
    case Greach
    
    var conferenceWebsite : String {
        return  "http://greachconf.com"
    }
    
    var conferenceTwitterHandle : String {
        return "@greachconf"
    }
    
    var conferenceVideosUrl : String {
        return "https://www.youtube.com/user/TheGreachChannel"
    }
    
    var mainColor: UIColor {
        return UIColor(red: 147.0/255.0, green: 172.0/255.0, blue: 35.0/255.0, alpha: 1.0)
    }
    
    var barStyle: UIBarStyle {
        return .Black
    }
    
    var venueLatitude : CLLocationDegrees {
        return 40.43188
    }
    
    var venueLongitude : CLLocationDegrees {
        return -3.698145
    }
    
    var venueName : String {
        return "Teatros Luchana"
    }
    
    var venueAddress : String {
        return "Calle de Luchana, 38, 28010 Madrid"
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
            return .Greach
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