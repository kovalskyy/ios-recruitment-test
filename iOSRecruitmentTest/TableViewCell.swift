//
//  TableViewCell.swift
//  iOSRecruitmentTest
//
//  Created by Bazyli Zygan on 15.06.2016.
//  Copyright © 2016 Snowdog. All rights reserved.
//

import UIKit
import SDWebImage

class TableViewCell: UITableViewCell {

    var item: ItemRealm? {
        didSet {
            if item == nil {
                iconView.image = nil
                itemTitleLabel.text = "Test"
                itemDescLabel.text = "Some description"
            } else {
             //    TODO: Implement item sets
                
                iconView.sd_setImage(with: URL(string: item!.icon), placeholderImage: UIImage(named: "placeholder.png"), options: SDWebImageOptions(), completed: { (image: UIImage?, error: Error?, cachetype: SDImageCacheType, imageURL: URL?) in
                })
                
                itemTitleLabel.text = item?.name
                itemDescLabel.text = item?.desc
                
            }
        }
    }
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemDescLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconView.layer.cornerRadius = 4
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.item = nil
    }
    
}
