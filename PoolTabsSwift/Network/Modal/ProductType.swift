//
//  ProductType.swift
//  ShareNCare
//
//  Created by Kevin Vishal on 1/28/17.
//  Copyright © 2017 TuffyTiffany. All rights reserved.
//

import UIKit

class ProductType: NSObject {
    
    var typeid : String? = ""
    var categorytype : String? = ""
    var imageurl : String? = ""
    
    
    
    override init() {
        
    }
    
    convenience init(productDict : NSDictionary){
        
        self.init()
        self.typeid =  ((productDict["typeid"]) != nil ) ? productDict["typeid"]! as? String : "NA"
        self.categorytype =  ((productDict["categorytype"]) != nil ) ? productDict["categorytype"]! as? String : "NA"
        self.imageurl =  ((productDict["imageurl"]) != nil ) ? productDict["imageurl"]! as? String : "NA"
        
    }
    deinit{
        
        
    }
}
