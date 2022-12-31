//
//  RecordTableViewCell.swift
//  MuscleTrainingManagement
//
//  Created by yutaro on 2022/11/29.
//

import UIKit

class RecordTableViewCell: UITableViewCell {

    @IBOutlet weak var apparatusLabel: UILabel!
    @IBOutlet weak var partLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var stretchCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
