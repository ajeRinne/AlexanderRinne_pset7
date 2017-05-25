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
    
    // let ref = Database.self
    let ref = Database.database().reference(withPath: "place-items")
    let usersRef = Database.database().reference(withPath: "online")
    // MARK: Constants
    let listToUsers = "ListToUsers"
    
    // MARK: Properties
    var items: [PlaceItem] = []
    var user: User!
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
            let placeItem = PlaceItem(name: text, addedByUser: self.user.email, completed: false)
            
            // 3
            let placeItemRef = self.ref.child(text.lowercased())
            
            // 4
            placeItemRef.setValue(placeItem.toAnyObject())
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)

    }
    
    
    func toggleCellCheckbox(_ cell: UITableViewCell, isCompleted: Bool) {
        if !isCompleted {
            cell.accessoryType = .none
            cell.textLabel?.textColor = UIColor.black
            cell.detailTextLabel?.textColor = UIColor.black
        } else {
            cell.accessoryType = .checkmark
            cell.textLabel?.textColor = UIColor.gray
            cell.detailTextLabel?.textColor = UIColor.gray
        }
    }
    
    func userCountBarButtonTouched() {
        performSegue(withIdentifier: listToUsers, sender: nil)
        }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
        }

        ref.observe(.value, with: { snapshot in
        print(snapshot.value!)
    })
    
        userCountBarButtonItem = UIBarButtonItem(title: "1",
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(userCountBarButtonTouched))
        userCountBarButtonItem.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = userCountBarButtonItem
        
        // user = User(uid: "FakeId", email: "hungry@person.food")
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let groceryItem = items[indexPath.row]
        
        cell.textLabel?.text = groceryItem.name
        cell.detailTextLabel?.text = groceryItem.addedByUser
        
        toggleCellCheckbox(cell, isCompleted: groceryItem.completed)
        
        return cell
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            items.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        var groceryItem = items[indexPath.row]
        let toggledCompletion = !groceryItem.completed
        
        toggleCellCheckbox(cell, isCompleted: toggledCompletion)
        groceryItem.completed = toggledCompletion
            tableView.reloadData()
    }
}
