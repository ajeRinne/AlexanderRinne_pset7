//
//  PlaceItem.swift
//  MyOwn
//
//  Created by Alexander Rinne on 22-05-17.
//  Copyright © 2017 Alexander Rinne. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

struct PlaceItem {
    
    let key: String
    let name: String
    let addedByUser: String
    // var ref: DatabaseReference?
    var completed: Bool
    let joiningUsers: String
    
    init(name: String, addedByUser: String, completed: Bool, key: String = "", joiningUsers: String) {
        self.key = key
        self.name = name
        self.addedByUser = addedByUser
        self.completed = completed
        self.joiningUsers = joiningUsers
        // self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        key = snapshot.key
        name = snapshotValue["name"] as! String
        addedByUser = snapshotValue["addedByUser"] as! String
        completed = snapshotValue["completed"] as! Bool
        joiningUsers = snapshotValue["joiningUsers"] as! String
        // ref = snapshot.ref
        
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "addedByUser": addedByUser,
            "completed": completed,
            "joiningUsers":joiningUsers
        ]
    }
    
}
