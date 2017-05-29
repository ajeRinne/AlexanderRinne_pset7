//
//  PlacesItemTableViewController.swift
//  
//
//  Created by Alexander Rinne on 22-05-17.
//
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class PlacesItemTableViewController: UITableViewController {
    
    let placeRef = Database.database().reference(withPath: "place-items")
    let usersRef = Database.database().reference(withPath: "online")
    let listToUsers = "ListToUsers"
    var items: [PlaceItem] = []
    let user = Auth.auth().currentUser
    var itemsCount : Int?
    var currentPlace : String = ""
    var joiningUser: String = ""
//    var userAuth : String = ""
    
    var userCountBarButtonItem: UIBarButtonItem!
    
    @IBOutlet var addBarButton: UIBarButtonItem!
    
    @IBOutlet var logoutBarButton: UIBarButtonItem!
    
    @IBAction func logoutBarButtonTouched(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
        } catch {
            print("Could not sign out: \(error)")
        }
    }
    @IBAction func addBarButtonTouched(_ sender: Any) {
        let alert = UIAlertController(title: "Place Item", message: "Add an Item", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            
            // 1
            guard let textField = alert.textFields?.first, let text = textField.text else { return }
            
            // 2            
            let placeItem = PlaceItem(name: text, addedByUser: (self.user?.email!)!, completed: false, joiningUsers: (self.user?.email!)!)
            
            // 3
           let placeItemRef = self.placeRef.child(text.lowercased())
            
            // 4
            placeItemRef.setValue(placeItem.toAnyObject())
            
//            let joiningUserRef = placeItemRef.child(self.joiningUser)
            


            self.itemsCount! += 1
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)

    }
    
//    
//    func toggleCellCheckbox(_ cell: UITableViewCell, isCompleted: Bool) {
//        if !isCompleted {
//            cell.accessoryType = .none
//            cell.textLabel?.textColor = UIColor.black
//            cell.detailTextLabel?.textColor = UIColor.black
//        } else {
//            cell.accessoryType = .checkmark
//            cell.textLabel?.textColor = UIColor.gray
//            cell.detailTextLabel?.textColor = UIColor.gray
//        }
//    }


    override func viewDidLoad() {
        super.viewDidLoad()
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let currentUser = user else { return }
            if Auth.auth().currentUser == nil {
                print("no user signed it")
            } else {
                print("signed in")
            }

//            let currentUserRef = self.usersRef.child(self.user.userID)
//            currentUserRef.setValue(self.user.email)
//            currentUserRef.onDisconnectRemoveValue()
        }
        
//        let currentUserRef = self.usersRef.child(self.user.userID)
        // 2
//        currentUserRef.setValue(self.user.email)
        // 3
//        currentUserRef.onDisconnectRemoveValue()

        placeRef.observe(.value, with: { snapshot in
        print(snapshot.value!)
        })

        if (itemsCount != 0 ) {
            placeRef.queryOrdered(byChild: "completed").observe(.value, with: { snapshot in
                var newItems: [PlaceItem] = []
            
                for item in snapshot.children {
                    let placeItem = PlaceItem(snapshot: item as! DataSnapshot)
                    newItems.append(placeItem)
                }
            
                self.items = newItems
                self.tableView.reloadData()
            })
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == listToUsers) {
            let viewController = segue.destination as! JoiningUsersTableViewController
            let indexPath = tableView.indexPathForSelectedRow
            if indexPath != nil {
                let placeItem = items[indexPath!.row]
                print("check5: \(placeItem)")
                let place = placeItem.name
                print("chekc6: \(place)")
                viewController.currentPlace = place
                
            }
        }
    }

    

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        

        let cell = tableView.dequeueReusableCell(withIdentifier: "PlacesCell", for: indexPath) as! PlaceTableViewCell
        let placeItem = items[indexPath.row]
        
//        toggleCellCheckbox(cell, isCompleted: placeItem.completed)
        
        cell.placeLabel.text = placeItem.name
        cell.addedByLabel.text = placeItem.addedByUser
        

        
        return cell
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            items.remove(at: indexPath.row)
            itemsCount! -= 1
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
                self.performSegue(withIdentifier: listToUsers, sender: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
}
