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
            mutableSet.add(sponsor.kind)
        }
        
        
        let titles = mutableSet.allObjects as! [String]
        
        return titles.sorted { ( a, b) -> Bool in
            let aVal = orderByKind(kind: a)
            let bVal = orderByKind(kind: b)
            return aVal > bVal
        }
    }
    
    func sponsorsByKind(kind: String) -> [Sponsor] {
        let mutableSet : NSMutableSet = NSMutableSet()
        
        for sponsor in sponsors {
            if(sponsor.kind == kind) {
                mutableSet.add(sponsor)
            }
        }
        
        return mutableSet.allObjects as! [Sponsor]
    }
    
    
    func orderByKind(kind: String) -> Int {
        if(kind == "Diamond") {
            return 9
    
        } else if(kind == "Platinum") {
            return 8
            
        } else if(kind == "Platinum sponsor") {
            return 7
            
        } else if(kind == "Gold sponsor" || kind == "Gold") {
            return 6
            
        } else if(kind == "Silver sponsor") {
            return 5
            
        } else if(kind == "Bronze") {
            return 4
            
        } else if(kind == "Partners" || kind == "Collaborators") {
            return 3
            
        } else if(kind == "Media sponsor") {
            return 2
            
        } else if(kind == "Organizers") {
            return 1
        }
        return 0
    }
    
    
    
    
    func loadSponsors() {
        
        let plistUrl = Bundle.main.url(forResource: "sponsors", withExtension: "plist")
        if let plistData = NSData(contentsOf: plistUrl!) {            
            do {
                let sponsorsPlist = try! PropertyListSerialization.propertyList(from:plistData as Data, options: [], format: nil)
                
//                let sponsorsPlist = try PropertyListSerialization.propertyListWithData(plistData, options: .Immutable, format: &formt)
                for plistEntry in sponsorsPlist as! NSArray {
                    let s = Sponsor(kind: nil,
                                    url: nil,
                                    imageUrl: nil)
                    if let kind = (plistEntry as! NSDictionary)["kind"] {
                        s.kind = kind as! String
                        
                    }
                    if let imageUrl = (plistEntry as! NSDictionary)["image_url"] {
                        s.imageUrl = imageUrl as! String
                    }
                    if let url = (plistEntry as! NSDictionary)["url"] {
                        s.url = url as! String
                    }
                    sponsors.append(s)
                }
                
            } catch {
                print(error)
            }
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return headerTitles().count;
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let kind = headerTitles()[section]
        return sponsorsByKind(kind: kind).count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SponsorCellIdentifier", for: indexPath) as! SponsorTableViewCell

        let kind = headerTitles()[indexPath.section]
        let sponsor = sponsorsByKind(kind: kind)[indexPath.row]
        
        if(sponsor.imageUrl != nil) {
            if let url = NSURL(string: sponsor.imageUrl) {
                DispatchQueue.global(qos: .userInitiated).async {
                    if let data = NSData(contentsOf: url as URL) {
                        DispatchQueue.main.async {
                            cell.sponsorImageView?.image = UIImage(data: data as Data)
                            cell.setNeedsLayout()
                        }
                    }
                }
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150;
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
           return headerTitles()[section]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let kind = headerTitles()[indexPath.section]
        let sponsor = sponsorsByKind(kind: kind)[indexPath.row]
        
        if let urlStr = sponsor.url {
            openUrl(urlStr)
        }
    
    }
    
    func openUrl(_ urlStr: String) {
        if let url = NSURL(string:urlStr) {
            UIApplication.shared.openURL(url as URL)
        }
    }
}
