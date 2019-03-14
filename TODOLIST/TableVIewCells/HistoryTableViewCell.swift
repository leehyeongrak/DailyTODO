//
//  HistoryTableViewCell.swift
//  TODOLIST
//
//  Created by RAK on 14/03/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet var taskLabel: UILabel!
    @IBOutlet var checkDoneButton: UIButton!
    
    override func awakeFromNib() {
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
