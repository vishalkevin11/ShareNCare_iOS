//
//  ProfileAvatarImageViewDataSource.swift
//  TavantPool
//
//  Created by Kevin Vishal on 10/30/16.
//  Copyright © 2016 TuffyTiffany. All rights reserved.
//

import UIKit
import AvatarImageView

class ProfileAvatarImageViewDataSource: AvatarImageViewDataSource {

    var name: String
    //var avatar: UIImage?
    
    init() {
        name = ""
    }
    
    func assignNameToImage(_ nameStr : String) -> Void {
        name = nameStr
    }
    
//    init() {
//        name = ProfileAvatarImageViewDataSource.randomName()
//    }
////    
//    static func randomName() -> String {
//        let charSet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
//        let charSetArray = charSet.characters.map { String($0) }
//        
//        var string = ""
//        
//        for _ in 0..<5 {
//            string += charSetArray[Int(arc4random()) % charSetArray.count]
//        }
//        
//        string += " "
//        
//        for _ in 0..<5 {
//            string += charSetArray[Int(arc4random()) % charSetArray.count]
//        }
//        
//        return string
//    }

}
