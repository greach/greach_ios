//
//  SponsorsTableViewController.swift
//  GreachConf
//
//  Created by Softamo S.L.U on 22/05/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import UIKit

class SponsorsTableViewController: UITableViewController {
    
    var sponsors: [Sponsor] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        loadSponsors()
    }
    
    func headerTitles() -> [String] {
        let mutableSet : NSMutableSet = NSMutableSet()
        
        for sponsor in sponsors {
            mutableSet.addObject(sponsor.kind)
        }
        
        
        let titles = mutableSet.allObjects as! [String]
        
        return titles.sort { (let a, let b) -> Bool in
            let aVal = orderByKind(a)
            let bVal = orderByKind(b)
            return aVal > bVal
        }
    }
    
    func sponsorsByKind(kind: String) -> [Sponsor] {
        let mutableSet : NSMutableSet = NSMutableSet()
        
        for sponsor in sponsors {
            if(sponsor.kind == kind) {
                mutableSet.addObject(sponsor)
            }
        }
        
        return mutableSet.allObjects as! [Sponsor]
    }
    
    
    func orderByKind(kind: String) -> Int {
        
        if(kind == "Platinum sponsor") {
            return 6
            
        } else if(kind == "Gold sponsor") {
            return 5
            
        } else if(kind == "Silver sponsor") {
            return 4
            
        } else if(kind == "Partners") {
            return 3
            
        } else if(kind == "Media sponsor") {
            return 2
            
        } else if(kind == "Organizers") {
            return 1
        }
        return 0
    }
    
    
    
    
    func loadSponsors() {
        
        let plistUrl = NSBundle.mainBundle().URLForResource("sponsors", withExtension: "plist")
        if let plistData = NSData(contentsOfURL: plistUrl!) {
            var formt = NSPropertyListFormat.XMLFormat_v1_0
            do {
                let sponsorsPlist = try NSPropertyListSerialization.propertyListWithData(plistData, options: .Immutable, format: &formt)
                for plistEntry in sponsorsPlist as! NSArray {
                    let s = Sponsor(kind: nil,
                                    url: nil,
                                    imageUrl: nil)
                    if let kind = plistEntry["kind"] {
                        if(kind != nil) {
                            s.kind = kind! as! String
                        }
                    }
                    if let imageUrl = plistEntry["image_url"] {
                        if(imageUrl != nil) {
                            s.imageUrl = imageUrl! as! String
                        }
                    }
                    if let url = plistEntry["url"] {
                        if(url != nil) {
                            s.url = url! as! String
                        }
                    }
                    sponsors.append(s)
                }
                
            } catch {
                print(error)
            }
        }
        
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return headerTitles().count;
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let kind = headerTitles()[section]
        return sponsorsByKind(kind).count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SponsorCellIdentifier", forIndexPath: indexPath) as! SponsorTableViewCell

        let kind = headerTitles()[indexPath.section]
        let sponsor = sponsorsByKind(kind)[indexPath.row]
        
        if(sponsor.imageUrl != nil) {
            if let url = NSURL(string: sponsor.imageUrl) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    if let data = NSData(contentsOfURL: url) {
                        dispatch_async(dispatch_get_main_queue(), {
                            cell.sponsorImageView?.image = UIImage(data: data)
                            cell.setNeedsLayout()
                        });
                    }
                }
            }
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150;
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
           return headerTitles()[section]
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let kind = headerTitles()[indexPath.section]
        let sponsor = sponsorsByKind(kind)[indexPath.row]
        
        if let urlStr = sponsor.url {
            openUrl(urlStr)
        }
    
    }
    
    func openUrl(urlStr: String) {
        if let url = NSURL(string:urlStr) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
}
