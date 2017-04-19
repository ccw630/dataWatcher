//
//  AppDelegate.swift
//  DataWatcher
//
//  Created by Xin ZHANG on 28/3/17.
//  Copyright © 2017年 ccw630. All rights reserved.
//

import UIKit

extension NSDate{
    func countDay()->Int{
        let interval = Int(self.timeIntervalSince1970)
        return interval / 86400
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var n1,n2,m1,m2: UInt32?
    var dn1,dn2,dm1,dm2: UInt32?
    var day: Int = 0
    var timer:Timer!
    


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        return true
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
        if (timer != nil){
            timer.invalidate()
        }
    }


    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if (timer != nil){
            timer.invalidate()
        }
        let date = NSDate().countDay()
        print(date)
        if (date>day){
            let a:DataUsageInfo = DataUsage.getDataUsage()
            dn1=a.wifiSent
            dn2=a.wifiReceived
            dm1=a.wirelessWanDataSent
            dm2=a.wirelessWanDataReceived
            day=date
        }
        let a:DataUsageInfo = DataUsage.getDataUsage()
        n1=a.wifiSent
        n2=a.wifiReceived
        m1=a.wirelessWanDataSent
        m2=a.wirelessWanDataReceived
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (Timer) in
            let a:DataUsageInfo = DataUsage.getDataUsage()
            //RITL_ShareDataDefaultsManager.saveData("Today:\(((a.wifiSent+a.wifiReceived)-(self.dn1!+self.dn2!))/1024) KB"+"!"+"\(((a.wifiSent+a.wifiReceived)-(self.n1!+self.n2!))/1024) KB/s")
            print(":"+RITL_ShareDataDefaultsManager.getData())
            print("Today:",((a.wifiSent+a.wifiReceived)-(self.dn1!+self.dn2!))/1024,"KB")
            print(((a.wifiSent+a.wifiReceived)-(self.n1!+self.n2!))/1024,"KB/s")
            self.n1=a.wifiSent
            self.n2=a.wifiReceived
            self.m1=a.wirelessWanDataSent
            self.m2=a.wirelessWanDataReceived
        })
        completionHandler(UIBackgroundFetchResult.newData)
    }
}

