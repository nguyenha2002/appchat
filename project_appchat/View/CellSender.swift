//
//  CellSender.swift
//  project_appchat
//
//  Created by Nguyễn Thị Hạ on 29/07/2023.
//

import UIKit

class CellSender: UITableViewCell {

    @IBOutlet weak var lbContentSender: UILabel!
    @IBOutlet weak var imgSend: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        imgSend.layer.cornerRadius = 15
        imgSend.layer.masksToBounds = true
    }
    
}
