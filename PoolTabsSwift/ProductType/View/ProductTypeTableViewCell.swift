//
//  ProductTypeTableViewCell.swift
//  ShareNCare
//
//  Created by Kevin Vishal on 1/27/17.
//  Copyright © 2017 TuffyTiffany. All rights reserved.
//

import UIKit

class ProductTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewProductType: UIImageView!
    @IBOutlet weak var labelProductSubType: UILabel!
    @IBOutlet weak var labelProductType: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
