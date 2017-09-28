//
//  TextCell.swift
//  WxToutiao
//
//  Created by chenxi on 2017/9/25.
//  Copyright © 2017年 chenxi. All rights reserved.
//

import UIKit

class TextCell: UITableViewCell {

    @IBOutlet weak var titleLable: UILabel!
    
    @IBOutlet weak var commentLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
