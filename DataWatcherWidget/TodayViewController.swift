//
//  TodayViewController.swift
//  DataWatcherWidget
//
//  Created by Xin ZHANG on 5/4/17.
//  Copyright © 2017年 ccw630. All rights reserved.
//

import UIKit
import NotificationCenter

extension NSDate{
    func countDay()->Int{
        let interval = Int(self.timeIntervalSince1970)
        return interval / 86400
    }
}

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var l1: UILabel!
    @IBOutlet weak var l2: UILabel!
    
    var window: UIWindow?
    var nowWifiSent,nowWifiReceived,nowDataSent,nowDataReceived: UInt32?
    var lastWifiSent,lastWifiReceived,lastDataSent,lastDataReceived: UInt32?
    var dayLast: Int = 0
    var timer:Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        let rd = RITL_ShareDataDefaultsManager.getData().characters.split(separator: "!").map(String.init)
        if rd != []{
            dayLast=Int(rd[4])!
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        if (timer != nil){
            timer.invalidate()
        }
        let dayNow = NSDate().countDay()
        if (dayNow>dayLast){
            let a:DataUsageInfo = DataUsage.getDataUsage()
            RITL_ShareDataDefaultsManager.saveData("\(a.wifiSent)!\(a.wifiReceived)!\(a.wirelessWanDataSent)!\(a.wirelessWanDataReceived)!\(dayNow)")
        }
        let rd = RITL_ShareDataDefaultsManager.getData().characters.split(separator: "!").map(String.init)
        lastWifiSent=UInt32(rd[0])
        lastWifiReceived=UInt32(rd[1])
        lastDataSent=UInt32(rd[2])
        lastDataReceived=UInt32(rd[3])
        dayLast=Int(rd[4])!
        let a:DataUsageInfo = DataUsage.getDataUsage()
        nowWifiSent=a.wifiSent
        nowWifiReceived=a.wifiReceived
        nowDataSent=a.wirelessWanDataSent
        nowDataReceived=a.wirelessWanDataReceived
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (Timer) in
            let a:DataUsageInfo = DataUsage.getDataUsage()
            let data1 = ((a.wirelessWanDataSent+a.wirelessWanDataReceived)-(self.lastDataSent!+self.lastDataReceived!))
            if (data1 > 1024000){
                self.l1.text="Today: \(data1/1048576) MB"
            }
            else if (data1 > 1000) {
                self.l1.text="Today: \(data1/1024) KB"
            }
            else {
                self.l1.text="Today: \(data1) B"
            }
            let data2 = ((a.wirelessWanDataSent+a.wirelessWanDataReceived)-(self.nowDataSent!+self.nowDataReceived!))
            if (data2 > 1000000){
                self.l2.text="\(data2/1048576) MB/s"
            }
            else if (data2 > 1000){
                self.l2.text="\(data2/31024) KB/s"
            }
            else {
                self.l2.text="\(data2) B/s"
            }

            completionHandler(NCUpdateResult.newData)
            self.nowWifiSent=a.wifiSent
            self.nowWifiReceived=a.wifiReceived
            self.nowDataSent=a.wirelessWanDataSent
            self.nowDataReceived=a.wirelessWanDataReceived
        })
        
    }
    
}
