//
//  FilterBaseViewController.swift
//  PoolTabsSwift
//
//  Created by Kevin Vishal on 8/18/16.
//  Copyright © 2016 TuffyTiffany. All rights reserved.
//

import UIKit

class FilterBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
//    @IBAction func resetFilter(sender: AnyObject) {
//        
//        AppCacheManager.sharedInstance.resetFilter()
//    }
    
    @IBAction func dismissView(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }


}
