//
//  ProfileFormPickerView.swift
//  koremana
//
//  Created by Hien Pham on 1/18/20.
//  Copyright © 2020 Bravesoft. All rights reserved.
//

import UIKit

class ProfileFormPickerView: PickerInputCellContentView {
    @IBOutlet weak var topSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var requiredView: UIImageView!
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var placeHolderLabelDisable: UILabel!
    @IBOutlet weak var detailContainer: UIView!
    @IBOutlet weak var arrowIcon: UIButton!
    @IBOutlet weak var errorContainer: UIView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    

    @IBAction func labelClicked(_ sender: Any) {
        firstResponderDelegate?.pickerInputCellContentViewBecomeFirstRersponder(self)
    }
}
