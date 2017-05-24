//
//  OnlineUsersTableViewController.swift
//  MyOwn
//
//  Created by Alexander Rinne on 22-05-17.
//  Copyright © 2017 Alexander Rinne. All rights reserved.
//

import UIKit

class OnlineUsersTableViewController: UITableViewController {

    // MARK: Constants
    let userCell = "UserCell"
    
    // MARK: Properties
    var currentUsers: [String] = []
    
    
    @IBAction func logOutButtonTouch(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentUsers.append("hungry@person.food")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUsers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: userCell, for: indexPath)
        let onlineUserEmail = currentUsers[indexPath.row]
        cell.textLabel?.text = onlineUserEmail
        return cell
    }
    


}
