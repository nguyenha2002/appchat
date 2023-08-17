//
//  ListCell.swift
//  project_appchat
//
//  Created by Nguyễn Thị Hạ on 29/07/2023.
//

import UIKit

class ListCell: UITableViewCell {

    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        img.layer.cornerRadius = 30
        img.layer.masksToBounds = true
        // Configure the view for the selected state
    }
    
    
}
