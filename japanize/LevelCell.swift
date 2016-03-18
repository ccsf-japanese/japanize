//
//  LevelCell.swift
//  japanize
//
//  Created by Dylan Smith on 3/17/16.
//  Copyright © 2016 Codepath. All rights reserved.
//

import UIKit

class LevelCell: UITableViewCell {
    
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var goal1Label: UILabel!
    @IBOutlet weak var goal2Label: UILabel!
    @IBOutlet weak var goal3Label: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
