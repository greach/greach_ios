//
//  MoreTableViewController.swift
//  GreachConf
//
//  Created by Softamo S.L.U on 05/04/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import Foundation
import Foundation
import UIKit

class MoreTableViewController : UITableViewController {
    
    var crew: [Crew] = []
    
    var headers: [String] = [
        NSLocalizedString("Contact Us", comment: "Table View header title in MoreTVC"),
        NSLocalizedString("Crew", comment: "Table View header title in MoreTVC")
    ]
    
    var contactUs: [String] = [
        ThemeManager.currentTheme().conferenceWebsite,
        ThemeManager.currentTheme().conferenceTwitterHandle,
        ThemeManager.currentTheme().conferenceVideosUrl
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCrew()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(indexPath.section == 0 && indexPath.row == 1) {
            openTwitterHandle(contactUs[indexPath.row])
            
        } else if(indexPath.section == 0) {
             openUrl(contactUs[indexPath.row])
            
        } else if(indexPath.section == 1) {
            
            let c = crew[indexPath.row]
            if let urlStr = c.twitter {
                openTwitterHandle(urlStr)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {        
        return headers[section]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return headers.count;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0) {
            return contactUs.count;
            
        } else if(section == 1) {
            return crew.count;
        }
        return 0;
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cellIdentifier = "MoreCellIdentifier"
        if(indexPath.section == 1) {
            cellIdentifier = "MoreCrewCellIdentifier"
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if(indexPath.section == 0) {
            
            if(indexPath.row == 2) {
                cell?.textLabel?.text = NSLocalizedString("Videos", comment: "Show in the more TVC")
            } else {
                cell?.textLabel?.text = contactUs[indexPath.row]
            }
            
        } else if(indexPath.section == 1) {

            let c = crew[indexPath.row]
            cell?.textLabel?.text = c.name
            
            if(c.title != nil && c.company != nil) {
                cell?.detailTextLabel?.text = "\(c.title as String) • \(c.company as String)"
            } else if(c.company != nil) {
                cell?.detailTextLabel?.text = "\(c.company)"
            } else if(c.title != nil) {
                cell?.detailTextLabel?.text = "\(c.title)"
            }
            
            if(c.imageUrl != nil) {
                if let url = URL(string: c.imageUrl) {
                    DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
                        if let data = try? Data(contentsOf: url) {
                            DispatchQueue.main.async(execute: {
                                cell?.imageView?.image = UIImage(data: data)
                                cell?.setNeedsLayout()
                            });
                        }
                    }
                }
            }
        
        }
        return cell!
    }

    func loadCrew() -> Void {
        let plistUrl = Bundle.main.url(forResource: "crew", withExtension: "plist")
        if let plistData = try? Data(contentsOf: plistUrl!) {
            var formt = PropertyListSerialization.PropertyListFormat.xml
            do {
                let crewPlist = try PropertyListSerialization.propertyList(from: plistData, options: PropertyListSerialization.MutabilityOptions(), format: &formt)
                for plistEntry in crewPlist as! [[String: String]] {
                    var c = Crew(name: nil,
                                 imageUrl: nil,
                                 title: nil,
                                 twitter: nil,
                                 company: nil)
                    
                    if let name = plistEntry["name"] {
                        c.name = name
                    }
                    
                    if let imageUrl = plistEntry["image_url"] {
                        c.imageUrl = imageUrl
                        
                    }
                    if let title = plistEntry["title"] {
                        c.title = title
                    }
                    if let twitter = plistEntry["twitter"] {
                        c.twitter = twitter
                    }
                    if let company = plistEntry["company"] {
                        c.company = company
                    }
                    crew.append(c)
                }
                
            } catch {
                print(error)
            }
        }
    }
    
    func openTwitterHandle(_ twitter: String) {
        if(twitter.hasPrefix("@")) {
            if let url = URL(string:"https://twitter.com/\(((twitter as NSString).substring(from: 1)))") {
                UIApplication.shared.openURL(url)
            }
        } else {
            if let url = URL(string:"https://twitter.com/\(twitter)") {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func openUrl(_ urlStr: String) {
       if let url = URL(string:urlStr) {
                UIApplication.shared.openURL(url)
        }
    }
}
