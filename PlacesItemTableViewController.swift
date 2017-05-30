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
    
    //MARK: Constants
    
//    Setup reference for database
    let placesRef = Database.database().reference(withPath: "place-items")
    let usersRef = Database.database().reference(withPath: "online")
    
//    Create clear string value for segue
    let listToUsers = "ListToUsers"
    
//    Authenticate user
    let user = Auth.auth().currentUser
    
    // MARK: Properties
    var items: [PlaceItem] = []
    var currentPlace : String = ""
    var joiningUser: String = ""
    var userCountBarButtonItem: UIBarButtonItem!
    
    // MARK: Outlets
    @IBOutlet var addBarButton: UIBarButtonItem!
    @IBOutlet var logoutBarButton: UIBarButtonItem!
    
    // MARK: Actions
    @IBAction func logoutBarButtonTouched(_ sender: Any) {
        do {
//            Authenticate user and log out
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
        } catch {
            print("Could not sign out: \(error)")
        }
    }
    
    @IBAction func addBarButtonTouched(_ sender: Any) {
        
//        Create alert to add place to go
        let alert = UIAlertController(title: "Place Item", message: "Add an Item", preferredStyle: .alert)
        
//        Create save action for place to go
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            
//              Check if textfield is filled in
            guard let textField = alert.textFields?.first, let text = textField.text else { return }
            
//              Save input from textfield
            let placeItem = PlaceItem(name: text, addedByUser: (self.user?.email!)!, completed: false, joiningUsers: (self.user?.email!)!)
            
//              Create a reference to the database for the place
           let placeItemRef = self.placesRef.child(text.lowercased())
            
//              Add value of textfield to database
            placeItemRef.setValue(placeItem.toAnyObject())
            
//            Relaod data to see up to date table
            self.tableView.reloadData()
        }
        
//        Create cancel action in alert
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField()
        
//        Add actions to alert
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)

    }

    // MARK: ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Authenticate user and check for changes in login status
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let currentUser = user else { return }
            
//            Check if user is logged in
            if Auth.auth().currentUser == nil {
                print("no user signed it")
            } else {
                print("signed in")
            }
       }
        
//        Get places table
        placesRef.observe(.value, with: { snapshot in
        print(snapshot.value!)
        })

//          Guery database by places
        placesRef.queryOrdered(byChild: "completed").observe(.value, with: { snapshot in
            
//            Create temporary array to store data
            var newItems: [PlaceItem] = []
            
//            Iterate over items in snapshot
            for item in snapshot.children {
                
//                Create database instance to get data per place
                let placeItem = PlaceItem(snapshot: item as! DataSnapshot)
                
//                Append data of single place to array
                newItems.append(placeItem)
            }
            
//            Copy temporary array in array
            self.items = newItems
            
//            Reload data in order se up to date view
            self.tableView.reloadData()
        })


    }
    
//    Prepare for segue to have identifier the place users can join
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == listToUsers) {
            let viewController = segue.destination as! JoiningUsersTableViewController
            
//            Setup index path for tablecell selected place in table
            let indexPath = tableView.indexPathForSelectedRow
            
//            Get place item at selected row
            if indexPath != nil {
                let placeItem = items[indexPath!.row]
                let place = placeItem.name
                
//                send current place to next view
                viewController.currentPlace = place
                
            }
        }
    }

    

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

//        Create cell reference
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlacesCell", for: indexPath) as! PlaceTableViewCell
        
//        Get place data from array
        let placeItem = items[indexPath.row]
        
//        Show place data in cell labels
        cell.placeLabel.text = placeItem.name
        cell.addedByLabel.text = placeItem.addedByUser
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
//            Add delete option for items
            items.remove(at: indexPath.row)
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
