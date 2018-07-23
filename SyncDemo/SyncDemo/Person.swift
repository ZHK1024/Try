//
//  Person.swift
//  SyncDemo
//
//  Created by ZHK on 2018/7/23.
//  Copyright © 2018年 ZHK. All rights reserved.
//

import Foundation
import IceCream
import RealmSwift

class Person: Object {
    
    @objc dynamic var id = NSUUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var isDelete = false
    
    let dogs = LinkingObjects(fromType: Dog.self, property: "owner")
    
    override class func primaryKey() -> String {
        return "id"
    }
}

extension Person: CKRecordConvertible {
    var isDeleted: Bool {
        return isDelete
    }
}

extension Person: CKRecordRecoverable {
    
}
