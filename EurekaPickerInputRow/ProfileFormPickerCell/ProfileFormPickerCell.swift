//
//  ProfileFormPickerCell.swift
//  koremana
//
//  Created by Hien Pham on 1/19/20.
//  Copyright © 2020 Bravesoft. All rights reserved.
//

import Foundation
import UIKit
import Eureka

open class ProfileFormPickerCell<T>: PickerInputCellCustom<T> where T: Equatable {
    public override func setup() {
        super.setup()
    }
    
    public override func update() {
        super.update()
        
        if let unwrapped = customContentView as? ProfileFormPickerView {
            if row.isDisabled {
                customContentView?.detailLabel?.isHidden = true
                unwrapped.detailContainer.backgroundColor = UIColor(red: 234.0/255.0, green: 234.0/255.0, blue: 242.0/255.0, alpha: 1.0)
                unwrapped.arrowIcon.isEnabled = false
            } else {
                customContentView?.detailLabel?.isHidden = (row.value == nil)
                unwrapped.detailContainer.backgroundColor = .white
                unwrapped.arrowIcon.isEnabled = true
            }
            unwrapped.placeHolderLabel.text = (row as? NoValueDisplayTextConformance)?.noValueDisplayText
            unwrapped.placeHolderLabel.isHidden = (row.value != nil)
            unwrapped.errorContainer.isHidden = row.isValid || row.isDisabled
            unwrapped.pickerButton.addTarget(self, action: #selector(didTapOnPickerButton), for: .touchUpInside)
        }
    }
    
    @objc private func didTapOnPickerButton() {
        cellBecomeFirstResponder()
    }
}

open class _ProfileFormPickerRow<T>: Row<ProfileFormPickerCell<T>>, PickerInputHasCustomContentView, RowWithOptions, NoValueDisplayTextConformance where T: Equatable {
    open var noValueDisplayText: String? = nil
    open var options: [T] = []
    public var rowOptions: [Any] {
        return options
    }
    open var contentViewProvider: ViewProvider<PickerInputCellContentView>?
    
    required public init(tag: String?) {
        super.init(tag: tag)

    }
}
public final class ProfileFormPickerRow<T>: _ProfileFormPickerRow<T>, RowType where T: Equatable, T: InputTypeInitiable {
    required public init(tag: String?) {
        super.init(tag: tag)
        
        contentViewProvider = ViewProvider<PickerInputCellContentView>(nibName: "ProfileFormPickerView", bundle: Bundle.main)
    }
}
