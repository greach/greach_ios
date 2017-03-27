
import UIKit
import MapKit

enum Theme: Int {
    case greach
    
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
        return .black
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
        return UIColor.black
    }
}

let SelectedThemeKey = "SelectedTheme"
struct ThemeManager {
    
    static func currentTheme() -> Theme {
        
        if let storedTheme = UserDefaults.standard.value(forKey: SelectedThemeKey) as? Int {
            return Theme(rawValue: storedTheme)!
        } else {
            return .greach
        }
    }
    
    static func applyTheme(_ theme: Theme) {
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
