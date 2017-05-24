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
    
    init(name: String, addedByUser: String, completed: Bool, key: String = "") {
        self.key = key
        self.name = name
        self.addedByUser = addedByUser
        self.completed = completed
        // self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        addedByUser = snapshotValue["addedByUser"] as! String
        completed = snapshotValue["completed"] as! Bool
        // ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "addedByUser": addedByUser,
            "completed": completed
        ]
    }
    
}
