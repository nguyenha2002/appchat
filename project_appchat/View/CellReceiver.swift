//
//  CellReceiver.swift
//  project_appchat
//
//  Created by Nguyễn Thị Hạ on 29/07/2023.
//

import UIKit

class CellReceiver: UITableViewCell {

    @IBOutlet weak var lbContentReceiver: UILabel!
    @IBOutlet weak var imgReceiver: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        imgReceiver.layer.cornerRadius = 15
        imgReceiver.layer.masksToBounds = true
    }
    
}
