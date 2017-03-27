import Foundation
import UIKit
import MapKit

class VenueViewController : UIViewController {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let theme : Theme = ThemeManager.currentTheme()

        let venueCoordinate : CLLocationCoordinate2D = CLLocationCoordinate2DMake(theme.venueLatitude, theme.venueLongitude)

        
        let regionRadius :CLLocationDistance = 1000
        let region : MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(venueCoordinate, regionRadius, regionRadius)
        
        mapView.region = region
        
        let annotation : MKAnnotation = VenuePin(coordinate: venueCoordinate, title:theme.venueName, subtitle: theme.venueAddress)
        mapView.addAnnotation(annotation)

    

    }

    @IBAction func openInMapsTapped(_ sender: UIBarButtonItem) {
        
        let theme : Theme = ThemeManager.currentTheme()
        
        let escapedAddress : String = theme.venueAddress.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let urlString : String = "http://maps.apple.com/maps?q=\(escapedAddress)&ll=\(theme.venueLatitude),\(theme.venueLongitude)"
        let url : URL = URL(string:urlString)!
        UIApplication.shared.openURL(url)
    }
}
