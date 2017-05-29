//
//  JoiningUsersTableViewController.swift
//  MyOwn
//
//  Created by Alexander Rinne on 22-05-17.
//  Copyright © 2017 Alexander Rinne. All rights reserved.
//

import UIKit
import Firebase

class JoiningUsersTableViewController: UITableViewController {
    // MARK: Constants
    var currentPlace : String?
    let userCell = "UserCell"
    let user = Auth.auth().currentUser
    let placesRef = Database.database().reference(withPath: "place-items")
//    var currentPlaceRef: Any?
    // MARK: Properties
    var joiningUsers: [String] = []
    
    

    @IBOutlet var logoutBarButton2: UIBarButtonItem!
    
    @IBOutlet var joinBarButton: UIBarButtonItem!
    
    @IBAction func joinBarButtonTouched(_ sender: Any) {
        let currentPlaceRef = placesRef.child(currentPlace!.lowercased()).child("joiningUserEmail").child("email")
        currentPlaceRef.setValue(self.user?.email!)
//            .child("joiningUsers").setValue(["username": user])
        
//        let joiningUser = currentPlaceRef.child("joiningUsers").Child.setValue(user)
        print("check7: \(currentPlace!)")
        placesRef.observe(.value, with: {snapshot in
            print(snapshot.value!)
        })
        currentPlaceRef.observe(.value, with: {snapshot in
            print(snapshot.value!)
        })
    }
    @IBAction func logoutBarButton2Touched(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
        } catch {
            print("Could not sign out: \(error)")
        }

    }
   
    override func viewDidLoad() {
        super.viewDidLoad()

//        joiningUsers.append("hungry@person.food")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return joiningUsers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: userCell, for: indexPath)
        let onlineUserEmail = joiningUsers[indexPath.row]
        cell.textLabel?.text = onlineUserEmail
        return cell
    }
    
    

}
