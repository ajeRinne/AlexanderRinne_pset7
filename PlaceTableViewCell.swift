//
//  PlaceTableViewCell.swift
//  
//
//  Created by Alexander Rinne on 27-05-17.
//
//

import UIKit

class PlaceTableViewCell: UITableViewCell {
    @IBOutlet var placeLabel: UILabel!
    @IBOutlet var addedByLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
