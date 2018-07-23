//
//  Dog.swift
//  SyncDemo
//
//  Created by ZHK on 2018/7/23.
//  Copyright © 2018年 ZHK. All rights reserved.
//

import Foundation
import IceCream
import RealmSwift


class Dog: Object {
    
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var age = 0;
    @objc dynamic var isDelete = false
    
    static let AVATAR_KEY = "avatar"
    
    @objc dynamic var avatar: CreamAsset?
    
    @objc dynamic var owner: Person?
    
    override class func primaryKey() -> String {
        return "id"
    }
    
}

extension Dog: CKRecordRecoverable {
    
}

extension Dog: CKRecordConvertible {
    var isDeleted: Bool {
        return isDelete
    }
}

