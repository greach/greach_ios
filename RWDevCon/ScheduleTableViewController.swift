import Foundation
import UIKit

class ScheduleTableViewController: UITableViewController {
    var coreDataStack: CoreDataStack!
    weak var dataSource: ScheduleDataSource!
    var startDate: Date?
    
    var selectedSession: Session?
    var selectedIndexPath: IndexPath?
    var selectedSectionCount = 0
    
    var isActive = false
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        coreDataStack = (UIApplication.shared.delegate as! AppDelegate).coreDataStack
        
        view.backgroundColor = ThemeManager.currentTheme().tabBarBackgroundColor
        
        dataSource = tableView.dataSource! as! ScheduleDataSource
        dataSource.coreDataStack = coreDataStack
        dataSource.tableCellConfigurationBlock = { (cell: ScheduleTableViewCell, indexPath: IndexPath, session: Session) -> () in
            let track = session.track.name
            let room = session.room.name
            
            let appendix = room != track ? room : ""
            let sessionNumber = session.sessionNumber
            
            cell.nameLabel.text = (!self.dataSource.favoritesOnly && session.isFavorite ? "★ " : "") + session.title
            
            if self.dataSource.favoritesOnly {
                
                cell.timeLabel.text = "\(session.startTimeString) • \(track) • \(appendix)"
                
            } else if sessionNumber != "" {
                
                cell.timeLabel.text = "\(sessionNumber) • \(track) • \(appendix)"
                
            } else {
                if(appendix != "" && appendix != track) {
                    cell.timeLabel.text = "\(track) • \(appendix)"
                } else {
                    cell.timeLabel.text = "\(track)"
                }
                
            }
            
            if ( session.title == "Lunch" || session.title == "Registration" || session.title.hasPrefix("Coffe") || session.title.hasPrefix("Welcome") ) {
                cell.accessoryType = UITableViewCellAccessoryType.none
            } else {
                cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            }
            
        }
        
        let logoImageView = UIImageView(image: UIImage(named: "logo-rwdevcon"))
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: logoImageView.frame.height + 48))
        header.backgroundColor = UIColor(patternImage: UIImage(named: "pattern-grey")!)
        header.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: logoImageView, attribute: .centerX, relatedBy: .equal, toItem: header, attribute: .centerX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: logoImageView, attribute: .centerY, relatedBy: .equal, toItem: header, attribute: .centerY, multiplier: 1.0, constant: 0),
            ])
        
        tableView.tableHeaderView = header
        
        navigationController?.navigationBar.barStyle = UIBarStyle.default
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "pattern-64tall"), for: UIBarMetrics.default)
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "AvenirNext-Regular", size: 17)!, NSForegroundColorAttributeName: UIColor.white]
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: MyScheduleSomethingChangedNotification), object: nil, queue: OperationQueue.main) { (notification) -> Void in
            if self.isActive {
                self.refreshSelectively()
            }
        }
    }
    
    func refreshSelectively() {
        if dataSource.favoritesOnly {
            if let selectedIndexPath = selectedIndexPath {
                if selectedSession != nil && !selectedSession!.isFavorite {
                    // selected session is no longer a favorite!
                    tableView.reloadData()
                    tableFooterOrNot()
                    
                    self.selectedSession = nil
                    self.selectedIndexPath = nil
                    
                    if splitViewController!.isCollapsed {
                        navigationController?.popViewController(animated: true)
                    } else {
                        performSegue(withIdentifier: "tableShowDetail", sender: self)
                    }
                } else {
                    tableView.deselectRow(at: selectedIndexPath, animated: true)
                }
            }
            
            return
        }
        
        if let selectedIndexPath = selectedIndexPath {
            tableView.reloadSections(IndexSet(integer: selectedIndexPath.section), with: .none)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
        
        tableFooterOrNot()
    }
    
    func tableFooterOrNot() {
        if !dataSource.favoritesOnly {
            return
        }
        
        if dataSource.allSessions.count == 0 {
            let footer = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 500))
            let white = UIView()
            white.translatesAutoresizingMaskIntoConstraints = false
            white.backgroundColor = UIColor.white
            white.isOpaque = true
            footer.addSubview(white)
            
            let title = UILabel()
            title.translatesAutoresizingMaskIntoConstraints = false
            title.textColor = UIColor(red: 0, green: 109.0/255, blue: 55.0/255, alpha: 1.0)
            title.text = "SCHEDULE EMPTY"
            title.font = UIFont(name: "AvenirNext-Medium", size: 20)
            white.addSubview(title)
            
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 0
            label.textAlignment = .center
            label.textColor = UIColor.black
            label.text = "Add talks to your schedule from each talk's detail page:\n\n1.\nFind the talk in the Friday or Saturday tabs.\n\n2.\nTap the talk title to see its detail page.\n\n3.\nTap 'Add to My Schedule'."
            label.font = UIFont(name: "AvenirNext-Regular", size: 19)
            white.addSubview(label)
            
            let filler = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
            filler.translatesAutoresizingMaskIntoConstraints = false
            white.addSubview(filler)
            
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "|[white]|", options: [], metrics: nil, views: ["white": white]))
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[white]|", options: [], metrics: nil, views: ["white": white]))
            
            NSLayoutConstraint.activate([
                NSLayoutConstraint(item: title, attribute: .centerX, relatedBy: .equal, toItem: white, attribute: .centerX, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: white, attribute: .width, multiplier: 0.7, constant: 0),
                ])
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[title]-20-[label]-20-[filler]", options: .alignAllCenterX, metrics: nil, views: ["title": title, "label": label, "filler": filler]))
            
            tableView.tableFooterView = footer
        } else {
            tableView.tableFooterView = nil
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let visibleRows = tableView.indexPathsForVisibleRows {
            tableView.reloadRows(at: visibleRows, with: .none)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destNav = segue.destination as? UINavigationController, let dest = destNav.topViewController as? SessionViewController {
            dest.coreDataStack = coreDataStack
            
            selectedIndexPath = tableView.indexPathForSelectedRow
            if selectedIndexPath != nil {
                selectedSession = dataSource.sessionForIndexPath(selectedIndexPath!)
            } else {
                selectedSession = nil
            }
            dest.session = selectedSession
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68;
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 48))
        header.backgroundColor = UIColor(patternImage: UIImage(named: "pattern-row\(section % 2)")!)
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = dataSource.distinctTimes[section].uppercased()
        label.textColor = UIColor.white
        label.font = UIFont(name: "AvenirNext-Medium", size: 18)
        header.addSubview(label)
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "|-20-[label]-|", options: [], metrics: nil, views: ["label": label]) +
            [NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: header, attribute: .centerY, multiplier: 1.0, constant: 4)])
        
        
        return header
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
}
