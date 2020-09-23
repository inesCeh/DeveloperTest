//
//  StudentsTableViewCell.swift
//  DeveloperTest
//
//  Created by Ines Ceh on 19/09/2020.
//  Copyright © 2020 Ines Ceh. All rights reserved.
//

import UIKit

class StudentsTableViewCell: UITableViewCell {

    @IBOutlet var containerView: UIView!
    @IBOutlet weak var content: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        Utils.createLayers(containerLayer: containerView.layer, contentLayer: content.layer, cornerRadius: 8)
        nameLabel.textColor = UIColor.primaryTextColor
        Utils.setLetterSpacing(label: nameLabel, letterSpacing: -0.41)
        gradeLabel.textColor = UIColor.secundaryTextColor
        Utils.setLetterSpacing(label: gradeLabel, letterSpacing: -0.41)
        schoolLabel.textColor = UIColor.secundaryTextColor
        Utils.setLetterSpacing(label: schoolLabel, letterSpacing: -0.41)
        arrowImageView.image = UIImage(named: "RightArrow")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
