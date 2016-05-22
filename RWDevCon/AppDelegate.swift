import Foundation
import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  lazy var coreDataStack = CoreDataStack()

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    let theme = ThemeManager.currentTheme()
    ThemeManager.applyTheme(theme)
    
    // global style
    application.statusBarStyle = UIStatusBarStyle.LightContent
    UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: "AvenirNext-Regular", size: 17)!, NSForegroundColorAttributeName: UIColor.whiteColor()], forState: .Normal)

    let splitViewController = window!.rootViewController as! UISplitViewController
    splitViewController.delegate = self

    if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
      splitViewController.preferredDisplayMode = .AllVisible
      splitViewController.preferredPrimaryColumnWidthFraction = 0.5
      splitViewController.maximumPrimaryColumnWidth = 512
    }

    return true
  }

  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    coreDataStack.saveContext()
  }

}

extension AppDelegate: UISplitViewControllerDelegate {
  func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController, ontoPrimaryViewController primaryViewController:UIViewController) -> Bool {
    if let secondaryAsNavController = secondaryViewController as? UINavigationController {
      if let topAsDetailController = secondaryAsNavController.topViewController as? SessionViewController where topAsDetailController.session == nil {
        // If there's no session, then we only want to show the primary. This is the
        // only case where we return true. Remember, returning true means we've handled
        // the collapse -- in this case, we've handled it by doing nothing! :]
        return true
      }

      // Otherwise, we want the default behavior of pushing whatever's on the secondary
      // onto the primary. In that case, we should make sure the primary's navigation
      // bar is displayed if it's a navigation controller.
      if let primaryAsNavController = primaryViewController as? UINavigationController {
        primaryAsNavController.setNavigationBarHidden(false, animated: false)
      }
    }

    // Returning false means we want the split view controller to handle the collapse.
    // In this app with its navigation controllers on both the primary and secondary,
    // it will simply push everything on the secondary onto the primary.
    return false
  }

}
