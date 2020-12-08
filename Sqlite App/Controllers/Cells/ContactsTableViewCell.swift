//
//  ContactsTableViewCell.swift
//  Sqlite App
//
//  Created by Adithya on 05/12/20.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {

    @IBOutlet var contactLbl: UILabel!
    @IBOutlet var selfBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
