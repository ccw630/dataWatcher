//
//  ViewController.swift
//  DataWatcher
//
//  Created by Xin ZHANG on 28/3/17.
//  Copyright © 2017年 ccw630. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var btn: UIButton!
    var dataUsage:DataUsage = DataUsage()
    
    @IBOutlet weak var l1: UILabel!
    @IBOutlet weak var l2: UILabel!
    @IBOutlet weak var l3: UILabel!
    @IBOutlet weak var l4: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pressed(_ sender:UIButton){
        var timer:Timer!
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (Timer) in
            let a:DataUsageInfo = DataUsage.getDataUsage()
            self.l1.text=a.wifiSent.description
            self.l2.text=a.wifiReceived.description
            self.l3.text=a.wirelessWanDataSent.description
            self.l4.text=a.wirelessWanDataReceived.description
        })
        /*let a:DataUsageInfo = DataUsage.getDataUsage()
        l1.text=a.wifiSent.description
        l2.text=a.wifiReceived.description
        l3.text=a.wirelessWanDataSent.description
        l4.text=a.wirelessWanDataReceived.description*/
    }
    
    func getData(){
        let a:DataUsageInfo = DataUsage.getDataUsage()
        l1.text=a.wifiSent.description
        l2.text=a.wifiReceived.description
        l3.text=a.wirelessWanDataSent.description
        l4.text=a.wirelessWanDataReceived.description
    }

}

