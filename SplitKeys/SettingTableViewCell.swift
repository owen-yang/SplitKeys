//
//  SettingTableViewCell.swift
//  SplitKeys
//
//  Created by Owen Yang on 10/30/16.
//  Copyright © 2016 SplitKeys. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    
    init() {
        super.init(style: .default, reuseIdentifier: nil)
        selectionStyle = .none
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
