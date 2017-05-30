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
    
//    Athenticate user
    let user = Auth.auth().currentUser
    
//    Setup reference
    let placesRef = Database.database().reference(withPath: "users")

    // MARK: Properties
    var users = [Any]()
    
    
    // MARK: Outlets
    @IBOutlet var logoutBarButton2: UIBarButtonItem!
    @IBOutlet var joinBarButton: UIBarButtonItem!
    
    // MARK: Actions
    @IBAction func joinBarButtonTouched(_ sender: Any) {
        
//        Create references
        let joiningUsersRef = placesRef.child(currentPlace!.lowercased())
        let joiningUserRef = joiningUsersRef.childByAutoId()
        
//        Ensure users cannot login twice        
        self.joinBarButton.isEnabled = false
        self.joinBarButton.accessibilityElementsHidden = true
        
//        Set value of joining user in database
        joiningUserRef.setValue(["email" : (self.user?.email!)])
        self.tableView.reloadData()


    }
    
    @IBAction func logoutBarButton2Touched(_ sender: Any) {
        do {
            
//            Authenticate user and sign out
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
        } catch {
            print("Could not sign out: \(error)")
        }

    }
    
    // MARK: ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Enable join button
        self.joinBarButton.isEnabled = true
        self.joinBarButton.accessibilityElementsHidden = false

//        Create a reference to users
        let joiningUsersRef = placesRef.child(currentPlace!.lowercased())
        
//        Check if user is signed it
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let currentUser = user else { return }
            if Auth.auth().currentUser == nil {
                print("no user signed it")
            } else {
                print("signed in")
            }
        }
        
//        Query attending users table
        joiningUsersRef.queryOrdered(byChild: "email").observe(.value, with: { snapshot in
            
//            create a temporary storage
            var newUsers = [Any]()

//            Loop over users in snapshot
            for user in snapshot.children.allObjects as! [DataSnapshot] {
                
//                Create dict in order to retreive data
                let joiningUser = user.value! as! Dictionary<String, String>

//                Get value from dict
                let email = joiningUser["email"]

//                Append email to temporary array
                newUsers.append(email)
            }
            
//            Copy value of temporary array in users array
            self.users = newUsers
            
//            Reload data in order to get right view
            self.tableView.reloadData()
        })


    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        Create reference for cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "JoiningUserCell", for: indexPath) as! JoiningUsersTableViewCell
        
//        Add email of joining user
        let userItem = users[indexPath.row]
        
//        Display email in label of cell
        cell.userLabel.text = userItem as! String

        return cell
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
        
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
}

    


