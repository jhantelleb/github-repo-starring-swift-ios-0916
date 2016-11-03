//
//  RepoTableViewCell.swift
//  github-repo-starring-swift
//
//  Created by Jhantelle Belleza on 11/2/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class RepoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var starButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
