//
//  PlayerTableViewCell.swift
//  DealerDrinker
//
//  Created by Benjamin CANTE on 12/03/2016.
//  Copyright © 2016 com.Nivet. All rights reserved.
//

import UIKit

class PlayerTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var labelPlayer: UILabel!
    @IBOutlet weak var textFieldPlayer: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
