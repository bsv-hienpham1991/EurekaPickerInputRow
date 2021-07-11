//
//  ViewController.swift
//  EurekaPickerInputRow
//
//  Created by Hien Pham on 3/13/20.
//  Copyright © 2020 BraveSoft Vietnam. All rights reserved.
//

import UIKit
import Eureka

class ViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpForm()
    }

    func setUpForm() {
        tableView.estimatedSectionHeaderHeight = 20
        
        let users: [Scientist] = [Scientist(id: 1, firstName: "Albert", lastName: "Einstein"),
                             Scientist(id: 2, firstName: "Isaac", lastName: "Newton"),
                             Scientist(id: 3, firstName: "Galileo", lastName: "Galilei"),
                             Scientist(id: 4, firstName: "Marie", lastName: "Curie"),
                             Scientist(id: 5, firstName: "Louis", lastName: "Pasteur"),
                             Scientist(id: 6, firstName: "Michael", lastName: "Faraday")]

        form +++ Section()
            <<< ProfileFormPickerRow<Scientist>() {row in
                row.title = "Select Scientist"
                row.options = users
                row.displayValueFor = { (option) in
                    return (option?.firstName ?? "") + " " + (option?.lastName ?? "")
                }
                row.noValueDisplayText = "Please select a scientist"
                row.add(rule: RuleClosure(closure: {[weak row] (value) -> ValidationError? in
                    if value == nil && (row?.options.count ?? 0) > 0 {
                        return ValidationError(msg: "")
                    }
                    return nil
                }))
                row.validationOptions = .validatesOnDemand
                row.disabled = Condition.function([row.tag ?? ""], {(form) -> Bool in
                    return (row.options.count <= 0)
                })
            }.cellSetup({ (cell, row) in
                if let unwrapped: ProfileFormPickerView = cell.customContentView as? ProfileFormPickerView {
                    unwrapped.topSpaceConstraint.constant = 32
                }
                cell.height = { UITableView.automaticDimension }
            })
            .onCellHighlightChanged({ (cell, row) in
                if cell.isFirstResponder == false {
                    row.validate()
                }
            })
            .onRowValidationChanged({ (cell, row) in
                UIView.performWithoutAnimation { [weak self] in
                    self?.tableView.performBatchUpdates({
                        row.updateCell()
                    }, completion: nil)
                }
            })
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}

struct Scientist: InputTypeInitiable {
    var id: Int
    var firstName: String
    var lastName: String


    var suggestionString: String {
        return "\(firstName) \(lastName)"
    }

    init(id: Int, firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.id = id
    }
    
    init?(string stringValue: String) {
        return nil
    }
}

extension Scientist: Equatable {
    static func == (lhs: Scientist, rhs: Scientist) -> Bool {
        return lhs.id == rhs.id && lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName
    }
}
