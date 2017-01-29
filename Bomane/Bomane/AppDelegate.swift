//
//  AppDelegate.swift
//  Bomane
//
//  Created by Jeremy Sharvit on 2016-11-27.
//  Copyright © 2016 com.bomane. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let aboutVC = AboutViewController()
    let servicesVC = ServicesViewController()
    let portfolioVC = ProtfolioViewController()
    let bookVC = BookAppointmentViewController()
    let profileVC = ProfileViewController()
    let contactVC = ContactViewController()
    
    class func shared() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.black
        self.checkIfUserExists()
        return true
    }
    
    
    func checkIfUserExists() {
        if DatabaseController.shared.loadUser() != nil {
            dump(DatabaseController.shared.loadUser()!)
            initWindow(controller: "Book Appointment")
        } else {
            self.showLogin()
        }
    }
    
    func initWindow(controller: String) {
        
        let controllerDic = ["About" : aboutVC, "Services":servicesVC, "Portfolio" : portfolioVC, "Book Appointment" : bookVC, "Profile" : profileVC, "Contact" : contactVC]
        
        if controller == "Book Appointment" || controller == "Services" || controller == "Portfolio" || controller == "Profile" {
            UIApplication.shared.statusBarStyle = .default
        } else {
            UIApplication.shared.statusBarStyle = .lightContent
        }
        
        guard let vc = controllerDic[controller] else {return}
        let navController = UINavigationController(rootViewController: vc)
        window?.rootViewController = navController
    
        self.window?.makeKeyAndVisible()
    }
    
    func showLogin() {
        UIApplication.shared.statusBarStyle = .lightContent
        let signUpVC = SignUpViewController()
        let navigationController = UINavigationController(rootViewController: signUpVC)
        window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

