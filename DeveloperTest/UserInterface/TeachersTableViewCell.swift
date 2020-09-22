//
//  TeachersTableViewCell.swift
//  DeveloperTest
//
//  Created by Ines Ceh on 17/09/2020.
//  Copyright © 2020 Ines Ceh. All rights reserved.
//

import UIKit

protocol TeachersTableViewCellDelegate {
    
    func openContactList(teacherID: Int)
}

class TeachersTableViewCell: UITableViewCell {

    @IBOutlet var containerView: UIView!
    @IBOutlet weak var content: UIView!
    
    @IBOutlet weak var teacherImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var contactButton: UIButton!
    
    var delegate: TeachersTableViewCellDelegate?
    var teacherID: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        Utils.createLayers(containerLayer: containerView.layer, contentLayer: content.layer, cornerRadius: 8)
        nameLabel.textColor = UIColor.primaryTextColor
        Utils.setLetterSpacing(label: nameLabel, letterSpacing: -0.41)
        classLabel.textColor = UIColor.secundaryTextColor
        Utils.setLetterSpacing(label: classLabel, letterSpacing: -0.41)
        schoolLabel.textColor = UIColor.secundaryTextColor
        Utils.setLetterSpacing(label: schoolLabel, letterSpacing: -0.41)
        contactButton.layer.cornerRadius = 8
        contactButton.layer.shadowColor = UIColor.black.cgColor;
        contactButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        contactButton.layer.shadowRadius = 10
        contactButton.layer.shadowOpacity = 0.1
        contactButton.backgroundColor = UIColor.buttonBackgroundColor
        contactButton.tintColor = UIColor.buttonTextColor
        contactButton.setTitle(NSLocalizedString("teachers_contact", comment: ""), for: .normal)
        Utils.setLetterSpacing(button: contactButton, letterSpacing: -0.41)
        arrowImageView.image = UIImage(named: "RightArrow")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func actionOnContactButton(_ sender: Any) {
        
        delegate?.openContactList(teacherID: teacherID)
    }
}
