//
//  PickerInputCellContentView.swift
//  koremana
//
//  Created by Hien Pham on 1/18/20.
//  Copyright © 2020 Bravesoft. All rights reserved.
//

import Foundation
import UIKit
import Eureka
import SnapKit

protocol PickerInputCellContentViewDelegate: class {
    func pickerInputCellContentViewBecomeFirstRersponder(_ pickerInputCellContentView: PickerInputCellContentView)
}

public protocol PickerInputHasCustomContentView: class {
    var contentViewProvider: ViewProvider<PickerInputCellContentView>? { get set }
}

open class PickerInputCellContentView: UIView {
    @IBOutlet weak open var titleLabel: UILabel?
    @IBOutlet weak open var detailLabel: UILabel?
    weak var firstResponderDelegate: PickerInputCellContentViewDelegate?
}

open class PickerInputCellCustom<T>: PickerInputCell<T> where T: Equatable {
    var bsContentView: PickerInputCellContentView?
    
    fileprivate var pickerInputRowCustom: RowWithOptions? { return row as? RowWithOptions }
        
    open override func setup() {
        super.setup()
        bsContentView = (row as? PickerInputHasCustomContentView)?.contentViewProvider?.makeView()
        if let unwrapped = bsContentView {
            addSubview(unwrapped)
            unwrapped.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
        bsContentView?.firstResponderDelegate = self
    }
    
    open override func update() {
        super.update()
        
        textLabel?.isHidden = true
        detailTextLabel?.isHidden = true
        selectionStyle = .none
        
        bsContentView?.titleLabel?.text = row.title
        
        if let value = row.value {
            bsContentView?.detailLabel?.text = row.displayValueFor?(value) ?? (row as? NoValueDisplayTextConformance)?.noValueDisplayText
        } else {
            bsContentView?.detailLabel?.text = (row as? NoValueDisplayTextConformance)?.noValueDisplayText
        }

        if let selectedValue = row.value, let options = pickerInputRowCustom?.rowOptions as? [T], let index = options.firstIndex(of: selectedValue) {
            picker.selectRow(index, inComponent: 0, animated: true)
        } else {
            picker.selectRow(0, inComponent: 0, animated: true)
        }
    }

    open override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerInputRowCustom?.rowOptions.count ?? 0
    }

    open override func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.row.displayValueFor?(pickerInputRowCustom?.rowOptions[row] as? T)
    }

    open override func pickerView(_ pickerView: UIPickerView, didSelectRow rowNumber: Int, inComponent component: Int) {
        if let picker = pickerInputRowCustom, picker.rowOptions.count > rowNumber {
            self.row.value = picker.rowOptions[rowNumber] as? T
            update()
        }
    }
}

extension PickerInputCellCustom: PickerInputCellContentViewDelegate {
    func pickerInputCellContentViewBecomeFirstRersponder(_ pickerInputCellContentView: PickerInputCellContentView) {
        cellBecomeFirstResponder()
    }
}

public protocol RowWithOptions {
    var rowOptions: [Any] { get }
}

open class _PickerInputRowCustom<T> : Row<PickerInputCellCustom<T>>, PickerInputHasCustomContentView, RowWithOptions, NoValueDisplayTextConformance where T: Equatable {
    public var rowOptions: [Any] {
        return options
    }
    
    open var noValueDisplayText: String? = nil
    open var options: [T] = []
    open var contentViewProvider: ViewProvider<PickerInputCellContentView>?
    
    required public init(tag: String?) {
        super.init(tag: tag)

    }
}

/// A generic row where the user can pick an option from a picker view displayed in the keyboard area
public final class PickerInputRowCustom<T>: _PickerInputRowCustom<T>, RowType where T: Equatable, T: InputTypeInitiable {

    required public init(tag: String?) {
        super.init(tag: tag)
    }
}
