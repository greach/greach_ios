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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
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
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {        
        return headers[section]
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return headers.count;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0) {
            return contactUs.count;
            
        } else if(section == 1) {
            return crew.count;
        }
        return 0;
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cellIdentifier = "MoreCellIdentifier"
        if(indexPath.section == 1) {
            cellIdentifier = "MoreCrewCellIdentifier"
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        
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
                cell?.detailTextLabel?.text = "\(c.title) • \(c.company)"
            } else if(c.company != nil) {
                cell?.detailTextLabel?.text = "\(c.company)"
            } else if(c.title != nil) {
                cell?.detailTextLabel?.text = "\(c.title)"
            }
            
            if(c.imageUrl != nil) {
                if let url = NSURL(string: c.imageUrl) {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                        if let data = NSData(contentsOfURL: url) {
                            dispatch_async(dispatch_get_main_queue(), {
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
        let plistUrl = NSBundle.mainBundle().URLForResource("crew", withExtension: "plist")
        if let plistData = NSData(contentsOfURL: plistUrl!) {
            var formt = NSPropertyListFormat.XMLFormat_v1_0
            do {
                let crewPlist = try NSPropertyListSerialization.propertyListWithData(plistData, options: .Immutable, format: &formt)
                for plistEntry in crewPlist as! NSArray {
                    var c = Crew(name: nil,
                                 imageUrl: nil,
                                 title: nil,
                                 twitter: nil,
                                 company: nil)
                    if let name = plistEntry["name"] {
                        if(name != nil) {
                            c.name = name! as! String
                        }
                    }
                    
                    
                    if let imageUrl = plistEntry["image_url"] {
                        if(imageUrl != nil) {
                            c.imageUrl = imageUrl! as! String
                        }
                    }
                    if let title = plistEntry["title"] {
                        if(title != nil) {
                            c.title = title! as! String
                        }
                    }
                    if let twitter = plistEntry["twitter"] {
                        if(twitter != nil) {
                            c.twitter = twitter! as! String
                        }
                    }
                    if let company = plistEntry["company"] {
                        if(company != nil) {
                            c.company = company! as! String
                        }
                    }
                    crew.append(c)
                }
                
            } catch {
                print(error)
            }
        }
    }
    
    func openTwitterHandle(twitter: String) {
        if(twitter.hasPrefix("@")) {
            if let url = NSURL(string:"https://twitter.com/\(((twitter as NSString).substringFromIndex(1)))") {
                UIApplication.sharedApplication().openURL(url)
            }
        } else {
            if let url = NSURL(string:"https://twitter.com/\(twitter)") {
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }
    
    func openUrl(urlStr: String) {
       if let url = NSURL(string:urlStr) {
                UIApplication.sharedApplication().openURL(url)
        }
    }
}
