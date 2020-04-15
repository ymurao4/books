//
//  CustomTableViewCell.swift
//  Books
//
//  Created by 村尾慶伸 on 2020/04/10.
//  Copyright © 2020 村尾慶伸. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell{
    
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }



}
