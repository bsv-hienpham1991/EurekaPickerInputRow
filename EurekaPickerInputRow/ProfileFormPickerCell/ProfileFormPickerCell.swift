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
import SnapKit

open class ProfileFormPickerCell<T>: PickerInputCellCustom<T> where T: Equatable {
    public override func setup() {
        super.setup()
    }
    
    public override func update() {
        super.update()
        
        // Label text color somehow always being back to the color in xib file when scrol
        // It seems to be bug cause by os. Because the stack trace show trigger command from os source.
        // So to fix this a place holder label is created for display when there is no value instead.
        if row.isDisabled {
            customContentView?.detailLabel?.isHidden = true
            if let unwrapped = customContentView as? ProfileFormPickerView {
                unwrapped.placeHolderLabelDisable.isHidden = false
                unwrapped.placeHolderLabelDisable.text = (row as? NoValueDisplayTextConformance)?.noValueDisplayText
                unwrapped.placeHolderLabel.isHidden = true
                unwrapped.detailContainer.backgroundColor = UIColor(red: 234.0/255.0, green: 234.0/255.0, blue: 242.0/255.0, alpha: 1.0)
                unwrapped.arrowIcon.isEnabled = false
            }
        } else {
            customContentView?.detailLabel?.isHidden = (row.value == nil)
            if let unwrapped = customContentView as? ProfileFormPickerView {
                unwrapped.placeHolderLabelDisable.isHidden = true
                unwrapped.placeHolderLabel.text = (row as? NoValueDisplayTextConformance)?.noValueDisplayText
                unwrapped.placeHolderLabel.isHidden = (row.value != nil)
                unwrapped.detailContainer.backgroundColor = .white
                unwrapped.arrowIcon.isEnabled = true
            }
        }
        
        if let unwrapped = customContentView as? ProfileFormPickerView {
            unwrapped.errorContainer.isHidden = row.isValid || row.isDisabled
        }
        
        if let unwrapped = customContentView as? ProfileFormPickerView {
            unwrapped.pickerButton.addTarget(self, action: #selector(didTapOnPickerButton), for: .touchUpInside)
        }
    }
    
    @objc private func didTapOnPickerButton() {
        cellBecomeFirstResponder()
    }
    
//    open override func resignFirstResponder() -> Bool {
//        let cellResignFirstResponder = super.resignFirstResponder()
//        if let row = row as? _ProfileFormPickerRow<T>, row.value == nil {
//            row.value = row.options.first
//            update()
//        }
//        return cellResignFirstResponder
//    }
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
