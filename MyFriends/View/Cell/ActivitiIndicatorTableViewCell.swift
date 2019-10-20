//
//  ActivitiIndicatorTableViewCell.swift
//  MyFriends
//
//  Created by Alexey Tatarchenko on 20.10.2019.
//  Copyright © 2019 Alexey Tatarchenko. All rights reserved.
//

import UIKit

class ActivitiIndicatorTableViewCell: UITableViewCell {

    @IBOutlet weak var activitiIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        activitiIndicator.startAnimating()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
