//
//  TableViewCell.swift
//  TableviewMonth
//
//  Created by Junyoung Lee on 2022/03/27.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
