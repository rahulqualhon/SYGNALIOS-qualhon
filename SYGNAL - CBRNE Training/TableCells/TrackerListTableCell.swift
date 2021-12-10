//
//  TrackerListTableCell.swift
//  SYGNAL - CBRNE Training
//
//  Created by IOS on 01/12/21.
//

import UIKit

class TrackerListTableCell: UITableViewCell {

    @IBOutlet weak var minAlertValueLabel: UILabel!
    @IBOutlet weak var alertValueLabel: UILabel!
    @IBOutlet weak var scaleLabel: UILabel!
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var alertIV: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        
    }
    
}
